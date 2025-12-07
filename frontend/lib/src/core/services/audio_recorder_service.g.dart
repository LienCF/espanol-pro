// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_recorder_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(audioRecorderService)
const audioRecorderServiceProvider = AudioRecorderServiceProvider._();

final class AudioRecorderServiceProvider
    extends
        $FunctionalProvider<
          AudioRecorderService,
          AudioRecorderService,
          AudioRecorderService
        >
    with $Provider<AudioRecorderService> {
  const AudioRecorderServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'audioRecorderServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$audioRecorderServiceHash();

  @$internal
  @override
  $ProviderElement<AudioRecorderService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AudioRecorderService create(Ref ref) {
    return audioRecorderService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AudioRecorderService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AudioRecorderService>(value),
    );
  }
}

String _$audioRecorderServiceHash() =>
    r'1e67e44f58646f50f0fd9782a5bfc91f5281e0b4';
