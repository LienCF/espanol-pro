import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/speech_evaluation_repository_impl.dart';
import '../domain/speech_evaluation_result.dart';

class SpeechPracticeController extends AsyncNotifier<SpeechEvaluationResult?> {
  @override
  FutureOr<SpeechEvaluationResult?> build() {
    return null;
  }

  Future<void> evaluate(File audioFile, String referenceText) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return ref
          .read(speechEvaluationRepositoryProvider)
          .evaluateSpeech(audioFile: audioFile, referenceText: referenceText);
    });
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

final speechPracticeControllerProvider =
    AsyncNotifierProvider<SpeechPracticeController, SpeechEvaluationResult?>(
      SpeechPracticeController.new,
    );
