import 'dart:io';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_client.dart';
import '../domain/speech_evaluation_result.dart';

part 'speech_evaluation_repository.g.dart';

class SpeechEvaluationRepository {
  final Dio _api;

  SpeechEvaluationRepository(this._api);

  Future<SpeechEvaluationResult> evaluateSpeech({
    required File audioFile,
    required String referenceText,
    String? userId,
  }) async {
    final formData = FormData.fromMap({
      'audio': await MultipartFile.fromFile(
        audioFile.path,
        filename: 'recording.wav', // Helper for backend to identify file type
      ),
      'referenceText': referenceText,
      if (userId != null) 'userId': userId,
    });

    try {
      final response = await _api.post(
        '/api/ai/evaluate-speech',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      return SpeechEvaluationResult.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}

@riverpod
SpeechEvaluationRepository speechEvaluationRepository(Ref ref) {
  final api = ref.watch(apiClientProvider);
  return SpeechEvaluationRepository(api);
}
