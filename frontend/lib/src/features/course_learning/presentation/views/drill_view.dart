import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../../../l10n/generated/app_localizations.dart';
import '../../../../core/services/asset_service.dart';
import '../../../../core/utils/localization_helper.dart';

class DrillView extends ConsumerStatefulWidget {
  final String? contentJson;
  final VoidCallback onComplete;

  const DrillView({super.key, required this.contentJson, required this.onComplete});

  @override
  ConsumerState<DrillView> createState() => _DrillViewState();
}

class _DrillViewState extends ConsumerState<DrillView> {
  final AudioPlayer _player = AudioPlayer();
  int? _playingIndex;

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _playAudio(int index, String url) async {
    try {
      setState(() => _playingIndex = index);
      
      final resolvedPath = await ref.read(assetServiceProvider).resolve(url);
      if (resolvedPath.startsWith('http')) {
        await _player.setUrl(resolvedPath);
      } else {
        await _player.setFilePath(resolvedPath);
      }
      
      await _player.play();
      if (mounted) setState(() => _playingIndex = null);
    } catch (e) {
      print('Audio error: $e');
      if (mounted) setState(() => _playingIndex = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (widget.contentJson == null) return Center(child: Text(l10n.noContentAvailable));
    final List<dynamic> items = jsonDecode(widget.contentJson!);

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final hasAudio = item['audio'] != null;
              final isPlaying = _playingIndex == index;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text('${l10n.drillBase}: ${item['base']}', style: Theme.of(context).textTheme.bodyLarge)),
                          if (hasAudio)
                            IconButton(
                              icon: Icon(isPlaying ? Icons.stop_circle : Icons.volume_up),
                              color: Theme.of(context).colorScheme.primary,
                              onPressed: () => _playAudio(index, item['audio']),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.arrow_forward, size: 16, color: Theme.of(context).colorScheme.secondary),
                          const SizedBox(width: 8),
                          Text('${l10n.drillSubstitute}: ${item['substitution']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle_outline, size: 16, color: Colors.green),
                            const SizedBox(width: 8),
                            Expanded(child: Text(getLocalized(context, item['result'] ?? ''), style: const TextStyle(fontStyle: FontStyle.italic))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
              child: Text(l10n.completeDrill),
            ),
          ),
        ),
      ],
    );
  }
}
