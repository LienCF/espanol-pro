import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../data/gamification_repository.dart';
import '../domain/leaderboard_entry.dart';

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboardAsync = ref.watch(leaderboardProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.leaderboardTitle)),
      body: leaderboardAsync.when(
        data: (data) {
          if (data.leaderboard.isEmpty) {
            return Center(child: Text(l10n.noLeaderboardData));
          }
          return Column(
            children: [
              if (data.userRank != null)
                _buildUserStats(context, data.userRank!, l10n),
              Expanded(
                child: ListView.builder(
                  itemCount: data.leaderboard.length,
                  itemBuilder: (context, index) {
                    final entry = data.leaderboard[index];
                    // API sends top 10, so rank is index + 1
                    return _buildRankItem(context, entry, index + 1, l10n);
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            Center(child: Text(l10n.errorWithMsg(err.toString()))),
      ),
    );
  }

  Widget _buildUserStats(
    BuildContext context,
    UserRank rank,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStat(context, l10n.rankLabel, '#${rank.rank}'),
          _buildStat(context, l10n.xpLabel, '${rank.xp}'),
          _buildStat(context, l10n.streakLabel, '${rank.streak} 🔥'),
        ],
      ),
    );
  }

  Widget _buildStat(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(label, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }

  Widget _buildRankItem(
    BuildContext context,
    LeaderboardEntry entry,
    int rank,
    AppLocalizations l10n,
  ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: rank <= 3 ? Colors.amber : Colors.grey.shade300,
        child: Text(
          '$rank',
          style: TextStyle(color: rank <= 3 ? Colors.black : Colors.black54),
        ),
      ),
      title: Text(entry.displayName ?? 'User'),
      trailing: Text(
        '${entry.xp} ${l10n.xpLabel}',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
