import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'content_sync_service.dart';

part 'audio_player_service.g.dart';

class AudioPlayerService {
  final AudioPlayer _player = AudioPlayer();
  final ContentSyncService _syncService;

  AudioPlayerService(this._syncService);

  Future<void> play(String url) async {
    try {
      // 1. Check for local file
      final localFile = await _syncService.getLocalAsset(url);

      if (localFile != null) {
        print('Playing from local cache: ${localFile.path}');
        await _player.setFilePath(localFile.path);
      } else {
        print('Playing from network: $url');
        await _player.setUrl(url);
      }

      await _player.play();
    } catch (e) {
      print('Error playing audio: $e');
      rethrow;
    }
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> stop() async {
    await _player.stop();
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}

@riverpod
AudioPlayerService audioPlayerService(Ref ref) {
  final syncService = ref.watch(contentSyncServiceProvider);
  final service = AudioPlayerService(syncService);

  ref.onDispose(() {
    service.dispose();
  });

  return service;
}
