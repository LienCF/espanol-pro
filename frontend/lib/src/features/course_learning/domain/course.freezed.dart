// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Course {

 String get id; String get slug; String get title; String? get description; String get level;// A1, A2, etc.
@JsonKey(name: 'track_type') String get trackType;@JsonKey(name: 'thumbnail_url') String? get thumbnailUrl; int get version; int get completedLessonsCount; int get totalLessonsCount;
/// Create a copy of Course
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseCopyWith<Course> get copyWith => _$CourseCopyWithImpl<Course>(this as Course, _$identity);

  /// Serializes this Course to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Course&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.level, level) || other.level == level)&&(identical(other.trackType, trackType) || other.trackType == trackType)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.version, version) || other.version == version)&&(identical(other.completedLessonsCount, completedLessonsCount) || other.completedLessonsCount == completedLessonsCount)&&(identical(other.totalLessonsCount, totalLessonsCount) || other.totalLessonsCount == totalLessonsCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slug,title,description,level,trackType,thumbnailUrl,version,completedLessonsCount,totalLessonsCount);

@override
String toString() {
  return 'Course(id: $id, slug: $slug, title: $title, description: $description, level: $level, trackType: $trackType, thumbnailUrl: $thumbnailUrl, version: $version, completedLessonsCount: $completedLessonsCount, totalLessonsCount: $totalLessonsCount)';
}


}

/// @nodoc
abstract mixin class $CourseCopyWith<$Res>  {
  factory $CourseCopyWith(Course value, $Res Function(Course) _then) = _$CourseCopyWithImpl;
@useResult
$Res call({
 String id, String slug, String title, String? description, String level,@JsonKey(name: 'track_type') String trackType,@JsonKey(name: 'thumbnail_url') String? thumbnailUrl, int version, int completedLessonsCount, int totalLessonsCount
});




}
/// @nodoc
class _$CourseCopyWithImpl<$Res>
    implements $CourseCopyWith<$Res> {
  _$CourseCopyWithImpl(this._self, this._then);

  final Course _self;
  final $Res Function(Course) _then;

/// Create a copy of Course
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = null,Object? title = null,Object? description = freezed,Object? level = null,Object? trackType = null,Object? thumbnailUrl = freezed,Object? version = null,Object? completedLessonsCount = null,Object? totalLessonsCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,trackType: null == trackType ? _self.trackType : trackType // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,completedLessonsCount: null == completedLessonsCount ? _self.completedLessonsCount : completedLessonsCount // ignore: cast_nullable_to_non_nullable
as int,totalLessonsCount: null == totalLessonsCount ? _self.totalLessonsCount : totalLessonsCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Course].
extension CoursePatterns on Course {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Course value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Course() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Course value)  $default,){
final _that = this;
switch (_that) {
case _Course():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Course value)?  $default,){
final _that = this;
switch (_that) {
case _Course() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String slug,  String title,  String? description,  String level, @JsonKey(name: 'track_type')  String trackType, @JsonKey(name: 'thumbnail_url')  String? thumbnailUrl,  int version,  int completedLessonsCount,  int totalLessonsCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Course() when $default != null:
return $default(_that.id,_that.slug,_that.title,_that.description,_that.level,_that.trackType,_that.thumbnailUrl,_that.version,_that.completedLessonsCount,_that.totalLessonsCount);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String slug,  String title,  String? description,  String level, @JsonKey(name: 'track_type')  String trackType, @JsonKey(name: 'thumbnail_url')  String? thumbnailUrl,  int version,  int completedLessonsCount,  int totalLessonsCount)  $default,) {final _that = this;
switch (_that) {
case _Course():
return $default(_that.id,_that.slug,_that.title,_that.description,_that.level,_that.trackType,_that.thumbnailUrl,_that.version,_that.completedLessonsCount,_that.totalLessonsCount);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String slug,  String title,  String? description,  String level, @JsonKey(name: 'track_type')  String trackType, @JsonKey(name: 'thumbnail_url')  String? thumbnailUrl,  int version,  int completedLessonsCount,  int totalLessonsCount)?  $default,) {final _that = this;
switch (_that) {
case _Course() when $default != null:
return $default(_that.id,_that.slug,_that.title,_that.description,_that.level,_that.trackType,_that.thumbnailUrl,_that.version,_that.completedLessonsCount,_that.totalLessonsCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Course implements Course {
  const _Course({required this.id, required this.slug, required this.title, this.description, required this.level, @JsonKey(name: 'track_type') required this.trackType, @JsonKey(name: 'thumbnail_url') this.thumbnailUrl, this.version = 1, this.completedLessonsCount = 0, this.totalLessonsCount = 0});
  factory _Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);

@override final  String id;
@override final  String slug;
@override final  String title;
@override final  String? description;
@override final  String level;
// A1, A2, etc.
@override@JsonKey(name: 'track_type') final  String trackType;
@override@JsonKey(name: 'thumbnail_url') final  String? thumbnailUrl;
@override@JsonKey() final  int version;
@override@JsonKey() final  int completedLessonsCount;
@override@JsonKey() final  int totalLessonsCount;

/// Create a copy of Course
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseCopyWith<_Course> get copyWith => __$CourseCopyWithImpl<_Course>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CourseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Course&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.level, level) || other.level == level)&&(identical(other.trackType, trackType) || other.trackType == trackType)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.version, version) || other.version == version)&&(identical(other.completedLessonsCount, completedLessonsCount) || other.completedLessonsCount == completedLessonsCount)&&(identical(other.totalLessonsCount, totalLessonsCount) || other.totalLessonsCount == totalLessonsCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slug,title,description,level,trackType,thumbnailUrl,version,completedLessonsCount,totalLessonsCount);

@override
String toString() {
  return 'Course(id: $id, slug: $slug, title: $title, description: $description, level: $level, trackType: $trackType, thumbnailUrl: $thumbnailUrl, version: $version, completedLessonsCount: $completedLessonsCount, totalLessonsCount: $totalLessonsCount)';
}


}

/// @nodoc
abstract mixin class _$CourseCopyWith<$Res> implements $CourseCopyWith<$Res> {
  factory _$CourseCopyWith(_Course value, $Res Function(_Course) _then) = __$CourseCopyWithImpl;
@override @useResult
$Res call({
 String id, String slug, String title, String? description, String level,@JsonKey(name: 'track_type') String trackType,@JsonKey(name: 'thumbnail_url') String? thumbnailUrl, int version, int completedLessonsCount, int totalLessonsCount
});




}
/// @nodoc
class __$CourseCopyWithImpl<$Res>
    implements _$CourseCopyWith<$Res> {
  __$CourseCopyWithImpl(this._self, this._then);

  final _Course _self;
  final $Res Function(_Course) _then;

/// Create a copy of Course
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = null,Object? title = null,Object? description = freezed,Object? level = null,Object? trackType = null,Object? thumbnailUrl = freezed,Object? version = null,Object? completedLessonsCount = null,Object? totalLessonsCount = null,}) {
  return _then(_Course(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,trackType: null == trackType ? _self.trackType : trackType // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,completedLessonsCount: null == completedLessonsCount ? _self.completedLessonsCount : completedLessonsCount // ignore: cast_nullable_to_non_nullable
as int,totalLessonsCount: null == totalLessonsCount ? _self.totalLessonsCount : totalLessonsCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
