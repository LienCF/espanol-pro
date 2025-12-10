// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Lesson _$LessonFromJson(Map<String, dynamic> json) => _Lesson(
  id: json['id'] as String,
  unitId: json['unit_id'] as String,
  title: json['title'] as String,
  contentType: json['content_type'] as String,
  contentJson: json['content_json'] as String?,
  orderIndex: (json['order_index'] as num).toInt(),
  isCompleted: json['is_completed'] as bool? ?? false,
);

Map<String, dynamic> _$LessonToJson(_Lesson instance) => <String, dynamic>{
  'id': instance.id,
  'unit_id': instance.unitId,
  'title': instance.title,
  'content_type': instance.contentType,
  'content_json': instance.contentJson,
  'order_index': instance.orderIndex,
  'is_completed': instance.isCompleted,
};
