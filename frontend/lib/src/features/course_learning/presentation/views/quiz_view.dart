import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../../../l10n/generated/app_localizations.dart';
import '../../../../core/utils/localization_helper.dart';

class QuizView extends StatefulWidget {
  final String? contentJson;
  final Function(int score) onComplete;

  const QuizView({super.key, required this.contentJson, required this.onComplete});

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  List<dynamic> _questions = [];
  int _currentIndex = 0;
  int? _selectedOptionIndex;
  bool _isAnswered = false;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    if (widget.contentJson != null) {
      _questions = jsonDecode(widget.contentJson!);
    }
  }

  void _handleAnswer(int optionIndex) {
    if (_isAnswered) return;

    setState(() {
      _selectedOptionIndex = optionIndex;
      _isAnswered = true;
      if (optionIndex == _questions[_currentIndex]['correctIndex']) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _currentIndex++;
      _selectedOptionIndex = null;
      _isAnswered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_questions.isEmpty) return Center(child: Text(l10n.noQuizContent));

    if (_currentIndex >= _questions.length) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.emoji_events, size: 64, color: Colors.amber),
            const SizedBox(height: 16),
            Text(
              l10n.quizCompleted,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.scoreResult(_score, _questions.length),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => widget.onComplete(_score),
              child: Text(l10n.finishSave),
            ),
          ],
        ),
      );
    }

    final question = _questions[_currentIndex];
    final options = question['options'] as List<dynamic>;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LinearProgressIndicator(
            value: (_currentIndex + 1) / _questions.length,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.questionProgress(_currentIndex + 1, _questions.length),
            style: Theme.of(context).textTheme.labelLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            getLocalized(context, question['question']),
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ...options.asMap().entries.map((entry) {
            final index = entry.key;
            final text = getLocalized(context, entry.value);
            Color? backgroundColor;
            Color? foregroundColor;

            if (_isAnswered) {
              if (index == question['correctIndex']) {
                backgroundColor = Colors.green.shade100;
                foregroundColor = Colors.green.shade900;
              } else if (index == _selectedOptionIndex) {
                backgroundColor = Colors.red.shade100;
                foregroundColor = Colors.red.shade900;
              }
            } else if (index == _selectedOptionIndex) {
               backgroundColor = Theme.of(context).colorScheme.primaryContainer;
               foregroundColor = Theme.of(context).colorScheme.onPrimaryContainer;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: backgroundColor,
                  foregroundColor: foregroundColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(
                    color: _isAnswered && index == question['correctIndex']
                        ? Colors.green
                        : Theme.of(context).colorScheme.outline,
                    width: _isAnswered && index == question['correctIndex'] ? 2 : 1,
                  ),
                ),
                onPressed: () => _handleAnswer(index),
                child: Text(text, style: const TextStyle(fontSize: 16)),
              ),
            );
          }),
          const Spacer(),
          if (_isAnswered)
            FilledButton.icon(
              onPressed: _nextQuestion,
              icon: const Icon(Icons.arrow_forward),
              label: Text(_currentIndex < _questions.length - 1 ? l10n.nextQuestion : l10n.finishQuiz),
            ),
        ],
      ),
    );
  }
}
