import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:frontend/src/core/api/api_client.dart';
import 'package:frontend/src/features/course_learning/data/course_repository.dart';
import 'package:frontend/src/features/course_learning/domain/lesson.dart';
import 'package:frontend/src/features/course_learning/presentation/lesson_player_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:frontend/l10n/generated/app_localizations.dart';

@GenerateNiceMocks([MockSpec<Dio>()])
import 'roleplay_flow_test.mocks.dart';

void main() {
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
  });

  testWidgets('Roleplay View displays correction when API returns one', (
    tester,
  ) async {
    // 1. Setup Mock Data
    const lessonId = 'lesson_1';
    const roleplayContent = {
      'system_prompt': 'You are a tutor.',
      'initial_message': 'Hola, ¿cómo estás?',
    };

    final mockLesson = Lesson(
      id: lessonId,
      unitId: 'unit_1',
      title: 'Roleplay Lesson',
      contentType: 'ROLEPLAY',
      contentJson: jsonEncode(roleplayContent),
      orderIndex: 1,
      isCompleted: false,
    );

    // 2. Setup Overrides
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          apiClientProvider.overrideWithValue(mockDio),
          lessonDetailProvider(
            lessonId,
          ).overrideWith((ref) => Stream.value(mockLesson)),
        ],
        child: const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [Locale('en')],
          home: LessonPlayerScreen(lessonId: lessonId, courseId: 'course_1'),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // 3. Verify Initial Message
    expect(find.text('Hola, ¿cómo estás?'), findsOneWidget);

    // 4. Mock API Response with Correction
    when(mockDio.post('/api/ai/chat', data: anyNamed('data'))).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/api/ai/chat'),
        data: {
          'response':
              'Estoy bien también. [CORRECTION: Yo estoy bien - I am well (Estary vs Ser)]',
          'conversationId': 'conv_123',
        },
        statusCode: 200,
      ),
    );

    // 5. Simulate User Typing "Yo estoy bien" (Grammatically okay but let's pretend we get a correction for test sake)
    await tester.enterText(
      find.byType(TextField),
      'Yo soy bien',
    ); // Intentional error
    await tester.tap(find.byIcon(Icons.send));
    await tester.pump(); // Rebuild for typing state

    await tester.pumpAndSettle(); // Wait for async response

    // 6. Verify Response and Correction
    expect(find.text('Estoy bien también.'), findsOneWidget);
    expect(
      find.text('Yo estoy bien - I am well (Estary vs Ser)'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.lightbulb_outline), findsOneWidget);
  });
}
