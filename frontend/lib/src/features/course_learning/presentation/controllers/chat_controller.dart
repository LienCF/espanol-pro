import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/chat_repository.dart';

part 'chat_controller.freezed.dart';
part 'chat_controller.g.dart';

@freezed
abstract class ChatState with _$ChatState {
  const factory ChatState({
    @Default([]) List<Map<String, String>> messages,
    @Default(false) bool isTyping,
    String? conversationId,
    String? error,
  }) = _ChatState;
}

@riverpod
class ChatController extends _$ChatController {
  // We don't need system prompt here anymore as it's handled on server,
  // but we might keep it for local display if we wanted to show it (we don't usually).

  @override
  ChatState build() {
    return const ChatState();
  }

  void initialize(String systemPrompt, String? initialMessage) {
    // System prompt is now server-side managed based on context,
    // but we might want to pass it if the API supported dynamic system prompts per lesson.
    // For now, we'll assume the API uses a standard prompt or we'll update API to accept it later.
    // The current API uses a hardcoded prompt.

    if (initialMessage != null && state.messages.isEmpty) {
      state = state.copyWith(
        messages: [
          {'role': 'assistant', 'content': initialMessage},
        ],
      );
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message immediately
    final currentMessages = List<Map<String, String>>.from(state.messages);
    currentMessages.add({'role': 'user', 'content': text});

    state = state.copyWith(
      messages: currentMessages,
      isTyping: true,
      error: null,
    );

    try {
      final repository = ref.read(chatRepositoryProvider);

      final chatResponse = await repository.sendMessage(
        message: text,
        conversationId: state.conversationId,
        // If it's the first message (messages.length == 1 because we just added user msg),
        // AND we don't have a conversationId yet, we might want to reset to be safe,
        // but the API handles new IDs as new convs.
        reset: state.conversationId == null,
      );

      // Parse Correction logic
      var aiReply = chatResponse.response;
      String? correction;

      final correctionRegex = RegExp(r'\[CORRECTION:(.*?)\]', dotAll: true);
      final match = correctionRegex.firstMatch(aiReply);
      if (match != null) {
        correction = match.group(1)?.trim();
        aiReply = aiReply.replaceAll(match.group(0)!, '').trim();
      }

      final newMessage = {'role': 'assistant', 'content': aiReply};
      if (correction != null) {
        newMessage['correction'] = correction;
      }

      state = state.copyWith(
        messages: [...currentMessages, newMessage],
        conversationId: chatResponse.conversationId,
        isTyping: false,
      );
    } catch (e) {
      state = state.copyWith(isTyping: false, error: e.toString());
    }
  }
}
