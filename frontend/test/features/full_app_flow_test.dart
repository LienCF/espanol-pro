import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/main.dart';
import 'package:frontend/src/core/api/api_client.dart';
import 'package:frontend/src/features/authentication/presentation/login_screen.dart';
import 'package:frontend/src/features/dashboard/presentation/dashboard_screen.dart';
import 'package:frontend/src/features/subscription/presentation/paywall_screen.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';
import 'package:url_launcher_platform_interface/link.dart';
import 'package:frontend/src/core/services/auth_service.dart';
import 'package:frontend/src/core/database/database_provider.dart';
import 'package:frontend/src/features/course_learning/data/app_database.dart';
import 'package:frontend/src/features/course_learning/data/course_repository.dart';
import 'package:frontend/src/features/course_learning/data/skills_repository.dart';
import 'package:frontend/src/features/course_learning/domain/course.dart';
import 'package:frontend/src/features/course_learning/domain/skill.dart';
import 'package:drift/native.dart';

@GenerateNiceMocks([MockSpec<Dio>(), MockSpec<AuthService>()])
import 'full_app_flow_test.mocks.dart';

class MockUrlLauncher extends UrlLauncherPlatform {
  String? launchedUrl;

  @override
  LinkDelegate? get linkDelegate => null;

  @override
  Future<bool> canLaunch(String url) async {
    return true;
  }

  @override
  Future<bool> launch(
    String url, {
    bool useSafariVC = false,
    bool useWebView = false,
    bool enableJavaScript = false,
    bool enableDomStorage = false,
    bool universalLinksOnly = false,
    Map<String, String> headers = const <String, String>{},
    String? webOnlyWindowName,
  }) async {
    launchedUrl = url;
    return true;
  }
}

void main() {
  late MockDio mockDio;
  late MockAuthService mockAuthService;
  late MockUrlLauncher mockUrlLauncher;
  late AppDatabase mockDb;

  setUp(() async {
    mockDio = MockDio();
    mockAuthService = MockAuthService();
    mockUrlLauncher = MockUrlLauncher();
    mockDb = AppDatabase(NativeDatabase.memory());
    UrlLauncherPlatform.instance = mockUrlLauncher;

    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() async {
    await mockDb.close();
  });

  testWidgets('Full App Flow: Login -> Dashboard -> Paywall -> Content', (
    tester,
  ) async {
    // 1. Setup API Mocks (Still needed for Login/Checkout which call API directly)

    // Catch-all for GET requests to prevent FakeUsedError in background syncs
    when(
      mockDio.get(any, queryParameters: anyNamed('queryParameters')),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: 'any'),
        data: [],
        statusCode: 200,
      ),
    );

    // Setup Auth Service Mocks
    when(mockAuthService.initialize()).thenAnswer((_) async {});
    when(
      mockAuthService.signInWithEmailAndPassword(any, any),
    ).thenThrow(Exception('Firebase Mock Fail'));

    // Login Response
    when(
      mockDio.post(
        '/api/auth/login',
        data: anyNamed('data'),
        options: anyNamed('options'),
      ),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/api/auth/login'),
        data: {
          'id': 'user_1',
          'email': 'test@example.com',
          'display_name': 'Test User',
          'is_premium': false,
        },
        statusCode: 200,
      ),
    );

    // Checkout Session
    when(mockDio.post('/api/payments/create-checkout-session')).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/checkout'),
        data: {'url': 'https://checkout.stripe.com/test'},
        statusCode: 200,
      ),
    );

    // Mock Data for Providers
    final mockCourses = [
      const Course(
        id: 'c1',
        slug: 'foundations-1',
        title: 'Spanish Foundations I',
        level: 'A1',
        trackType: 'GENERAL',
        completedLessonsCount: 0,
        totalLessonsCount: 10,
      ),
      const Course(
        id: 'c2',
        slug: 'medical-1',
        title: 'Medical Spanish',
        level: 'B1',
        trackType: 'SPECIALIZED',
        completedLessonsCount: 0,
        totalLessonsCount: 5,
      ),
    ];

    final mockSkills = <Skill>[];

    // 2. App Start
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          apiClientProvider.overrideWithValue(mockDio),
          authServiceProvider.overrideWithValue(mockAuthService),
          appDatabaseProvider.overrideWithValue(mockDb),
          // Override Streams to avoid Drift timers
          courseListProvider.overrideWith((ref) => Stream.value(mockCourses)),
          userSkillsProvider.overrideWith((ref) async => mockSkills),
        ],
        child: const EspanolProApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Should start at Login because no session
    expect(find.byType(LoginScreen), findsOneWidget);

    // 3. Login Interaction
    await tester.enterText(find.byType(TextField).first, 'test@example.com');
    await tester.enterText(find.byType(TextField).last, 'password');
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    // Should be at Dashboard
    expect(find.byType(DashboardScreen), findsOneWidget);
    expect(find.text('Spanish Foundations I'), findsOneWidget); // Free course
    expect(find.text('Medical Spanish'), findsOneWidget); // Premium course

    // 4. Attempt to access Premium content
    final premiumCourseFinder = find.text('Medical Spanish');
    await tester.dragUntilVisible(
      premiumCourseFinder,
      find.byType(CustomScrollView),
      const Offset(0, -500),
    );
    await tester.pumpAndSettle();

    // Tap with warning suppressed because the locked overlay might intercept the hit test
    await tester.tap(premiumCourseFinder, warnIfMissed: false);
    await tester.pumpAndSettle();

    // Should be at Paywall
    expect(find.byType(PaywallScreen), findsOneWidget);

    // 5. Purchase Flow
    await tester.tap(find.textContaining('Checkout with Stripe'));
    await tester.pump(); // Start async

    // Verify URL Launched
    expect(mockUrlLauncher.launchedUrl, 'https://checkout.stripe.com/test');

    // 6. Refresh Status (Simulate Webhook success)
    // Mock Login call again with premium = true
    when(
      mockDio.post(
        '/api/auth/login',
        data: anyNamed('data'),
        options: anyNamed('options'),
      ),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/api/auth/login'),
        data: {
          'id': 'user_1',
          'email': 'test@example.com',
          'display_name': 'Test User',
          'is_premium': true, // Now Premium
        },
        statusCode: 200,
      ),
    );

    await tester.tap(find.text('Already paid? Refresh Status'));
    // Use explicit pumps instead of pumpAndSettle
    await tester.pump(const Duration(seconds: 2));
    await tester.pump();

    // Should go back to Dashboard?
    expect(find.byType(DashboardScreen), findsOneWidget);

    // Verify Premium UI state (Go Pro button hidden?)
    // Note: Go Pro button visibility depends on `currentUserProvider`.
    // `refreshSubscriptionStatus` updates `currentUserProvider` via `authRepository.login`.
    // So Dashboard should rebuild.
    expect(find.text('Go Pro'), findsNothing);
  });
}
