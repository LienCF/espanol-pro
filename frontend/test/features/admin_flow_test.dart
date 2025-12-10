import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/core/auth/auth_repository.dart';
import 'package:frontend/src/core/auth/app_user.dart';
import 'package:frontend/src/features/admin/presentation/admin_dashboard_screen.dart';
import 'package:frontend/src/features/course_learning/data/course_repository.dart';
import 'package:frontend/src/features/analytics/data/analytics_repository.dart';
import 'package:frontend/src/features/course_learning/domain/course.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([MockSpec<AnalyticsRepository>()])
import 'admin_flow_test.mocks.dart';

class FakeAdminUser extends CurrentUser {
  @override
  AppUser? build() => const AppUser(
    id: 'admin_1',
    email: 'admin@example.com',
    displayName: 'Admin User',
  );
}

void main() {
  late MockAnalyticsRepository mockAnalyticsRepo;

  setUp(() {
    mockAnalyticsRepo = MockAnalyticsRepository();
    when(mockAnalyticsRepo.getStats()).thenAnswer((_) async => []);
  });

  testWidgets('Admin Dashboard loads for authenticated user', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentUserProvider.overrideWith(() => FakeAdminUser()),
          courseListProvider.overrideWith(
            (ref) => Stream.value([
              const Course(
                id: 'c1',
                slug: 'test',
                title: 'Test Course',
                level: 'A1',
                trackType: 'GENERAL',
              ),
            ]),
          ),
          analyticsRepositoryProvider.overrideWithValue(mockAnalyticsRepo),
        ],
        child: const MaterialApp(home: AdminDashboardScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Admin Dashboard'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget); // FAB
    expect(find.text('Test Course'), findsOneWidget);
  });
}
