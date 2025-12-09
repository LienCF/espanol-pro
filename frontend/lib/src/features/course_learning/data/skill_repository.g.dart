// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skill_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(skillRepository)
const skillRepositoryProvider = SkillRepositoryProvider._();

final class SkillRepositoryProvider
    extends
        $FunctionalProvider<SkillRepository, SkillRepository, SkillRepository>
    with $Provider<SkillRepository> {
  const SkillRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'skillRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$skillRepositoryHash();

  @$internal
  @override
  $ProviderElement<SkillRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SkillRepository create(Ref ref) {
    return skillRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SkillRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SkillRepository>(value),
    );
  }
}

String _$skillRepositoryHash() => r'b57150040852379f959e67d0f6485c196aae39db';

@ProviderFor(userSkills)
const userSkillsProvider = UserSkillsProvider._();

final class UserSkillsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Skill>>,
          List<Skill>,
          FutureOr<List<Skill>>
        >
    with $FutureModifier<List<Skill>>, $FutureProvider<List<Skill>> {
  const UserSkillsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userSkillsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userSkillsHash();

  @$internal
  @override
  $FutureProviderElement<List<Skill>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Skill>> create(Ref ref) {
    return userSkills(ref);
  }
}

String _$userSkillsHash() => r'848c01a6001fe65bb5ba877c9c0aec24a5f2d1db';
