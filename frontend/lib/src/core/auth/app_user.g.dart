// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppUser _$AppUserFromJson(Map<String, dynamic> json) => _AppUser(
  id: json['id'] as String,
  email: json['email'] as String,
  displayName: json['display_name'] as String?,
  isPremium: json['is_premium'] == null
      ? false
      : _boolFromInt(json['is_premium']),
  totalXp: (json['total_xp'] as num?)?.toInt() ?? 0,
  currentStreak: (json['current_streak'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$AppUserToJson(_AppUser instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'display_name': instance.displayName,
  'is_premium': instance.isPremium,
  'total_xp': instance.totalXp,
  'current_streak': instance.currentStreak,
};
