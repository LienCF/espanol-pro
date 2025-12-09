import 'dart:io';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:frontend/src/core/services/audio_recorder_service.dart';
import 'package:frontend/src/features/course_learning/data/speech_evaluation_repository.dart';
import 'package:frontend/src/features/course_learning/data/learning_repository.dart';
import 'package:frontend/src/features/course_learning/domain/speech_evaluation_result.dart';

part 'speech_evaluation_controller.freezed.dart';
part 'speech_evaluation_controller.g.dart';

@freezed
class SpeechEvaluationState with _$SpeechEvaluationState {
  const factory SpeechEvaluationState.initial() = _Initial;
  const factory SpeechEvaluationState.recording() = _Recording;
  const factory SpeechEvaluationState.processing() = _Processing;
  const factory SpeechEvaluationState.success(SpeechEvaluationResult result) =
      _Success;
  const factory SpeechEvaluationState.error(String message) = _Error;
}

@riverpod
class SpeechEvaluationController extends _$SpeechEvaluationController {
  @override
  SpeechEvaluationState build(String id) {
    return const SpeechEvaluationState.initial();
  }

  Future<void> startRecording() async {
    state = const SpeechEvaluationState.recording();
    try {
      await ref.read(audioRecorderServiceProvider).startRecording();
    } catch (e) {
      state = SpeechEvaluationState.error(e.toString());
    }
  }

  Future<void> stopRecordingAndEvaluate(
    String referenceText,
    String lessonId,
  ) async {
    try {
      // 1. Stop Recording
      final path = await ref.read(audioRecorderServiceProvider).stopRecording();
      if (path == null) {
        state = const SpeechEvaluationState.error("Failed to capture audio");
        return;
      }

      state = const SpeechEvaluationState.processing();

      // 2. Upload and Evaluate
      final file = File(path);
      final result = await ref
          .read(speechEvaluationRepositoryProvider)
          .evaluateSpeech(audioFile: file, referenceText: referenceText);

      state = SpeechEvaluationState.success(result);

      // 3. Record Attempt (BKT)
      await ref
          .read(learningRepositoryProvider)
          .recordAttempt(lessonId: lessonId, isCorrect: result.isMatch);
    } catch (e) {
      state = SpeechEvaluationState.error(e.toString());
    }
  }

  void reset() {
    state = const SpeechEvaluationState.initial();
  }
}
