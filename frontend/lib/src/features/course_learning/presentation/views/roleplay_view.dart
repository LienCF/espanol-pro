import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../l10n/generated/app_localizations.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/presentation/widgets/chat_bubble.dart';
import '../../../../core/presentation/widgets/typing_indicator.dart';

class RoleplayView extends ConsumerStatefulWidget {
  final String? contentJson;
  final VoidCallback onComplete;

  const RoleplayView({super.key, required this.contentJson, required this.onComplete});

  @override
  ConsumerState<RoleplayView> createState() => _RoleplayViewState();
}

class _RoleplayViewState extends ConsumerState<RoleplayView> {
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
      var aiReply = response.data['response'] as String;
      String? correction;

      // Parse Correction
      final correctionRegex = RegExp(r'\[CORRECTION:(.*?)\]', dotAll: true);
      final match = correctionRegex.firstMatch(aiReply);
      if (match != null) {
        correction = match.group(1)?.trim();
        aiReply = aiReply.replaceAll(match.group(0)!, '').trim();
      }

      if (mounted) {
        setState(() {
          final message = {'role': 'assistant', 'content': aiReply};
          if (correction != null) {
            message['correction'] = correction;
          }
          _messages.add(message);
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
    final l10n = AppLocalizations.of(context)!;
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
                correction: msg['correction'],
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
                  decoration: InputDecoration(
                    hintText: l10n.typeResponse,
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
              child: Text(l10n.endChat),
            ),
          ),
        ),
      ],
    );
  }
}
