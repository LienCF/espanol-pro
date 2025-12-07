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
    String? error,
  }) = _ChatState;
}

@riverpod
class ChatController extends _$ChatController {
  late String _systemPrompt;

  @override
  ChatState build() {
    return const ChatState();
  }

  void initialize(String systemPrompt, String? initialMessage) {
    _systemPrompt = systemPrompt;
    if (initialMessage != null && state.messages.isEmpty) {
      state = state.copyWith(messages: [
        {'role': 'assistant', 'content': initialMessage}
      ]);
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
      
      // Construct payload with system prompt
      final apiMessages = [
        {'role': 'system', 'content': _systemPrompt},
        ...currentMessages
      ];

      final aiRawResponse = await repository.sendMessage(messages: apiMessages);
      
      // Parse Correction logic (moved from View)
      var aiReply = aiRawResponse;
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
        isTyping: false,
      );
    } catch (e) {
      state = state.copyWith(
        isTyping: false,
        error: e.toString(),
      );
    }
  }
}
