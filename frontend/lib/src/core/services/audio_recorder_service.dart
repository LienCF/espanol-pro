import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'audio_recorder_service.g.dart';

class AudioRecorderService {
  final AudioRecorder _recorder = AudioRecorder();

  Future<bool> hasPermission() async {
    return await _recorder.hasPermission();
  }

  Future<void> startRecording() async {
    if (await hasPermission()) {
       final dir = await getTemporaryDirectory();
       final path = '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
       
       const config = RecordConfig(encoder: AudioEncoder.aacLc);
       
       await _recorder.start(config, path: path);
    } else {
      throw Exception('Microphone permission denied');
    }
  }

  Future<String?> stopRecording() async {
    return await _recorder.stop();
  }
  
  Future<void> dispose() async {
    _recorder.dispose();
  }

  Future<bool> isRecording() async {
    return await _recorder.isRecording();
  }
}

@riverpod
AudioRecorderService audioRecorderService(Ref ref) {
  final service = AudioRecorderService();
  ref.onDispose(() => service.dispose());
  return service;
}
