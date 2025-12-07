// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speech_evaluation_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SpeechEvaluationResult _$SpeechEvaluationResultFromJson(
  Map<String, dynamic> json,
) => _SpeechEvaluationResult(
  score: (json['score'] as num).toInt(),
  transcription: json['transcription'] as String,
  isMatch: json['is_match'] as bool,
  feedback:
      (json['feedback'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$SpeechEvaluationResultToJson(
  _SpeechEvaluationResult instance,
) => <String, dynamic>{
  'score': instance.score,
  'transcription': instance.transcription,
  'is_match': instance.isMatch,
  'feedback': instance.feedback,
};
