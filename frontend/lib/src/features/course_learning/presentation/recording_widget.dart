import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import '../../../core/api/api_client.dart';

class RecordingWidget extends ConsumerStatefulWidget {
  final Function(String path) onRecordingComplete;
  final String referenceText;

  const RecordingWidget({
    super.key, 
    required this.onRecordingComplete,
    required this.referenceText,
  });

  @override
  ConsumerState<RecordingWidget> createState() => _RecordingWidgetState();
}

class _RecordingWidgetState extends ConsumerState<RecordingWidget> {
  late final AudioRecorder _audioRecorder;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isRecording = false;
  bool _isPlaying = false;
  bool _isEvaluating = false;
  String? _recordedPath;
  Timer? _timer;
  int _recordDuration = 0;
  int? _score;

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final directory = await getApplicationDocumentsDirectory();
        final path = '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

        // Start recording to file
        await _audioRecorder.start(const RecordConfig(), path: path);

        setState(() {
          _isRecording = true;
          _recordDuration = 0;
          _recordedPath = null;
          _score = null;
        });

        _startTimer();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Microphone permission not granted')),
          );
        }
      }
    } catch (e) {
      print('Error starting record: $e');
    }
  }

  Future<void> _stopRecording() async {
    _timer?.cancel();
    final path = await _audioRecorder.stop();

    setState(() {
      _isRecording = false;
      _recordedPath = path;
    });

    if (path != null) {
      widget.onRecordingComplete(path);
      _evaluateSpeech(path);
    }
  }

  Future<void> _evaluateSpeech(String path) async {
    setState(() => _isEvaluating = true);
    try {
      final api = ref.read(apiClientProvider);
      
      // 1. Get Presigned URL
      final filename = path.split('/').last;
      final presignRes = await api.post('/api/upload/presign', data: {
        'filename': filename,
        'contentType': 'audio/mp4',
      });
      final uploadUrl = presignRes.data['uploadUrl'];
      final key = presignRes.data['key'];

      // 2. Upload to R2 directly
      final file = File(path);
      final fileBytes = await file.readAsBytes();
      
      // Use a fresh Dio instance to avoid base URL/interceptor issues
      await Dio().put(
        uploadUrl, 
        data: Stream.fromIterable([fileBytes]),
        options: Options(
          headers: {
            'Content-Type': 'audio/mp4',
            'Content-Length': fileBytes.length,
          },
        )
      );

      // 3. Evaluate using R2 Key
      final response = await api.post('/api/ai/evaluate-speech', data: {
        'fileKey': key,
        'reference_text': widget.referenceText,
      });
      
      if (mounted) {
        setState(() {
          _score = response.data['score'];
        });
      }
    } catch (e) {
      print('Evaluation error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Speech evaluation failed')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isEvaluating = false);
      }
    }
  }

  Future<void> _playRecording() async {
    if (_recordedPath != null) {
      try {
        await _audioPlayer.setFilePath(_recordedPath!);
        setState(() => _isPlaying = true);
        await _audioPlayer.play();
        setState(() => _isPlaying = false);
      } catch (e) {
        print('Error playing recording: $e');
        setState(() => _isPlaying = false);
      }
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

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_score != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: _score! > 80 ? Colors.green : (_score! > 50 ? Colors.orange : Colors.red),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$_score%',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        if (_isEvaluating)
          const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
          ),
        if (_isRecording)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(
              _formatDuration(_recordDuration),
              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        if (_recordedPath != null && !_isRecording && !_isEvaluating)
          IconButton(
            icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
            onPressed: _isPlaying ? () async { await _audioPlayer.stop(); setState(() => _isPlaying = false); } : _playRecording,
            color: Colors.green,
          ),
        GestureDetector(
          onLongPressStart: (_) => _startRecording(),
          onLongPressEnd: (_) => _stopRecording(),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _isRecording ? Colors.red : Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.mic, color: Colors.white),
          ),
        ),
        if (!_isRecording && _recordedPath == null)
           const Padding(
             padding: EdgeInsets.only(left: 8.0),
             child: Text("Hold to record", style: TextStyle(fontSize: 10, color: Colors.grey)),
           ),
      ],
    );
  }
}
