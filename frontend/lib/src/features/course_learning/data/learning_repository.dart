import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:frontend/src/core/api/api_client.dart';

part 'learning_repository.g.dart';

class LearningRepository {
  final Dio _api;

  LearningRepository(this._api);

  Future<void> recordAttempt({
    required String lessonId,
    required bool isCorrect,
    String? userId,
  }) async {
    try {
      await _api.post(
        '/api/learning/attempt',
        data: {
          'lessonId': lessonId,
          'isCorrect': isCorrect,
          if (userId != null) 'userId': userId,
        },
      );
    } catch (e) {
      // Log error but don't block the user flow, BKT can fail silently
      debugPrint('Failed to record learning attempt: $e');
    }
  }
}

@riverpod
LearningRepository learningRepository(Ref ref) {
  final api = ref.watch(apiClientProvider);
  return LearningRepository(api);
}
