// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Unit _$UnitFromJson(Map<String, dynamic> json) => _Unit(
  id: json['id'] as String,
  courseId: json['course_id'] as String,
  title: json['title'] as String,
  orderIndex: (json['order_index'] as num).toInt(),
  lessons:
      (json['lessons'] as List<dynamic>?)
          ?.map((e) => Lesson.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$UnitToJson(_Unit instance) => <String, dynamic>{
  'id': instance.id,
  'course_id': instance.courseId,
  'title': instance.title,
  'order_index': instance.orderIndex,
  'lessons': instance.lessons,
};
