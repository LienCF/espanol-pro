// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skill.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Skill _$SkillFromJson(Map<String, dynamic> json) => _Skill(
  name: json['skill_name'] as String,
  description: json['description'] as String?,
  masteryLevel: (json['mastery_level'] as num).toDouble(),
  lastPracticeTime: (json['last_practice_time'] as num?)?.toInt(),
);

Map<String, dynamic> _$SkillToJson(_Skill instance) => <String, dynamic>{
  'skill_name': instance.name,
  'description': instance.description,
  'mastery_level': instance.masteryLevel,
  'last_practice_time': instance.lastPracticeTime,
};
