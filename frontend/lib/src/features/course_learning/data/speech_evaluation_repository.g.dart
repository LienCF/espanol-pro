// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speech_evaluation_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(speechEvaluationRepository)
const speechEvaluationRepositoryProvider =
    SpeechEvaluationRepositoryProvider._();

final class SpeechEvaluationRepositoryProvider
    extends
        $FunctionalProvider<
          SpeechEvaluationRepository,
          SpeechEvaluationRepository,
          SpeechEvaluationRepository
        >
    with $Provider<SpeechEvaluationRepository> {
  const SpeechEvaluationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'speechEvaluationRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$speechEvaluationRepositoryHash();

  @$internal
  @override
  $ProviderElement<SpeechEvaluationRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SpeechEvaluationRepository create(Ref ref) {
    return speechEvaluationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SpeechEvaluationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SpeechEvaluationRepository>(value),
    );
  }
}

String _$speechEvaluationRepositoryHash() =>
    r'6b4e6ac6315b871745cea34838fd83c5e13208dd';
