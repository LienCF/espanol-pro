import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../l10n/generated/app_localizations.dart';
import '../../../../core/presentation/widgets/chat_bubble.dart';
import '../../../../core/presentation/widgets/typing_indicator.dart';
import '../controllers/chat_controller.dart';

class RoleplayView extends ConsumerStatefulWidget {
  final String? contentJson;
  final VoidCallback onComplete;

  const RoleplayView({super.key, required this.contentJson, required this.onComplete});

  @override
  ConsumerState<RoleplayView> createState() => _RoleplayViewState();
}

class _RoleplayViewState extends ConsumerState<RoleplayView> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.contentJson != null) {
        final content = jsonDecode(widget.contentJson!);
        final systemPrompt = content['system_prompt'] ?? 'You are a helpful language tutor.';
        final initialMessage = content['initial_message'];
        ref.read(chatControllerProvider.notifier).initialize(systemPrompt, initialMessage);
      }
    });
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
    final chatState = ref.watch(chatControllerProvider);
    final messages = chatState.messages;
    final isTyping = chatState.isTyping;

    // Auto-scroll when messages change
    ref.listen(chatControllerProvider, (previous, next) {
      if (previous?.messages.length != next.messages.length) {
        _scrollToBottom();
      }
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${next.error}')));
      }
    });

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: messages.length + (isTyping ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == messages.length) {
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

              final msg = messages[index];
              final isUser = msg['role'] == 'user';

              return ChatBubble(
                message: msg['content'] ?? '',
                isMe: isUser,
                displayName: isUser ? 'You' : 'Carlos',
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
                  onSubmitted: (text) {
                    if (text.isNotEmpty) {
                      ref.read(chatControllerProvider.notifier).sendMessage(text);
                      _textController.clear();
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: () {
                  final text = _textController.text.trim();
                  if (text.isNotEmpty) {
                    ref.read(chatControllerProvider.notifier).sendMessage(text);
                    _textController.clear();
                  }
                },
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
