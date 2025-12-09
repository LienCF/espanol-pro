import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:frontend/src/features/speech_practice/data/speech_evaluation_repository_impl.dart';
import 'package:frontend/src/features/speech_practice/domain/speech_evaluation_result.dart';

@GenerateMocks([Dio])
import 'speech_evaluation_repository_test.mocks.dart';

void main() {
  late MockDio mockDio;
  late SpeechEvaluationRepositoryImpl repository;

  setUp(() {
    mockDio = MockDio();
    repository = SpeechEvaluationRepositoryImpl(mockDio);
  });

  test('evaluateSpeech returns SpeechEvaluationResult on success', () async {
    // Arrange
    final file = File('test_audio.mp3');
    await file.writeAsString('dummy content');

    try {
      const referenceText = 'Hola mundo';
      final responsePayload = {
        'score': 95,
        'transcription': 'Hola mundo',
        'is_match': true,
        'feedback': ['Great job!'],
      };

      when(
        mockDio.post(
          '/api/ai/evaluate-speech',
          data: anyNamed('data'),
          options: anyNamed('options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/api/ai/evaluate-speech'),
          data: responsePayload,
          statusCode: 200,
        ),
      );

      // Act
      final result = await repository.evaluateSpeech(
        audioFile: file,
        referenceText: referenceText,
      );

      // Assert
      expect(result, isA<SpeechEvaluationResult>());
      expect(result.score, 95);
      expect(result.transcription, 'Hola mundo');
      expect(result.isMatch, true);
      expect(result.feedback.first, 'Great job!');

      verify(
        mockDio.post(
          '/api/ai/evaluate-speech',
          data: anyNamed('data'),
          options: anyNamed('options'),
        ),
      ).called(1);
    } finally {
      if (await file.exists()) {
        await file.delete();
      }
    }
  });
}
