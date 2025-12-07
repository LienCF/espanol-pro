import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:frontend/main.dart';
import 'package:frontend/src/core/api/api_client.dart';
import 'package:frontend/src/core/auth/auth_repository.dart';
import 'package:frontend/src/core/auth/user.dart';
import 'package:frontend/src/core/database/database_provider.dart';
import 'package:frontend/src/features/course_learning/data/app_database.dart';
import 'package:frontend/src/features/course_learning/data/course_repository.dart';
import 'package:frontend/src/features/course_learning/domain/lesson.dart';
import 'package:frontend/src/features/course_learning/domain/course.dart';
import 'package:frontend/src/features/course_learning/domain/unit.dart';
import 'package:frontend/src/features/dashboard/presentation/dashboard_screen.dart';
import 'package:frontend/src/features/course_learning/presentation/course_detail_screen.dart';

@GenerateNiceMocks([MockSpec<Dio>()])
import 'course_flow_test.mocks.dart';

class FakeCurrentUser extends CurrentUser {
  @override
  User? build() => const User(id: 'test_user', email: 'test@example.com', displayName: 'Test User');
}

void main() {
  late MockDio mockDio;
  late AppDatabase mockDb;

  setUp(() {
    mockDio = MockDio();
    mockDb = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await mockDb.close();
  });

  testWidgets('App flow: Dashboard -> Course Detail', (WidgetTester tester) async {
    // Setup Mock API Response for Courses
    when(mockDio.get(any, queryParameters: anyNamed('queryParameters'))).thenAnswer((_) async => Response(
      requestOptions: RequestOptions(path: '/api/courses'),
      data: [
        {
          'id': 'c1',
          'slug': 'foundations-1',
          'title': 'Spanish Foundations I',
          'description': 'Beginner Course',
          'level': 'A1',
          'track_type': 'GENERAL',
          'version': 1,
          'completed_count': 0,
          'total_lessons': 10
        }
      ],
      statusCode: 200,
    ));

    // Also need to mock course detail fetch
    when(mockDio.get(argThat(contains('/api/courses/c1')), queryParameters: anyNamed('queryParameters'))).thenAnswer((_) async => Response(
      requestOptions: RequestOptions(path: '/api/courses/c1'),
      data: {
        'id': 'c1',
        'title': 'Spanish Foundations I',
        'units': [
          {
            'id': 'u1',
            'course_id': 'c1',
            'title': 'Unit 1: The Basics',
            'order_index': 1
          }
        ],
        'completedLessonIds': []
      },
      statusCode: 200,
    ));

    // Mock data
    final mockCourses = [
      const Course(id: 'c1', slug: 'foundations-1', title: 'Spanish Foundations I', level: 'A1', trackType: 'GENERAL')
    ];
    final mockCourse = const Course(id: 'c1', slug: 'foundations-1', title: 'Spanish Foundations I', level: 'A1', trackType: 'GENERAL');
    final mockUnits = [
      const Unit(id: 'u1', courseId: 'c1', title: 'Unit 1: The Basics', orderIndex: 1)
    ];
    final mockLessons = [
      const Lesson(id: 'l1', unitId: 'u1', title: 'Basic Sentences', contentType: 'DIALOGUE', orderIndex: 1)
    ];

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          apiClientProvider.overrideWithValue(mockDio),
          appDatabaseProvider.overrideWithValue(mockDb),
          currentUserProvider.overrideWith(() => FakeCurrentUser()),
          courseListProvider.overrideWith((ref) => Stream.value(mockCourses)),
          courseDetailProvider('c1').overrideWith((ref) => Stream.value(mockCourse)),
          courseUnitsProvider('c1').overrideWith((ref) => Stream.value(mockUnits)),
          unitLessonsProvider('u1').overrideWith((ref) => Stream.value(mockLessons)),
        ],
        child: const EspanolProApp(),
      ),
    );
    
    // Verify Dashboard shows up (Auth bypassed)
    await tester.pumpAndSettle(); 
    expect(find.byType(DashboardScreen), findsOneWidget);
    expect(find.text('Español Pro'), findsOneWidget);

    // Verify Course Card appears
    expect(find.text('Spanish Foundations I'), findsOneWidget);

    // Tap on the course
    await tester.tap(find.text('Spanish Foundations I'));
    
    // Wait for navigation
    await tester.pumpAndSettle();

    // Verify we are on Course Detail Screen
    expect(find.byType(CourseDetailScreen), findsOneWidget);
    
    // Verify Unit Title
    expect(find.text('Unit 1: The Basics'), findsOneWidget);
    
    // Verify Lesson Title
    expect(find.text('Basic Sentences'), findsOneWidget);
  });
}