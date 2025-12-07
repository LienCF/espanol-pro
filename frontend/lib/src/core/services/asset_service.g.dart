// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(assetService)
const assetServiceProvider = AssetServiceProvider._();

final class AssetServiceProvider
    extends $FunctionalProvider<AssetService, AssetService, AssetService>
    with $Provider<AssetService> {
  const AssetServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'assetServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$assetServiceHash();

  @$internal
  @override
  $ProviderElement<AssetService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AssetService create(Ref ref) {
    return assetService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AssetService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AssetService>(value),
    );
  }
}

String _$assetServiceHash() => r'f090f37ad050ddc3fe5b6e7864afb6c2e6bf25e2';
