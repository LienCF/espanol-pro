// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gamification_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(gamificationRepository)
const gamificationRepositoryProvider = GamificationRepositoryProvider._();

final class GamificationRepositoryProvider
    extends
        $FunctionalProvider<
          GamificationRepository,
          GamificationRepository,
          GamificationRepository
        >
    with $Provider<GamificationRepository> {
  const GamificationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gamificationRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gamificationRepositoryHash();

  @$internal
  @override
  $ProviderElement<GamificationRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GamificationRepository create(Ref ref) {
    return gamificationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GamificationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GamificationRepository>(value),
    );
  }
}

String _$gamificationRepositoryHash() =>
    r'17dd88681b6c782227d2df94a412d935fa30160e';

@ProviderFor(leaderboard)
const leaderboardProvider = LeaderboardProvider._();

final class LeaderboardProvider
    extends
        $FunctionalProvider<
          AsyncValue<LeaderboardData>,
          LeaderboardData,
          FutureOr<LeaderboardData>
        >
    with $FutureModifier<LeaderboardData>, $FutureProvider<LeaderboardData> {
  const LeaderboardProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'leaderboardProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$leaderboardHash();

  @$internal
  @override
  $FutureProviderElement<LeaderboardData> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<LeaderboardData> create(Ref ref) {
    return leaderboard(ref);
  }
}

String _$leaderboardHash() => r'1a1c807af912df6a89438dc342eefe2820628b99';
