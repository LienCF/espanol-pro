import 'package:freezed_annotation/freezed_annotation.dart';
import 'lesson.dart';

part 'unit.freezed.dart';
part 'unit.g.dart';

@freezed
abstract class Unit with _$Unit {
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Unit({
    required String id,
    @JsonKey(name: 'course_id') required String courseId,
    required String title,
    @JsonKey(name: 'order_index') required int orderIndex,
    @Default([]) List<Lesson> lessons,
  }) = _Unit;

  factory Unit.fromJson(Map<String, dynamic> json) => _$UnitFromJson(json);
}
