import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/api/api_client.dart';
import '../domain/leaderboard_entry.dart';

part 'gamification_repository.g.dart';

class GamificationRepository {
  final Dio _api;

  GamificationRepository(this._api);

  Future<LeaderboardData> fetchLeaderboard() async {
    try {
      final response = await _api.get('/api/leaderboard');
      return LeaderboardData.fromJson(response.data);
    } catch (e) {
      // Return empty data on error for now
      return const LeaderboardData(leaderboard: []);
    }
  }
}

@riverpod
GamificationRepository gamificationRepository(Ref ref) {
  final api = ref.watch(apiClientProvider);
  return GamificationRepository(api);
}

@riverpod
Future<LeaderboardData> leaderboard(Ref ref) {
  return ref.watch(gamificationRepositoryProvider).fetchLeaderboard();
}
