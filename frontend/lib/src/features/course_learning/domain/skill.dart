import 'package:freezed_annotation/freezed_annotation.dart';

part 'skill.freezed.dart';
part 'skill.g.dart';

@freezed
abstract class Skill with _$Skill {
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Skill({
    @JsonKey(name: 'skill_name') required String name,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'mastery_level') required double masteryLevel,
    @JsonKey(name: 'last_practice_time') int? lastPracticeTime,
  }) = _Skill;

  factory Skill.fromJson(Map<String, dynamic> json) => _$SkillFromJson(json);
}
