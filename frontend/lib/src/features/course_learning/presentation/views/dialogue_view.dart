import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../../../l10n/generated/app_localizations.dart';
import '../../../../core/services/asset_service.dart';
import '../../../../core/utils/localization_helper.dart';
import '../recording_widget.dart';

class DialogueView extends ConsumerStatefulWidget {
  final String? contentJson;
  final VoidCallback onComplete;

  const DialogueView({super.key, required this.contentJson, required this.onComplete});

  @override
  ConsumerState<DialogueView> createState() => _DialogueViewState();
}

class _DialogueViewState extends ConsumerState<DialogueView> {
  final AudioPlayer _player = AudioPlayer();
  int? _playingIndex;

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _playAudio(int index, String audioRef) async {
    print('Attempting to play audio from: $audioRef');
    try {
      setState(() {
        _playingIndex = index;
      });
      
      final resolvedPath = await ref.read(assetServiceProvider).resolve(audioRef);
      if (resolvedPath.startsWith('http')) {
        await _player.setUrl(resolvedPath);
      } else {
        await _player.setFilePath(resolvedPath);
      }
      
      await _player.play();
      
      if (mounted) {
        setState(() {
          _playingIndex = null;
        });
      }
    } catch (e) {
      print('Audio Playback Error: $e');
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.audioPlaybackError(e.toString()))),
        );
        setState(() {
          _playingIndex = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (widget.contentJson == null) return Center(child: Text(l10n.noContentAvailable));
    final List<dynamic> lines = jsonDecode(widget.contentJson!);

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: lines.length,
            separatorBuilder: (ctx, i) => const Divider(),
            itemBuilder: (context, index) {
              final line = lines[index];
              final isPlaying = _playingIndex == index;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        child: Text(line['speaker'] ?? '?', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(line['es'] ?? '', style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 4),
                            Text(
                              getLocalized(context, line['translation'] ?? line['en'] ?? ''),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: isPlaying 
                          ? const SizedBox(
                              width: 24, 
                              height: 24, 
                              child: CircularProgressIndicator(strokeWidth: 2)
                            ) 
                          : const Icon(Icons.play_circle_outline),
                        onPressed: isPlaying ? null : () => _playAudio(index, line['audio_ref']),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: RecordingWidget(
                        referenceText: line['es'] ?? '',
                        onRecordingComplete: (path) {
                          print('Recorded to: $path');
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: widget.onComplete,
              child: Text(l10n.completeLesson),
            ),
          ),
        ),
      ],
    );
  }
}
