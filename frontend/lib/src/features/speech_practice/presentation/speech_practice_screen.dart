import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'speech_practice_controller.dart';

class SpeechPracticeScreen extends ConsumerStatefulWidget {
  final String referenceText;

  const SpeechPracticeScreen({super.key, required this.referenceText});

  @override
  ConsumerState<SpeechPracticeScreen> createState() =>
      _SpeechPracticeScreenState();
}

class _SpeechPracticeScreenState extends ConsumerState<SpeechPracticeScreen> {
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final dir = await getApplicationDocumentsDirectory();
        final path =
            '${dir.path}/speech_practice_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await _audioRecorder.start(const RecordConfig(), path: path);
        setState(() {
          _isRecording = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error starting recording: $e')));
      }
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
      });

      if (path != null) {
        final file = File(path);
        // ignore: use_build_context_synchronously
        ref
            .read(speechPracticeControllerProvider.notifier)
            .evaluate(file, widget.referenceText);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error stopping recording: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(speechPracticeControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Speech Practice')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              widget.referenceText,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            if (state.isLoading)
              const CircularProgressIndicator()
            else if (state.hasError)
              Text(
                'Error: ${state.error}',
                style: const TextStyle(color: Colors.red),
              )
            else if (state.value != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        'Score: ${state.value!.score}',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: state.value!.score >= 80
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text('You said: "${state.value!.transcription}"'),
                      const SizedBox(height: 16),
                      if (state.value!.feedback.isNotEmpty) ...[
                        const Text(
                          'Feedback:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        for (final f in state.value!.feedback)
                          ListTile(
                            leading: const Icon(Icons.lightbulb),
                            title: Text(f),
                          ),
                      ],
                    ],
                  ),
                ),
              )
            else
              const Expanded(
                child: Center(
                  child: Text('Press and hold the mic to practice.'),
                ),
              ),

            const SizedBox(height: 32),
            GestureDetector(
              onLongPressStart: (_) => _startRecording(),
              onLongPressEnd: (_) => _stopRecording(),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: _isRecording
                      ? Colors.red
                      : Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    if (_isRecording)
                      BoxShadow(
                        color: Colors.red.withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 10,
                      ),
                  ],
                ),
                child: Icon(
                  _isRecording ? Icons.mic : Icons.mic_none,
                  size: 48,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Hold to Record'),
          ],
        ),
      ),
    );
  }
}
