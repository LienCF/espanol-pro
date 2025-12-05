import 'package:freezed_annotation/freezed_annotation.dart';

part 'unit.freezed.dart';
part 'unit.g.dart';

@freezed
abstract class Unit with _$Unit {
  const factory Unit({
    required String id,
    @JsonKey(name: 'course_id') required String courseId,
    required String title,
    @JsonKey(name: 'order_index') required int orderIndex,
  }) = _Unit;

  factory Unit.fromJson(Map<String, dynamic> json) => _$UnitFromJson(json);
}
