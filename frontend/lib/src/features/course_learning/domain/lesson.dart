import 'package:freezed_annotation/freezed_annotation.dart';

part 'lesson.freezed.dart';
part 'lesson.g.dart';

@freezed
abstract class Lesson with _$Lesson {
  const factory Lesson({
    required String id,
    @JsonKey(name: 'unit_id') required String unitId,
    required String title,
    @JsonKey(name: 'content_type') required String contentType,
    @JsonKey(name: 'content_json')
    String? contentJson, // Raw JSON string of content
    @JsonKey(name: 'order_index') required int orderIndex,
    @Default(false) bool isCompleted,
  }) = _Lesson;

  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);
}
