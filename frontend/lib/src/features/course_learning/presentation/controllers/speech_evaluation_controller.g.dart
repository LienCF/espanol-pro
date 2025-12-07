// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speech_evaluation_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SpeechEvaluationController)
const speechEvaluationControllerProvider = SpeechEvaluationControllerFamily._();

final class SpeechEvaluationControllerProvider
    extends
        $NotifierProvider<SpeechEvaluationController, SpeechEvaluationState> {
  const SpeechEvaluationControllerProvider._({
    required SpeechEvaluationControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'speechEvaluationControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$speechEvaluationControllerHash();

  @override
  String toString() {
    return r'speechEvaluationControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SpeechEvaluationController create() => SpeechEvaluationController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SpeechEvaluationState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SpeechEvaluationState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SpeechEvaluationControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$speechEvaluationControllerHash() =>
    r'e207dd46859bc9c24e387800286db8ee68803297';

final class SpeechEvaluationControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          SpeechEvaluationController,
          SpeechEvaluationState,
          SpeechEvaluationState,
          SpeechEvaluationState,
          String
        > {
  const SpeechEvaluationControllerFamily._()
    : super(
        retry: null,
        name: r'speechEvaluationControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SpeechEvaluationControllerProvider call(String id) =>
      SpeechEvaluationControllerProvider._(argument: id, from: this);

  @override
  String toString() => r'speechEvaluationControllerProvider';
}

abstract class _$SpeechEvaluationController
    extends $Notifier<SpeechEvaluationState> {
  late final _$args = ref.$arg as String;
  String get id => _$args;

  SpeechEvaluationState build(String id);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<SpeechEvaluationState, SpeechEvaluationState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SpeechEvaluationState, SpeechEvaluationState>,
              SpeechEvaluationState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
