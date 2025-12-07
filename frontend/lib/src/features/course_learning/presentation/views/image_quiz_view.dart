import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../../../l10n/generated/app_localizations.dart';
import '../../../../core/services/asset_service.dart';
import '../../../../core/utils/localization_helper.dart';

class ImageQuizView extends ConsumerStatefulWidget {
  final String? contentJson;
  final Function(int score) onComplete;

  const ImageQuizView({super.key, required this.contentJson, required this.onComplete});

  @override
  ConsumerState<ImageQuizView> createState() => _ImageQuizViewState();
}

class _ImageQuizViewState extends ConsumerState<ImageQuizView> {
  final AudioPlayer _player = AudioPlayer();
  List<dynamic> _items = [];
  int _currentIndex = 0;
  int _score = 0;
  bool _isAnswered = false;
  String? _feedback;

  @override
  void initState() {
    super.initState();
    if (widget.contentJson != null) {
      _items = jsonDecode(widget.contentJson!);
    }
    _playPrompt();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _playPrompt() async {
    if (_items.isEmpty) return;
    final item = _items[_currentIndex];
    final url = item['question_audio'];
    
    if (url != null) {
      try {
        final resolvedPath = await ref.read(assetServiceProvider).resolve(url);
        if (resolvedPath.startsWith('http')) {
          await _player.setUrl(resolvedPath);
        } else {
          await _player.setFilePath(resolvedPath);
        }
        await _player.play();
      } catch (e) {
        print('Error playing prompt: $e');
      }
    }
  }

  void _handleSelection(bool isCorrect) {
    if (_isAnswered) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _isAnswered = true;
      if (isCorrect) {
        _score++;
        _feedback = l10n.correct;
      } else {
        _feedback = l10n.incorrect;
      }
    });
  }

  void _next() {
    if (_currentIndex < _items.length - 1) {
      setState(() {
        _currentIndex++;
        _isAnswered = false;
        _feedback = null;
      });
      _playPrompt();
    } else {
      widget.onComplete(_score);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_items.isEmpty) return Center(child: Text(l10n.noContentAvailable));
    final item = _items[_currentIndex];

    return Column(
      children: [
        const SizedBox(height: 24),
        Text(l10n.listenAndSelect, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        IconButton.filled(
          icon: const Icon(Icons.volume_up, size: 32),
          onPressed: _playPrompt,
        ),
        const SizedBox(height: 16),
        Text(getLocalized(context, item['prompt'] ?? ''), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            itemCount: item['options'].length,
            itemBuilder: (context, index) {
              final opt = item['options'][index];
              final isCorrect = opt['correct'] == true;
              
              return InkWell(
                onTap: () => _handleSelection(isCorrect),
                child: Container(
                  decoration: BoxDecoration(
                    border: _isAnswered && isCorrect 
                      ? Border.all(color: Colors.green, width: 4) 
                      : Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.image, size: 48, color: Colors.grey), 
                      const SizedBox(height: 8),
                      Text(getLocalized(context, opt['text']), textAlign: TextAlign.center),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        if (_feedback != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(_feedback!, style: TextStyle(
              fontSize: 20, 
              color: _feedback == l10n.correct ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold
            )),
          ),
        if (_isAnswered)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(onPressed: _next, child: Text(l10n.continueBtn)),
            ),
          ),
      ],
    );
  }
}
