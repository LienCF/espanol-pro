import 'dart:io';
import 'speech_evaluation_result.dart';

abstract class SpeechEvaluationRepository {
  Future<SpeechEvaluationResult> evaluateSpeech({
    required File audioFile,
    required String referenceText,
  });
}
