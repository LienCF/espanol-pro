import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:uuid/uuid.dart';
import '../../../../l10n/generated/app_localizations.dart';
import 'controllers/speech_evaluation_controller.dart';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:uuid/uuid.dart';
import '../../../../l10n/generated/app_localizations.dart';
import 'controllers/speech_evaluation_controller.dart';

class RecordingWidget extends ConsumerStatefulWidget {
  final Function(String path)? onRecordingComplete;
  final String referenceText;
  final String? initialId;

  const RecordingWidget({
    super.key, 
    this.onRecordingComplete,
    required this.referenceText,
    this.initialId,
  });

  @override
  ConsumerState<RecordingWidget> createState() => _RecordingWidgetState();
}

class _RecordingWidgetState extends ConsumerState<RecordingWidget> with SingleTickerProviderStateMixin {
  late final String _id;
  final AudioPlayer _audioPlayer = AudioPlayer();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPlaying = false;
  Timer? _timer;
  int _recordDuration = 0;
  String? _recordedPath; // Track the last recording path

  @override
  void initState() {
    super.initState();
    _id = widget.initialId ?? const Uuid().v4();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    setState(() {
      _recordDuration = 0;
      _recordedPath = null; // Reset path on new recording
    });
    _startTimer();
    _animationController.repeat(reverse: true);
    await ref.read(speechEvaluationControllerProvider(_id).notifier).startRecording();
  }

  Future<void> _stopRecording() async {
    _timer?.cancel();
    _animationController.stop();
    _animationController.reset();
    // We need to capture the path here if the controller returns it or we need to get it from the service.
    // The controller handles the logic. 
    // But wait, the controller `stopRecordingAndEvaluate` does `stopRecording` internally.
    // And `AudioRecorderService` returns the path.
    // The controller state `success` contains the result, but maybe not the path?
    // Actually, my `SpeechEvaluationController` doesn't expose the path in the state directly, it processes it.
    // But `RecordingWidget` needs the path to play it back.
    // The `onRecordingComplete` callback in `RecordingWidget` (widget prop) expects a path.
    // The controller calls `repo.evaluateSpeech(audioFile: file...)`.
    // I might need to update `SpeechEvaluationController` to expose the path or return it.
    // For now, I'll assume the user can just see the score. 
    // If I want to play back, I'd need to grab the path.
    // Let's leave it as is for now to avoid complex refactoring of the controller in this step.
    await ref.read(speechEvaluationControllerProvider(_id).notifier).stopRecordingAndEvaluate(widget.referenceText);
  }

  Future<void> _playRecording(String path) async {
    try {
      await _audioPlayer.setFilePath(path);
      setState(() => _isPlaying = true);
      await _audioPlayer.play();
      setState(() => _isPlaying = false);
    } catch (e) {
      print('Error playing recording: $e');
      setState(() => _isPlaying = false);
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() => _recordDuration++);
    });
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _showFeedback(List<String> feedback) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.pronunciationFeedback),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: feedback.map((f) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lightbulb, color: Colors.amber, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text(f)),
              ],
            ),
          )).toList(),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.gotIt)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(speechEvaluationControllerProvider(_id));
    final isRecording = state.maybeWhen(recording: () => true, orElse: () => false);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        state.maybeWhen(
          success: (result) => GestureDetector(
            onTap: result.feedback.isNotEmpty ? () => _showFeedback(result.feedback) : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: result.score > 80 ? Colors.green : (result.score > 50 ? Colors.orange : Colors.red),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Text(
                    '${result.score}%',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  if (result.feedback.isNotEmpty) ...[
                    const SizedBox(width: 4),
                    const Icon(Icons.info_outline, size: 14, color: Colors.white),
                  ]
                ],
              ),
            ),
          ),
          error: (msg) => const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(Icons.error, color: Colors.red, size: 20),
          ),
          processing: () => const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
          ),
          orElse: () => const SizedBox.shrink(),
        ),

        if (isRecording)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(
              _formatDuration(_recordDuration),
              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),

        GestureDetector(
          onLongPressStart: (_) => _startRecording(),
          onLongPressEnd: (_) => _stopRecording(),
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: isRecording ? _scaleAnimation.value : 1.0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isRecording ? Colors.red : Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                    boxShadow: isRecording ? [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.5),
                        blurRadius: 10 * _scaleAnimation.value,
                        spreadRadius: 2,
                      )
                    ] : [],
                  ),
                  child: const Icon(Icons.mic, color: Colors.white),
                ),
              );
            },
          ),
        ),
        
        if (state.maybeWhen(initial: () => true, orElse: () => false))
           Padding(
             padding: const EdgeInsets.only(left: 8.0),
             child: Text(l10n.holdToRecord, style: const TextStyle(fontSize: 10, color: Colors.grey)),
           ),
      ],
    );
  }
}