import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/main.dart' as app;
import 'package:frontend/src/core/api/api_client.dart';
import 'package:frontend/src/core/services/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Manual Mock Dio
class MockDio extends Mock implements Dio {
  @override
  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) {
    return super.noSuchMethod(
          Invocation.method(
            #post,
            [path],
            {
              #data: data,
              #queryParameters: queryParameters,
              #options: options,
              #cancelToken: cancelToken,
              #onSendProgress: onSendProgress,
              #onReceiveProgress: onReceiveProgress,
            },
          ),
          returnValue: Future.value(
            Response<T>(
              requestOptions: RequestOptions(path: path),
              statusCode: 200,
            ),
          ),
          returnValueForMissingStub: Future.value(
            Response<T>(
              requestOptions: RequestOptions(path: path),
              statusCode: 200,
            ),
          ),
        )
        as Future<Response<T>>;
  }

  @override
  Future<Response<T>> get<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) {
    return super.noSuchMethod(
          Invocation.method(
            #get,
            [path],
            {
              #data: data,
              #queryParameters: queryParameters,
              #options: options,
              #cancelToken: cancelToken,
              #onReceiveProgress: onReceiveProgress,
            },
          ),
          returnValue: Future.value(
            Response<T>(
              requestOptions: RequestOptions(path: path),
              statusCode: 200,
            ),
          ),
          returnValueForMissingStub: Future.value(
            Response<T>(
              requestOptions: RequestOptions(path: path),
              statusCode: 200,
            ),
          ),
        )
        as Future<Response<T>>;
  }
}

// Manual Mock AuthService
class MockAuthService extends Mock implements AuthService {
  @override
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) {
    return super.noSuchMethod(
          Invocation.method(#signInWithEmailAndPassword, [email, password]),
          returnValue: Future.value(MockUserCredential()),
          returnValueForMissingStub: Future.value(MockUserCredential()),
        )
        as Future<UserCredential>;
  }

  @override
  Future<String?> getIdToken() {
    return super.noSuchMethod(
          Invocation.method(#getIdToken, []),
          returnValue: Future.value('mock_id_token'),
          returnValueForMissingStub: Future.value('mock_id_token'),
        )
        as Future<String?>;
  }

  @override
  Future<void> initialize() {
    return Future.value();
  }
}

class MockUserCredential extends Mock implements UserCredential {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('End-to-End Flow: Login -> Dashboard', (
    WidgetTester tester,
  ) async {
    // 1. Setup Mocks
    final mockDio = MockDio();
    final mockAuthService = MockAuthService();

    // Mock Login Response
    when(
      mockDio.post(
        '/api/auth/login',
        data: anyNamed('data'),
        options: anyNamed('options'),
      ),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/api/auth/login'),
        statusCode: 200,
        data: {
          'id': 'test_user_1',
          'email': 'test@example.com',
          'display_name': 'Test User',
          'is_premium': true,
        },
      ),
    );

    // Mock Courses Response
    when(
      mockDio.get('/api/courses', queryParameters: anyNamed('queryParameters')),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/api/courses'),
        statusCode: 200,
        data: [
          {
            'id': 'course_1',
            'slug': 'spanish-101',
            'title': 'Spanish 101',
            'description': 'Intro course',
            'level': 'A1',
            'track_type': 'GENERAL',
            'version': 1,
            'completed_count': 0,
            'total_lessons': 10,
          },
        ],
      ),
    );

    // Mock Course Details Response (for Sync)
    when(
      mockDio.get(
        '/api/courses/course_1',
        queryParameters: anyNamed('queryParameters'),
      ),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/api/courses/course_1'),
        statusCode: 200,
        data: {
          'id': 'course_1',
          'units': [
            {
              'id': 'unit_1',
              'course_id': 'course_1',
              'title': 'Unit 1',
              'order_index': 0,
              'lessons': [],
            },
          ],
          'completedLessonIds': [],
        },
      ),
    );

    // Mock Skills Response
    when(mockDio.get('/api/users/test_user_1/skills')).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/api/skills'),
        statusCode: 200,
        data: [],
      ),
    );

    // 2. Pump App with Overrides
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          apiClientProvider.overrideWithValue(mockDio),
          authServiceProvider.overrideWithValue(mockAuthService),
        ],
        child: const app.EspanolProApp(),
      ),
    );
    await tester.pumpAndSettle();

    // 3. Verify Login Screen
    expect(find.text('Login'), findsWidgets); // Might find in button and title

    // 4. Perform Login
    await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'password123');
    await tester.tap(find.widgetWithText(FilledButton, 'Login'));

    // Wait for navigation
    await tester.pumpAndSettle(const Duration(seconds: 5));

    if (find.byType(TextField).evaluate().isNotEmpty) {
      debugPrint('Still on LoginScreen!');
      // Check for snackbar
      if (find.text('Login failed. Check connection.').evaluate().isNotEmpty) {
        debugPrint('Login failed snackbar found.');
      }
      if (find.textContaining('Authentication failed').evaluate().isNotEmpty) {
        debugPrint('Auth failed message found.');
      }
    }

    // 5. Verify Dashboard Content
    try {
      // Wait a bit more for stream to emit
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      final allText = find
          .byType(Text)
          .evaluate()
          .map((e) => (e.widget as Text).data)
          .join(', ');
      debugPrint('Visible Text: $allText');

      expect(find.text('Spanish 101'), findsOneWidget);
      // Check for either English or Chinese section header
      final hasHeader =
          find.text('General Proficiency').evaluate().isNotEmpty ||
          find.text('通用能力 (General)').evaluate().isNotEmpty;
      expect(hasHeader, isTrue, reason: 'Dashboard header not found');
    } catch (e) {
      debugPrint('Dashboard verification failed.');
      final errorFinder = find.textContaining('Error:');
      if (errorFinder.evaluate().isNotEmpty) {
        final errorText = (errorFinder.evaluate().first.widget as Text).data;
        debugPrint('Found Error Message: $errorText');
      }
      rethrow;
    }
  });
}
