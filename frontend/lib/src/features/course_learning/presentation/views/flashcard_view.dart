import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../../../l10n/generated/app_localizations.dart';
import '../../../../core/services/asset_service.dart';
import '../../../../core/utils/localization_helper.dart';

class FlashcardView extends ConsumerStatefulWidget {
  final String? contentJson;
  final VoidCallback onComplete;

  const FlashcardView({
    super.key,
    required this.contentJson,
    required this.onComplete,
  });

  @override
  ConsumerState<FlashcardView> createState() => _FlashcardViewState();
}

class _FlashcardViewState extends ConsumerState<FlashcardView> {
  List<dynamic> _cards = [];
  int _currentIndex = 0;
  bool _isFlipped = false;
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    if (widget.contentJson != null) {
      _cards = jsonDecode(widget.contentJson!);
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _playAudio(String url) async {
    try {
      setState(() => _isPlaying = true);

      final resolvedPath = await ref.read(assetServiceProvider).resolve(url);
      if (resolvedPath.startsWith('http')) {
        await _player.setUrl(resolvedPath);
      } else {
        await _player.setFilePath(resolvedPath);
      }

      await _player.play();
      if (mounted) setState(() => _isPlaying = false);
    } catch (e) {
      print('Audio error: $e');
      if (mounted) setState(() => _isPlaying = false);
    }
  }

  void _flipCard() {
    setState(() {
      _isFlipped = !_isFlipped;
    });
  }

  void _nextCard() {
    if (_currentIndex < _cards.length - 1) {
      setState(() {
        _currentIndex++;
        _isFlipped = false;
      });
    } else {
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_cards.isEmpty) return Center(child: Text(l10n.noFlashcards));

    final card = _cards[_currentIndex];
    final hasAudio = card['audio'] != null;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Text(
            'Card ${_currentIndex + 1} of ${_cards.length}',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const Spacer(),
          GestureDetector(
            onTap: _flipCard,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: _isFlipped ? Colors.blue.shade100 : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue.shade200, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _isFlipped
                                ? getLocalized(context, card['back'])
                                : getLocalized(context, card['front']),
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: _isFlipped
                                      ? Colors.blue.shade900
                                      : Colors.black87,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          if (_isFlipped && card['example'] != null) ...[
                            const SizedBox(height: 24),
                            Text(
                              getLocalized(
                                context,
                                card['example'],
                              ), // Localized Example
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black54,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                          const SizedBox(height: 40),
                          Text(
                            _isFlipped ? l10n.tapToFlip : l10n.tapToReveal,
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (hasAudio)
                    Positioned(
                      top: 16,
                      right: 16,
                      child: IconButton(
                        icon: Icon(
                          _isPlaying ? Icons.stop_circle : Icons.volume_up,
                        ),
                        onPressed: () => _playAudio(card['audio']),
                        iconSize: 32,
                        color: _isFlipped ? Colors.blue.shade900 : Colors.blue,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const Spacer(),
          FilledButton.icon(
            onPressed: _nextCard,
            icon: const Icon(Icons.arrow_forward),
            label: Text(
              _currentIndex < _cards.length - 1 ? l10n.nextCard : l10n.finish,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
