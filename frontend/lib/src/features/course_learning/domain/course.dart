import 'package:freezed_annotation/freezed_annotation.dart';

part 'course.freezed.dart';
part 'course.g.dart';

@freezed
abstract class Course with _$Course {
  const factory Course({
    required String id,
    required String slug,
    required String title,
    String? description,
    required String level, // A1, A2, etc.
    @JsonKey(name: 'track_type') required String trackType,
    @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
    @Default(1) int version,
    @Default(0) int completedLessonsCount,
    @Default(0) int totalLessonsCount,
  }) = _Course;

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);
}
