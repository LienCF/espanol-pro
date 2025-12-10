import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/auth/auth_repository.dart';
import 'features/authentication/presentation/login_screen.dart';
import 'features/dashboard/presentation/dashboard_screen.dart';
import 'features/course_learning/presentation/course_detail_screen.dart';
import 'features/course_learning/presentation/lesson_player_screen.dart';
import 'features/subscription/presentation/paywall_screen.dart';
import 'features/speech_practice/presentation/speech_practice_screen.dart';
import 'features/admin/presentation/admin_dashboard_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(currentUserProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = authState != null;
      final isLoginRoute = state.uri.path == '/login';

      if (!isLoggedIn && !isLoginRoute) {
        return '/login';
      }

      if (isLoggedIn && isLoginRoute) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/paywall',
        builder: (context, state) => const PaywallScreen(),
      ),
      GoRoute(
        path: '/speech-practice',
        builder: (context, state) {
          final text = state.extra as String? ?? 'Hola, ¿cómo estás?';
          return SpeechPracticeScreen(referenceText: text);
        },
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const DashboardScreen(),
        routes: [
          GoRoute(
            path: 'course/:id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return CourseDetailScreen(courseId: id);
            },
            routes: [
              GoRoute(
                path: 'lesson/:lessonId',
                builder: (context, state) {
                  final courseId = state.pathParameters['id']!;
                  final lessonId = state.pathParameters['lessonId']!;
                  return LessonPlayerScreen(
                    lessonId: lessonId,
                    courseId: courseId,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
