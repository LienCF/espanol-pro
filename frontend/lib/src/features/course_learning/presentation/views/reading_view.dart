import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../../../l10n/generated/app_localizations.dart';
import '../../../../core/utils/localization_helper.dart';

class ReadingView extends StatefulWidget {
  final String? contentJson;
  final Function(int score) onComplete;

  const ReadingView({super.key, required this.contentJson, required this.onComplete});

  @override
  State<ReadingView> createState() => _ReadingViewState();
}

class _ReadingViewState extends State<ReadingView> {
  late Map<String, dynamic> _data;
  List<dynamic> _questions = [];
  int _score = 0;
  final Set<int> _answeredQuestions = {};

  @override
  void initState() {
    super.initState();
    if (widget.contentJson != null) {
      _data = jsonDecode(widget.contentJson!);
      _questions = _data['questions'] ?? [];
    }
  }

  void _checkAnswer(int qIndex, int optionIndex) {
    if (_answeredQuestions.contains(qIndex)) return;

    final correctIndex = _questions[qIndex]['correctIndex'];
    setState(() {
      _answeredQuestions.add(qIndex);
      if (optionIndex == correctIndex) {
        _score++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (widget.contentJson == null) return Center(child: Text(l10n.noContentAvailable));

    final textContent = getLocalized(context, _data['text'] ?? '');
    // Simple heuristic: First line is title if it's short and uppercase-ish
    final lines = textContent.split('\n');
    String? title;
    String body = textContent;
    
    if (lines.isNotEmpty && lines.first.trim().isNotEmpty && lines.first.length < 50) {
      title = lines.first.trim();
      body = lines.sublist(1).join('\n').trim();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Article Section
          if (title != null) ...[
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
          ],
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
            ),
            child: Text(
              body,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.8, // Comfortable reading height
                fontSize: 16,
              ),
            ),
          ),
          
          const SizedBox(height: 40),
          Divider(color: Theme.of(context).colorScheme.outlineVariant),
          const SizedBox(height: 24),
          
          // Questions Section
          Text(
            'Comprehension Check',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _questions.length,
            separatorBuilder: (ctx, i) => const SizedBox(height: 32),
            itemBuilder: (context, index) {
              final q = _questions[index];
              final isAnswered = _answeredQuestions.contains(index);
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${index + 1}. ${getLocalized(context, q['question'])}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  ...q['options'].asMap().entries.map((entry) {
                    final optIndex = entry.key;
                    final optText = getLocalized(context, entry.value);
                    
                    Color? backgroundColor;
                    Color? foregroundColor;
                    Color borderColor = Theme.of(context).colorScheme.outline;
                    double borderWidth = 1;

                    if (isAnswered) {
                      if (optIndex == q['correctIndex']) {
                        backgroundColor = Colors.green.shade100;
                        foregroundColor = Colors.green.shade900;
                        borderColor = Colors.green;
                        borderWidth = 2;
                      } else if (_score > -1) { 
                         // We don't track *which* wrong answer was selected in simple state,
                         // but usually we'd highlight the selected wrong one. 
                         // For simplicity, we just show the correct one.
                      }
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: InkWell(
                        onTap: isAnswered ? null : () => _checkAnswer(index, optIndex),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: borderColor, width: borderWidth),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  optText,
                                  style: TextStyle(
                                    color: foregroundColor,
                                    fontWeight: isAnswered && optIndex == q['correctIndex'] ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ),
                              if (isAnswered && optIndex == q['correctIndex'])
                                const Icon(Icons.check_circle, color: Colors.green, size: 20),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              );
            },
          ),
          
          const SizedBox(height: 40),
          
          // Footer Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton.icon(
              onPressed: _answeredQuestions.length == _questions.length 
                  ? () => widget.onComplete(_score) 
                  : null,
              icon: const Icon(Icons.check),
              label: Text(l10n.finishReading),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
