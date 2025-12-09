import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../domain/speech_evaluation_repository.dart';
import '../domain/speech_evaluation_result.dart';

class SpeechEvaluationRepositoryImpl implements SpeechEvaluationRepository {
  final Dio _dio;

  SpeechEvaluationRepositoryImpl(this._dio);

  @override
  Future<SpeechEvaluationResult> evaluateSpeech({
    required File audioFile,
    required String referenceText,
  }) async {
    final fileName = audioFile.path.split('/').last;

    // Create FormData
    final formData = FormData.fromMap({
      'audio': await MultipartFile.fromFile(audioFile.path, filename: fileName),
      'referenceText': referenceText,
    });

    try {
      final response = await _dio.post(
        '/api/ai/evaluate-speech',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      return SpeechEvaluationResult.fromJson(response.data);
    } on DioException catch (e) {
      // In a real app, parse the error response properly
      throw Exception('Speech evaluation failed: ${e.message}');
    }
  }
}

// Manual provider to avoid generator issues
final speechEvaluationRepositoryProvider = Provider<SpeechEvaluationRepository>(
  (ref) {
    final dio = ref.read(apiClientProvider);
    return SpeechEvaluationRepositoryImpl(dio);
  },
);
