import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:frontend/src/core/api/api_client.dart';
import 'package:frontend/src/core/auth/auth_repository.dart';

part 'chat_repository.g.dart';

class ChatResponse {
  final String response;
  final String conversationId;

  ChatResponse({required this.response, required this.conversationId});

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      response: json['response'] as String,
      conversationId: json['conversationId'] as String,
    );
  }
}

class ChatRepository {
  final Dio _api;
  final String? _userId;

  ChatRepository(this._api, this._userId);

  Future<ChatResponse> sendMessage({
    required String message,
    String? conversationId,
    bool reset = false,
  }) async {
    try {
      final response = await _api.post(
        '/api/ai/chat',
        data: {
          'message': message,
          'conversationId': conversationId,
          'reset': reset,
          'userId': _userId, // Redundant if sending token, but safe for now
        },
      );
      return ChatResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}

@riverpod
ChatRepository chatRepository(Ref ref) {
  final api = ref.watch(apiClientProvider);
  final user = ref.watch(currentUserProvider);
  return ChatRepository(api, user?.id);
}
