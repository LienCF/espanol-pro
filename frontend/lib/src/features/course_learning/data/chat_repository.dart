import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:frontend/src/core/api/api_client.dart';

part 'chat_repository.g.dart';

class ChatRepository {
  final Dio _api;

  ChatRepository(this._api);

  Future<String> sendMessage({
    required List<Map<String, String>> messages,
  }) async {
    try {
      final response = await _api.post('/api/ai/chat', data: {'messages': messages});
      return response.data['response'] as String;
    } catch (e) {
      rethrow;
    }
  }
}

@riverpod
ChatRepository chatRepository(Ref ref) {
  final api = ref.watch(apiClientProvider);
  return ChatRepository(api);
}
