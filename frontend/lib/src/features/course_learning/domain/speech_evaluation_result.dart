import 'package:freezed_annotation/freezed_annotation.dart';

part 'speech_evaluation_result.freezed.dart';
part 'speech_evaluation_result.g.dart';

@freezed
abstract class SpeechEvaluationResult with _$SpeechEvaluationResult {
  const factory SpeechEvaluationResult({
    required int score,
    required String transcription,
    @JsonKey(name: 'is_match') required bool isMatch,
    @Default([]) List<String> feedback,
  }) = _SpeechEvaluationResult;

  factory SpeechEvaluationResult.fromJson(Map<String, dynamic> json) =>
      _$SpeechEvaluationResultFromJson(json);
}
