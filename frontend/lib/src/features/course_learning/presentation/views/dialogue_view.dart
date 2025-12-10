import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../l10n/generated/app_localizations.dart';
import '../../../../core/services/audio_player_service.dart';
import '../../../../core/utils/localization_helper.dart';
import '../recording_widget.dart';

class DialogueView extends ConsumerStatefulWidget {
  final String? contentJson;
  final VoidCallback onComplete;
  final String lessonId;

  const DialogueView({
    super.key,
    required this.contentJson,
    required this.onComplete,
    required this.lessonId,
  });

  @override
  ConsumerState<DialogueView> createState() => _DialogueViewState();
}

class _DialogueViewState extends ConsumerState<DialogueView> {
  int? _playingIndex;

  Future<void> _playAudio(int index, String audioRef) async {
    // Construct full URL if relative
    // Actually, syncService handles resolving local files via getLocalAsset,
    // but audioPlayerService expects a URL to decide whether to check cache.
    // audioRef might be "audio/foo.mp3".

    // We need to ensure we pass a consistent ID/URL to audioPlayerService.
    // Let's use the same logic: if it starts with http, fine. If not, prepend baseUrl or let the service handle it?
    // The ContentSyncService.downloadAssets logic assumes it might prepend base URL if relative.

    // Let's simplify: pass the audioRef as is. The Service should handle normalization or checks.
    // But wait, our `AudioPlayerService` implementation checks `getLocalAsset(url)`.
    // `getLocalAsset` checks if file exists at `assets/basename(url)`.

    try {
      setState(() {
        _playingIndex = index;
      });

      final player = ref.read(audioPlayerServiceProvider);
      // Note: JustAudio's player state management is inside the service now.
      // Ideally we should listen to player state to toggle _playingIndex off.
      // For MVP, we await play().

      await player.play(audioRef);

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
    if (widget.contentJson == null) {
      return Center(child: Text(l10n.noContentAvailable));
    }
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
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primaryContainer,
                        child: Text(
                          line['speaker'] ?? '?',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              line['es'] ?? '',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              getLocalized(
                                context,
                                line['translation'] ?? line['en'] ?? '',
                              ),
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: isPlaying
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.play_circle_outline),
                        onPressed: isPlaying
                            ? null
                            : () => _playAudio(index, line['audio_ref']),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: RecordingWidget(
                        id: 'dialogue_$index',
                        referenceText: line['es'] ?? '',
                        lessonId: widget.lessonId,
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
