// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_downloader.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(courseDownloader)
const courseDownloaderProvider = CourseDownloaderProvider._();

final class CourseDownloaderProvider
    extends
        $FunctionalProvider<
          CourseDownloader,
          CourseDownloader,
          CourseDownloader
        >
    with $Provider<CourseDownloader> {
  const CourseDownloaderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'courseDownloaderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$courseDownloaderHash();

  @$internal
  @override
  $ProviderElement<CourseDownloader> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CourseDownloader create(Ref ref) {
    return courseDownloader(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CourseDownloader value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CourseDownloader>(value),
    );
  }
}

String _$courseDownloaderHash() => r'a89bf4ad7546e3a3b1c93c180183311cc64c2534';
