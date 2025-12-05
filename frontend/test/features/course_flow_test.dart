import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/main.dart';
import 'package:frontend/src/features/dashboard/presentation/dashboard_screen.dart';
import 'package:frontend/src/features/course_learning/presentation/course_detail_screen.dart';

void main() {
  testWidgets('App flow: Dashboard -> Course Detail', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: EspanolProApp()));
    
    // Verify Dashboard shows up
    expect(find.byType(DashboardScreen), findsOneWidget);
    expect(find.text('Español Pro'), findsOneWidget);

    // Wait for seed data (simulating async)
    await tester.pumpAndSettle();

    // Verify Course Cards appear
    expect(find.text('Spanish Foundations I'), findsOneWidget);
    expect(find.text('Construction Site Safety'), findsOneWidget);

    // Tap on the first course (Spanish Foundations I)
    await tester.tap(find.text('Spanish Foundations I'));
    await tester.pumpAndSettle(); // Wait for navigation

    // Verify we are on Course Detail Screen
    expect(find.byType(CourseDetailScreen), findsOneWidget);
    
    // Verify Course Title in AppBar (Checking text might be tricky with Slivers, but let's try)
    // Note: In our implementation, title text might be hidden or small in SliverAppBar initially.
    // Let's check for Units instead.
    expect(find.text('Unit 1: The Basics'), findsOneWidget);
    
    // Verify Lessons appear
    expect(find.text('Pronunciation Drill 1'), findsOneWidget);
    expect(find.text('Basic Sentences'), findsOneWidget);
  });
}
