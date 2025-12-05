import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../../core/api/api_client.dart';
import '../../../core/presentation/widgets/chat_bubble.dart';
import '../../../core/presentation/widgets/typing_indicator.dart';
import '../../course_learning/data/course_repository.dart';
import '../../course_learning/domain/lesson.dart';
import 'recording_widget.dart';

class LessonPlayerScreen extends ConsumerWidget {
  final String lessonId;
  final String courseId; // Need this for progress tracking

  const LessonPlayerScreen({
    super.key,
    required this.lessonId,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonAsync = ref.watch(lessonDetailProvider(lessonId));

    return Scaffold(
      appBar: AppBar(
        title: lessonAsync.when(
          data: (lesson) => Text(lesson?.title ?? 'Lesson'),
          loading: () => const Text('Loading...'),
          error: (_, __) => const Text('Error'),
        ),
      ),
      body: lessonAsync.when(
        data: (lesson) {
          if (lesson == null) return const Center(child: Text('Lesson not found'));
          return _buildLessonContent(context, lesson, ref);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildLessonContent(BuildContext context, Lesson lesson, WidgetRef ref) {
    switch (lesson.contentType) {
      case 'DIALOGUE':
        return _DialogueView(
          contentJson: lesson.contentJson,
          onComplete: () => _markComplete(ref, context),
        );
      case 'DRILL':
        return _DrillView(
          contentJson: lesson.contentJson,
          onComplete: () => _markComplete(ref, context),
        );
      case 'AUDIO_DRILL':
        return const Center(child: Text('Audio Drill Module Coming Soon'));
      case 'QUIZ':
        return _QuizView(
          contentJson: lesson.contentJson,
          onComplete: (score) => _markComplete(ref, context, isQuiz: true, score: score),
        );
      case 'ROLEPLAY':
        return _RoleplayView(
          contentJson: lesson.contentJson,
          onComplete: () => _markComplete(ref, context),
        );
      default:
        return const Center(child: Text('Unknown Lesson Type'));
    }
  }

  void _markComplete(WidgetRef ref, BuildContext context, {bool isQuiz = false, int? score}) {
    ref.read(courseRepositoryProvider).saveLessonProgress(
          lessonId: lessonId,
          courseId: courseId,
          isCorrect: isQuiz ? (score != null && score > 0) : true, // Simple logic for now
          interactionType: isQuiz ? 'QUIZ' : 'COMPLETION',
        );
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lesson Completed!')));
    Navigator.of(context).pop();
  }
}

class _DialogueView extends StatefulWidget {
  final String? contentJson;
  final VoidCallback onComplete;

  const _DialogueView({required this.contentJson, required this.onComplete});

  @override
  State<_DialogueView> createState() => _DialogueViewState();
}

class _DialogueViewState extends State<_DialogueView> {
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
      
      await _player.setUrl(audioRef);
      await _player.play();
      
      if (mounted) {
        setState(() {
          _playingIndex = null;
        });
      }
    } catch (e) {
      print('Audio Playback Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error playing audio: $e')),
        );
        setState(() {
          _playingIndex = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.contentJson == null) return const Center(child: Text('No content available'));

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
                            Text(line['en'] ?? '', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey)),
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
              child: const Text('Complete Lesson'),
            ),
          ),
        ),
      ],
    );
  }
}

class _DrillView extends StatelessWidget {
  final String? contentJson;
  final VoidCallback onComplete;

  const _DrillView({required this.contentJson, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    if (contentJson == null) return const Center(child: Text('No content available'));

    final List<dynamic> items = jsonDecode(contentJson!);

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Base: ${item['base']}', style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.arrow_forward, size: 16, color: Theme.of(context).colorScheme.secondary),
                          const SizedBox(width: 8),
                          Text('Substitute: ${item['substitution']}', style: const TextStyle(fontWeight: FontWeight.bold)),
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
                            Expanded(child: Text(item['result'] ?? '', style: const TextStyle(fontStyle: FontStyle.italic))),
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
              onPressed: onComplete,
              child: const Text('Complete Drill'),
            ),
          ),
        ),
      ],
    );
  }
}

class _QuizView extends StatefulWidget {
  final String? contentJson;
  final Function(int score) onComplete;

  const _QuizView({required this.contentJson, required this.onComplete});

  @override
  State<_QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<_QuizView> {
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
    if (_questions.isEmpty) return const Center(child: Text('No quiz content available'));

    if (_currentIndex >= _questions.length) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.emoji_events, size: 64, color: Colors.amber),
            const SizedBox(height: 16),
            Text(
              'Quiz Completed!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Score: $_score / ${_questions.length}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => widget.onComplete(_score),
              child: const Text('Finish & Save'),
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
            'Question ${_currentIndex + 1} of ${_questions.length}',
            style: Theme.of(context).textTheme.labelLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            question['question'],
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ...options.asMap().entries.map((entry) {
            final index = entry.key;
            final text = entry.value;
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
              label: Text(_currentIndex < _questions.length - 1 ? 'Next Question' : 'Finish Quiz'),
            ),
        ],
      ),
    );
  }
}

class _RoleplayView extends ConsumerStatefulWidget {
  final String? contentJson;
  final VoidCallback onComplete;

  const _RoleplayView({required this.contentJson, required this.onComplete});

  @override
  ConsumerState<_RoleplayView> createState() => _RoleplayViewState();
}

class _RoleplayViewState extends ConsumerState<_RoleplayView> {
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  late String _systemPrompt;

  @override
  void initState() {
    super.initState();
    if (widget.contentJson != null) {
      final content = jsonDecode(widget.contentJson!);
      _systemPrompt = content['system_prompt'] ?? 'You are a helpful language tutor.';
      final initialMessage = content['initial_message'];
      if (initialMessage != null) {
        _messages.add({'role': 'assistant', 'content': initialMessage});
      }
    }
  }

  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'content': text});
      _isTyping = true;
      _textController.clear();
    });
    _scrollToBottom();

    try {
      final api = ref.read(apiClientProvider);
      
      // Construct message history for the API
      final apiMessages = [
        {'role': 'system', 'content': _systemPrompt},
        ..._messages
      ];

      final response = await api.post('/api/ai/chat', data: {'messages': apiMessages});
      final aiReply = response.data['response'];

      if (mounted) {
        setState(() {
          _messages.add({'role': 'assistant', 'content': aiReply});
          _isTyping = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      print('Chat error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to get response')));
        setState(() => _isTyping = false);
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length + (_isTyping ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _messages.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        radius: 16,
                        child: Icon(Icons.smart_toy, size: 18),
                      ),
                      SizedBox(width: 8),
                      TypingIndicator(),
                    ],
                  ),
                );
              }

              final msg = _messages[index];
              final isUser = msg['role'] == 'user';

              return ChatBubble(
                message: msg['content'] ?? '',
                isMe: isUser,
                displayName: isUser ? 'You' : 'Carlos', // Could be dynamic
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          color: Theme.of(context).colorScheme.surface,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    hintText: 'Type your response (in Spanish)...',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: _sendMessage,
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: widget.onComplete,
              child: const Text('End Chat & Complete'),
            ),
          ),
        ),
      ],
    );
  }
}
