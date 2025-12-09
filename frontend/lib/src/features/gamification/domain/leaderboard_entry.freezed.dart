// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'leaderboard_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LeaderboardEntry {

 String get userId; String? get displayName; int get xp; int get streak; int get rank;
/// Create a copy of LeaderboardEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaderboardEntryCopyWith<LeaderboardEntry> get copyWith => _$LeaderboardEntryCopyWithImpl<LeaderboardEntry>(this as LeaderboardEntry, _$identity);

  /// Serializes this LeaderboardEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaderboardEntry&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.xp, xp) || other.xp == xp)&&(identical(other.streak, streak) || other.streak == streak)&&(identical(other.rank, rank) || other.rank == rank));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,displayName,xp,streak,rank);

@override
String toString() {
  return 'LeaderboardEntry(userId: $userId, displayName: $displayName, xp: $xp, streak: $streak, rank: $rank)';
}


}

/// @nodoc
abstract mixin class $LeaderboardEntryCopyWith<$Res>  {
  factory $LeaderboardEntryCopyWith(LeaderboardEntry value, $Res Function(LeaderboardEntry) _then) = _$LeaderboardEntryCopyWithImpl;
@useResult
$Res call({
 String userId, String? displayName, int xp, int streak, int rank
});




}
/// @nodoc
class _$LeaderboardEntryCopyWithImpl<$Res>
    implements $LeaderboardEntryCopyWith<$Res> {
  _$LeaderboardEntryCopyWithImpl(this._self, this._then);

  final LeaderboardEntry _self;
  final $Res Function(LeaderboardEntry) _then;

/// Create a copy of LeaderboardEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? displayName = freezed,Object? xp = null,Object? streak = null,Object? rank = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,xp: null == xp ? _self.xp : xp // ignore: cast_nullable_to_non_nullable
as int,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LeaderboardEntry].
extension LeaderboardEntryPatterns on LeaderboardEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaderboardEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaderboardEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaderboardEntry value)  $default,){
final _that = this;
switch (_that) {
case _LeaderboardEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaderboardEntry value)?  $default,){
final _that = this;
switch (_that) {
case _LeaderboardEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String? displayName,  int xp,  int streak,  int rank)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaderboardEntry() when $default != null:
return $default(_that.userId,_that.displayName,_that.xp,_that.streak,_that.rank);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String? displayName,  int xp,  int streak,  int rank)  $default,) {final _that = this;
switch (_that) {
case _LeaderboardEntry():
return $default(_that.userId,_that.displayName,_that.xp,_that.streak,_that.rank);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String? displayName,  int xp,  int streak,  int rank)?  $default,) {final _that = this;
switch (_that) {
case _LeaderboardEntry() when $default != null:
return $default(_that.userId,_that.displayName,_that.xp,_that.streak,_that.rank);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeaderboardEntry implements LeaderboardEntry {
  const _LeaderboardEntry({required this.userId, this.displayName, this.xp = 0, this.streak = 0, this.rank = 0});
  factory _LeaderboardEntry.fromJson(Map<String, dynamic> json) => _$LeaderboardEntryFromJson(json);

@override final  String userId;
@override final  String? displayName;
@override@JsonKey() final  int xp;
@override@JsonKey() final  int streak;
@override@JsonKey() final  int rank;

/// Create a copy of LeaderboardEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaderboardEntryCopyWith<_LeaderboardEntry> get copyWith => __$LeaderboardEntryCopyWithImpl<_LeaderboardEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeaderboardEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaderboardEntry&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.xp, xp) || other.xp == xp)&&(identical(other.streak, streak) || other.streak == streak)&&(identical(other.rank, rank) || other.rank == rank));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,displayName,xp,streak,rank);

@override
String toString() {
  return 'LeaderboardEntry(userId: $userId, displayName: $displayName, xp: $xp, streak: $streak, rank: $rank)';
}


}

/// @nodoc
abstract mixin class _$LeaderboardEntryCopyWith<$Res> implements $LeaderboardEntryCopyWith<$Res> {
  factory _$LeaderboardEntryCopyWith(_LeaderboardEntry value, $Res Function(_LeaderboardEntry) _then) = __$LeaderboardEntryCopyWithImpl;
@override @useResult
$Res call({
 String userId, String? displayName, int xp, int streak, int rank
});




}
/// @nodoc
class __$LeaderboardEntryCopyWithImpl<$Res>
    implements _$LeaderboardEntryCopyWith<$Res> {
  __$LeaderboardEntryCopyWithImpl(this._self, this._then);

  final _LeaderboardEntry _self;
  final $Res Function(_LeaderboardEntry) _then;

/// Create a copy of LeaderboardEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? displayName = freezed,Object? xp = null,Object? streak = null,Object? rank = null,}) {
  return _then(_LeaderboardEntry(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,xp: null == xp ? _self.xp : xp // ignore: cast_nullable_to_non_nullable
as int,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$UserRank {

 int get rank; int get xp; int get streak;
/// Create a copy of UserRank
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserRankCopyWith<UserRank> get copyWith => _$UserRankCopyWithImpl<UserRank>(this as UserRank, _$identity);

  /// Serializes this UserRank to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserRank&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.xp, xp) || other.xp == xp)&&(identical(other.streak, streak) || other.streak == streak));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rank,xp,streak);

@override
String toString() {
  return 'UserRank(rank: $rank, xp: $xp, streak: $streak)';
}


}

/// @nodoc
abstract mixin class $UserRankCopyWith<$Res>  {
  factory $UserRankCopyWith(UserRank value, $Res Function(UserRank) _then) = _$UserRankCopyWithImpl;
@useResult
$Res call({
 int rank, int xp, int streak
});




}
/// @nodoc
class _$UserRankCopyWithImpl<$Res>
    implements $UserRankCopyWith<$Res> {
  _$UserRankCopyWithImpl(this._self, this._then);

  final UserRank _self;
  final $Res Function(UserRank) _then;

/// Create a copy of UserRank
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rank = null,Object? xp = null,Object? streak = null,}) {
  return _then(_self.copyWith(
rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,xp: null == xp ? _self.xp : xp // ignore: cast_nullable_to_non_nullable
as int,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UserRank].
extension UserRankPatterns on UserRank {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserRank value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserRank() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserRank value)  $default,){
final _that = this;
switch (_that) {
case _UserRank():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserRank value)?  $default,){
final _that = this;
switch (_that) {
case _UserRank() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int rank,  int xp,  int streak)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserRank() when $default != null:
return $default(_that.rank,_that.xp,_that.streak);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int rank,  int xp,  int streak)  $default,) {final _that = this;
switch (_that) {
case _UserRank():
return $default(_that.rank,_that.xp,_that.streak);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int rank,  int xp,  int streak)?  $default,) {final _that = this;
switch (_that) {
case _UserRank() when $default != null:
return $default(_that.rank,_that.xp,_that.streak);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserRank implements UserRank {
  const _UserRank({required this.rank, this.xp = 0, this.streak = 0});
  factory _UserRank.fromJson(Map<String, dynamic> json) => _$UserRankFromJson(json);

@override final  int rank;
@override@JsonKey() final  int xp;
@override@JsonKey() final  int streak;

/// Create a copy of UserRank
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserRankCopyWith<_UserRank> get copyWith => __$UserRankCopyWithImpl<_UserRank>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserRankToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserRank&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.xp, xp) || other.xp == xp)&&(identical(other.streak, streak) || other.streak == streak));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rank,xp,streak);

@override
String toString() {
  return 'UserRank(rank: $rank, xp: $xp, streak: $streak)';
}


}

/// @nodoc
abstract mixin class _$UserRankCopyWith<$Res> implements $UserRankCopyWith<$Res> {
  factory _$UserRankCopyWith(_UserRank value, $Res Function(_UserRank) _then) = __$UserRankCopyWithImpl;
@override @useResult
$Res call({
 int rank, int xp, int streak
});




}
/// @nodoc
class __$UserRankCopyWithImpl<$Res>
    implements _$UserRankCopyWith<$Res> {
  __$UserRankCopyWithImpl(this._self, this._then);

  final _UserRank _self;
  final $Res Function(_UserRank) _then;

/// Create a copy of UserRank
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rank = null,Object? xp = null,Object? streak = null,}) {
  return _then(_UserRank(
rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,xp: null == xp ? _self.xp : xp // ignore: cast_nullable_to_non_nullable
as int,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$LeaderboardData {

 List<LeaderboardEntry> get leaderboard; UserRank? get userRank;
/// Create a copy of LeaderboardData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaderboardDataCopyWith<LeaderboardData> get copyWith => _$LeaderboardDataCopyWithImpl<LeaderboardData>(this as LeaderboardData, _$identity);

  /// Serializes this LeaderboardData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaderboardData&&const DeepCollectionEquality().equals(other.leaderboard, leaderboard)&&(identical(other.userRank, userRank) || other.userRank == userRank));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(leaderboard),userRank);

@override
String toString() {
  return 'LeaderboardData(leaderboard: $leaderboard, userRank: $userRank)';
}


}

/// @nodoc
abstract mixin class $LeaderboardDataCopyWith<$Res>  {
  factory $LeaderboardDataCopyWith(LeaderboardData value, $Res Function(LeaderboardData) _then) = _$LeaderboardDataCopyWithImpl;
@useResult
$Res call({
 List<LeaderboardEntry> leaderboard, UserRank? userRank
});


$UserRankCopyWith<$Res>? get userRank;

}
/// @nodoc
class _$LeaderboardDataCopyWithImpl<$Res>
    implements $LeaderboardDataCopyWith<$Res> {
  _$LeaderboardDataCopyWithImpl(this._self, this._then);

  final LeaderboardData _self;
  final $Res Function(LeaderboardData) _then;

/// Create a copy of LeaderboardData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? leaderboard = null,Object? userRank = freezed,}) {
  return _then(_self.copyWith(
leaderboard: null == leaderboard ? _self.leaderboard : leaderboard // ignore: cast_nullable_to_non_nullable
as List<LeaderboardEntry>,userRank: freezed == userRank ? _self.userRank : userRank // ignore: cast_nullable_to_non_nullable
as UserRank?,
  ));
}
/// Create a copy of LeaderboardData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserRankCopyWith<$Res>? get userRank {
    if (_self.userRank == null) {
    return null;
  }

  return $UserRankCopyWith<$Res>(_self.userRank!, (value) {
    return _then(_self.copyWith(userRank: value));
  });
}
}


/// Adds pattern-matching-related methods to [LeaderboardData].
extension LeaderboardDataPatterns on LeaderboardData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaderboardData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaderboardData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaderboardData value)  $default,){
final _that = this;
switch (_that) {
case _LeaderboardData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaderboardData value)?  $default,){
final _that = this;
switch (_that) {
case _LeaderboardData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<LeaderboardEntry> leaderboard,  UserRank? userRank)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaderboardData() when $default != null:
return $default(_that.leaderboard,_that.userRank);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<LeaderboardEntry> leaderboard,  UserRank? userRank)  $default,) {final _that = this;
switch (_that) {
case _LeaderboardData():
return $default(_that.leaderboard,_that.userRank);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<LeaderboardEntry> leaderboard,  UserRank? userRank)?  $default,) {final _that = this;
switch (_that) {
case _LeaderboardData() when $default != null:
return $default(_that.leaderboard,_that.userRank);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeaderboardData implements LeaderboardData {
  const _LeaderboardData({final  List<LeaderboardEntry> leaderboard = const [], this.userRank}): _leaderboard = leaderboard;
  factory _LeaderboardData.fromJson(Map<String, dynamic> json) => _$LeaderboardDataFromJson(json);

 final  List<LeaderboardEntry> _leaderboard;
@override@JsonKey() List<LeaderboardEntry> get leaderboard {
  if (_leaderboard is EqualUnmodifiableListView) return _leaderboard;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_leaderboard);
}

@override final  UserRank? userRank;

/// Create a copy of LeaderboardData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaderboardDataCopyWith<_LeaderboardData> get copyWith => __$LeaderboardDataCopyWithImpl<_LeaderboardData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeaderboardDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaderboardData&&const DeepCollectionEquality().equals(other._leaderboard, _leaderboard)&&(identical(other.userRank, userRank) || other.userRank == userRank));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_leaderboard),userRank);

@override
String toString() {
  return 'LeaderboardData(leaderboard: $leaderboard, userRank: $userRank)';
}


}

/// @nodoc
abstract mixin class _$LeaderboardDataCopyWith<$Res> implements $LeaderboardDataCopyWith<$Res> {
  factory _$LeaderboardDataCopyWith(_LeaderboardData value, $Res Function(_LeaderboardData) _then) = __$LeaderboardDataCopyWithImpl;
@override @useResult
$Res call({
 List<LeaderboardEntry> leaderboard, UserRank? userRank
});


@override $UserRankCopyWith<$Res>? get userRank;

}
/// @nodoc
class __$LeaderboardDataCopyWithImpl<$Res>
    implements _$LeaderboardDataCopyWith<$Res> {
  __$LeaderboardDataCopyWithImpl(this._self, this._then);

  final _LeaderboardData _self;
  final $Res Function(_LeaderboardData) _then;

/// Create a copy of LeaderboardData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? leaderboard = null,Object? userRank = freezed,}) {
  return _then(_LeaderboardData(
leaderboard: null == leaderboard ? _self._leaderboard : leaderboard // ignore: cast_nullable_to_non_nullable
as List<LeaderboardEntry>,userRank: freezed == userRank ? _self.userRank : userRank // ignore: cast_nullable_to_non_nullable
as UserRank?,
  ));
}

/// Create a copy of LeaderboardData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserRankCopyWith<$Res>? get userRank {
    if (_self.userRank == null) {
    return null;
  }

  return $UserRankCopyWith<$Res>(_self.userRank!, (value) {
    return _then(_self.copyWith(userRank: value));
  });
}
}

// dart format on
