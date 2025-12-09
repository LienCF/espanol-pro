// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_sync_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(contentSyncService)
const contentSyncServiceProvider = ContentSyncServiceProvider._();

final class ContentSyncServiceProvider
    extends
        $FunctionalProvider<
          ContentSyncService,
          ContentSyncService,
          ContentSyncService
        >
    with $Provider<ContentSyncService> {
  const ContentSyncServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contentSyncServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contentSyncServiceHash();

  @$internal
  @override
  $ProviderElement<ContentSyncService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ContentSyncService create(Ref ref) {
    return contentSyncService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ContentSyncService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ContentSyncService>(value),
    );
  }
}

String _$contentSyncServiceHash() =>
    r'68236d4a33db235870379c94f49b9e82c59b9b4d';
