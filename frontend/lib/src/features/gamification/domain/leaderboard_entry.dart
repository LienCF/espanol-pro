import 'package:freezed_annotation/freezed_annotation.dart';

part 'leaderboard_entry.freezed.dart';
part 'leaderboard_entry.g.dart';

@freezed
abstract class LeaderboardEntry with _$LeaderboardEntry {
  const factory LeaderboardEntry({
    required String userId,
    String? displayName,
    @Default(0) int xp,
    @Default(0) int streak,
    @Default(0) int rank,
  }) = _LeaderboardEntry;

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardEntryFromJson(json);
}

@freezed
abstract class UserRank with _$UserRank {
  const factory UserRank({
    required int rank,
    @Default(0) int xp,
    @Default(0) int streak,
  }) = _UserRank;

  factory UserRank.fromJson(Map<String, dynamic> json) =>
      _$UserRankFromJson(json);
}

@freezed
abstract class LeaderboardData with _$LeaderboardData {
  const factory LeaderboardData({
    @Default([]) List<LeaderboardEntry> leaderboard,
    UserRank? userRank,
  }) = _LeaderboardData;

  factory LeaderboardData.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardDataFromJson(json);
}
