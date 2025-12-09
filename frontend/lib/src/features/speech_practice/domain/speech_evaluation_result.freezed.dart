// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'speech_evaluation_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SpeechEvaluationResult {

 int get score; String get transcription;@JsonKey(name: 'is_match') bool get isMatch; List<String> get feedback;
/// Create a copy of SpeechEvaluationResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpeechEvaluationResultCopyWith<SpeechEvaluationResult> get copyWith => _$SpeechEvaluationResultCopyWithImpl<SpeechEvaluationResult>(this as SpeechEvaluationResult, _$identity);

  /// Serializes this SpeechEvaluationResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpeechEvaluationResult&&(identical(other.score, score) || other.score == score)&&(identical(other.transcription, transcription) || other.transcription == transcription)&&(identical(other.isMatch, isMatch) || other.isMatch == isMatch)&&const DeepCollectionEquality().equals(other.feedback, feedback));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,score,transcription,isMatch,const DeepCollectionEquality().hash(feedback));

@override
String toString() {
  return 'SpeechEvaluationResult(score: $score, transcription: $transcription, isMatch: $isMatch, feedback: $feedback)';
}


}

/// @nodoc
abstract mixin class $SpeechEvaluationResultCopyWith<$Res>  {
  factory $SpeechEvaluationResultCopyWith(SpeechEvaluationResult value, $Res Function(SpeechEvaluationResult) _then) = _$SpeechEvaluationResultCopyWithImpl;
@useResult
$Res call({
 int score, String transcription,@JsonKey(name: 'is_match') bool isMatch, List<String> feedback
});




}
/// @nodoc
class _$SpeechEvaluationResultCopyWithImpl<$Res>
    implements $SpeechEvaluationResultCopyWith<$Res> {
  _$SpeechEvaluationResultCopyWithImpl(this._self, this._then);

  final SpeechEvaluationResult _self;
  final $Res Function(SpeechEvaluationResult) _then;

/// Create a copy of SpeechEvaluationResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? score = null,Object? transcription = null,Object? isMatch = null,Object? feedback = null,}) {
  return _then(_self.copyWith(
score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,transcription: null == transcription ? _self.transcription : transcription // ignore: cast_nullable_to_non_nullable
as String,isMatch: null == isMatch ? _self.isMatch : isMatch // ignore: cast_nullable_to_non_nullable
as bool,feedback: null == feedback ? _self.feedback : feedback // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [SpeechEvaluationResult].
extension SpeechEvaluationResultPatterns on SpeechEvaluationResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpeechEvaluationResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpeechEvaluationResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpeechEvaluationResult value)  $default,){
final _that = this;
switch (_that) {
case _SpeechEvaluationResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpeechEvaluationResult value)?  $default,){
final _that = this;
switch (_that) {
case _SpeechEvaluationResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int score,  String transcription, @JsonKey(name: 'is_match')  bool isMatch,  List<String> feedback)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpeechEvaluationResult() when $default != null:
return $default(_that.score,_that.transcription,_that.isMatch,_that.feedback);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int score,  String transcription, @JsonKey(name: 'is_match')  bool isMatch,  List<String> feedback)  $default,) {final _that = this;
switch (_that) {
case _SpeechEvaluationResult():
return $default(_that.score,_that.transcription,_that.isMatch,_that.feedback);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int score,  String transcription, @JsonKey(name: 'is_match')  bool isMatch,  List<String> feedback)?  $default,) {final _that = this;
switch (_that) {
case _SpeechEvaluationResult() when $default != null:
return $default(_that.score,_that.transcription,_that.isMatch,_that.feedback);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SpeechEvaluationResult implements SpeechEvaluationResult {
  const _SpeechEvaluationResult({required this.score, required this.transcription, @JsonKey(name: 'is_match') required this.isMatch, final  List<String> feedback = const []}): _feedback = feedback;
  factory _SpeechEvaluationResult.fromJson(Map<String, dynamic> json) => _$SpeechEvaluationResultFromJson(json);

@override final  int score;
@override final  String transcription;
@override@JsonKey(name: 'is_match') final  bool isMatch;
 final  List<String> _feedback;
@override@JsonKey() List<String> get feedback {
  if (_feedback is EqualUnmodifiableListView) return _feedback;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_feedback);
}


/// Create a copy of SpeechEvaluationResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpeechEvaluationResultCopyWith<_SpeechEvaluationResult> get copyWith => __$SpeechEvaluationResultCopyWithImpl<_SpeechEvaluationResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SpeechEvaluationResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpeechEvaluationResult&&(identical(other.score, score) || other.score == score)&&(identical(other.transcription, transcription) || other.transcription == transcription)&&(identical(other.isMatch, isMatch) || other.isMatch == isMatch)&&const DeepCollectionEquality().equals(other._feedback, _feedback));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,score,transcription,isMatch,const DeepCollectionEquality().hash(_feedback));

@override
String toString() {
  return 'SpeechEvaluationResult(score: $score, transcription: $transcription, isMatch: $isMatch, feedback: $feedback)';
}


}

/// @nodoc
abstract mixin class _$SpeechEvaluationResultCopyWith<$Res> implements $SpeechEvaluationResultCopyWith<$Res> {
  factory _$SpeechEvaluationResultCopyWith(_SpeechEvaluationResult value, $Res Function(_SpeechEvaluationResult) _then) = __$SpeechEvaluationResultCopyWithImpl;
@override @useResult
$Res call({
 int score, String transcription,@JsonKey(name: 'is_match') bool isMatch, List<String> feedback
});




}
/// @nodoc
class __$SpeechEvaluationResultCopyWithImpl<$Res>
    implements _$SpeechEvaluationResultCopyWith<$Res> {
  __$SpeechEvaluationResultCopyWithImpl(this._self, this._then);

  final _SpeechEvaluationResult _self;
  final $Res Function(_SpeechEvaluationResult) _then;

/// Create a copy of SpeechEvaluationResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? score = null,Object? transcription = null,Object? isMatch = null,Object? feedback = null,}) {
  return _then(_SpeechEvaluationResult(
score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,transcription: null == transcription ? _self.transcription : transcription // ignore: cast_nullable_to_non_nullable
as String,isMatch: null == isMatch ? _self.isMatch : isMatch // ignore: cast_nullable_to_non_nullable
as bool,feedback: null == feedback ? _self._feedback : feedback // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
