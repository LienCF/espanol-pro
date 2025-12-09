// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(courseRepository)
const courseRepositoryProvider = CourseRepositoryProvider._();

final class CourseRepositoryProvider
    extends
        $FunctionalProvider<
          CourseRepository,
          CourseRepository,
          CourseRepository
        >
    with $Provider<CourseRepository> {
  const CourseRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'courseRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$courseRepositoryHash();

  @$internal
  @override
  $ProviderElement<CourseRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CourseRepository create(Ref ref) {
    return courseRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CourseRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CourseRepository>(value),
    );
  }
}

String _$courseRepositoryHash() => r'bce85500a0bcb3d3507bf808ebbba89d236a78c7';

@ProviderFor(courseList)
const courseListProvider = CourseListProvider._();

final class CourseListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Course>>,
          List<Course>,
          Stream<List<Course>>
        >
    with $FutureModifier<List<Course>>, $StreamProvider<List<Course>> {
  const CourseListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'courseListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$courseListHash();

  @$internal
  @override
  $StreamProviderElement<List<Course>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Course>> create(Ref ref) {
    return courseList(ref);
  }
}

String _$courseListHash() => r'a659ef8df5a5c4ddcb88b5ab57dc54b1a085780b';

@ProviderFor(courseDetail)
const courseDetailProvider = CourseDetailFamily._();

final class CourseDetailProvider
    extends $FunctionalProvider<AsyncValue<Course?>, Course?, Stream<Course?>>
    with $FutureModifier<Course?>, $StreamProvider<Course?> {
  const CourseDetailProvider._({
    required CourseDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'courseDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$courseDetailHash();

  @override
  String toString() {
    return r'courseDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Course?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Course?> create(Ref ref) {
    final argument = this.argument as String;
    return courseDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CourseDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$courseDetailHash() => r'5b56b2ae9ac7cfdbb4820338bd8348d6a40e7369';

final class CourseDetailFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Course?>, String> {
  const CourseDetailFamily._()
    : super(
        retry: null,
        name: r'courseDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CourseDetailProvider call(String id) =>
      CourseDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'courseDetailProvider';
}

@ProviderFor(courseUnits)
const courseUnitsProvider = CourseUnitsFamily._();

final class CourseUnitsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Unit>>,
          List<Unit>,
          Stream<List<Unit>>
        >
    with $FutureModifier<List<Unit>>, $StreamProvider<List<Unit>> {
  const CourseUnitsProvider._({
    required CourseUnitsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'courseUnitsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$courseUnitsHash();

  @override
  String toString() {
    return r'courseUnitsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Unit>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Unit>> create(Ref ref) {
    final argument = this.argument as String;
    return courseUnits(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CourseUnitsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$courseUnitsHash() => r'951efb3e924e95c5d0e3098255da2434ec3ee3e6';

final class CourseUnitsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Unit>>, String> {
  const CourseUnitsFamily._()
    : super(
        retry: null,
        name: r'courseUnitsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CourseUnitsProvider call(String courseId) =>
      CourseUnitsProvider._(argument: courseId, from: this);

  @override
  String toString() => r'courseUnitsProvider';
}

@ProviderFor(unitLessons)
const unitLessonsProvider = UnitLessonsFamily._();

final class UnitLessonsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Lesson>>,
          List<Lesson>,
          Stream<List<Lesson>>
        >
    with $FutureModifier<List<Lesson>>, $StreamProvider<List<Lesson>> {
  const UnitLessonsProvider._({
    required UnitLessonsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'unitLessonsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$unitLessonsHash();

  @override
  String toString() {
    return r'unitLessonsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Lesson>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Lesson>> create(Ref ref) {
    final argument = this.argument as String;
    return unitLessons(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UnitLessonsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$unitLessonsHash() => r'19ba393c78fec8ff0e3ec0aa3e719d8f3e58dfee';

final class UnitLessonsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Lesson>>, String> {
  const UnitLessonsFamily._()
    : super(
        retry: null,
        name: r'unitLessonsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UnitLessonsProvider call(String unitId) =>
      UnitLessonsProvider._(argument: unitId, from: this);

  @override
  String toString() => r'unitLessonsProvider';
}

@ProviderFor(lessonDetail)
const lessonDetailProvider = LessonDetailFamily._();

final class LessonDetailProvider
    extends $FunctionalProvider<AsyncValue<Lesson?>, Lesson?, Stream<Lesson?>>
    with $FutureModifier<Lesson?>, $StreamProvider<Lesson?> {
  const LessonDetailProvider._({
    required LessonDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'lessonDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$lessonDetailHash();

  @override
  String toString() {
    return r'lessonDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Lesson?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Lesson?> create(Ref ref) {
    final argument = this.argument as String;
    return lessonDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LessonDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$lessonDetailHash() => r'68d7b11432801307fc90d737d2894348de73d7b6';

final class LessonDetailFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Lesson?>, String> {
  const LessonDetailFamily._()
    : super(
        retry: null,
        name: r'lessonDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LessonDetailProvider call(String id) =>
      LessonDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'lessonDetailProvider';
}
