// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LeaderboardEntry _$LeaderboardEntryFromJson(Map<String, dynamic> json) =>
    _LeaderboardEntry(
      userId: json['userId'] as String,
      displayName: json['displayName'] as String?,
      xp: (json['xp'] as num?)?.toInt() ?? 0,
      streak: (json['streak'] as num?)?.toInt() ?? 0,
      rank: (json['rank'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$LeaderboardEntryToJson(_LeaderboardEntry instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'displayName': instance.displayName,
      'xp': instance.xp,
      'streak': instance.streak,
      'rank': instance.rank,
    };

_UserRank _$UserRankFromJson(Map<String, dynamic> json) => _UserRank(
  rank: (json['rank'] as num).toInt(),
  xp: (json['xp'] as num?)?.toInt() ?? 0,
  streak: (json['streak'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$UserRankToJson(_UserRank instance) => <String, dynamic>{
  'rank': instance.rank,
  'xp': instance.xp,
  'streak': instance.streak,
};

_LeaderboardData _$LeaderboardDataFromJson(Map<String, dynamic> json) =>
    _LeaderboardData(
      leaderboard:
          (json['leaderboard'] as List<dynamic>?)
              ?.map((e) => LeaderboardEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      userRank: json['userRank'] == null
          ? null
          : UserRank.fromJson(json['userRank'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LeaderboardDataToJson(_LeaderboardData instance) =>
    <String, dynamic>{
      'leaderboard': instance.leaderboard,
      'userRank': instance.userRank,
    };
