import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:frontend/src/core/services/audio_recorder_service.dart';
import 'package:frontend/src/features/course_learning/data/speech_evaluation_repository.dart';
import 'package:frontend/src/features/course_learning/domain/speech_evaluation_result.dart';
import 'package:frontend/src/features/course_learning/presentation/controllers/speech_evaluation_controller.dart';
import 'package:frontend/src/features/course_learning/data/learning_repository.dart';

@GenerateNiceMocks([
  MockSpec<AudioRecorderService>(),
  MockSpec<SpeechEvaluationRepository>(),
  MockSpec<LearningRepository>(),
])
import 'speech_evaluation_controller_test.mocks.dart';

void main() {
  late MockAudioRecorderService mockRecorder;
  late MockSpeechEvaluationRepository mockRepo;
  late MockLearningRepository mockLearningRepo;

  setUp(() {
    mockRecorder = MockAudioRecorderService();
    mockRepo = MockSpeechEvaluationRepository();
    mockLearningRepo = MockLearningRepository();
  });

  ProviderContainer createContainer() {
    final container = ProviderContainer(
      overrides: [
        audioRecorderServiceProvider.overrideWithValue(mockRecorder),
        speechEvaluationRepositoryProvider.overrideWithValue(mockRepo),
        learningRepositoryProvider.overrideWithValue(mockLearningRepo),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('startRecording should update state to recording', () async {
    final container = createContainer();
    final controller = container.read(
      speechEvaluationControllerProvider('test').notifier,
    );

    await controller.startRecording();

    expect(
      container.read(speechEvaluationControllerProvider('test')),
      const SpeechEvaluationState.recording(),
    );
    verify(mockRecorder.startRecording()).called(1);
  });

  test(
    'stopRecordingAndEvaluate should update state to success on success',
    () async {
      final container = createContainer();
      final controller = container.read(
        speechEvaluationControllerProvider('test').notifier,
      );

      // Mock behaviors
      when(
        mockRecorder.stopRecording(),
      ).thenAnswer((_) async => '/tmp/audio.m4a');
      when(
        mockRepo.evaluateSpeech(
          audioFile: anyNamed('audioFile'),
          referenceText: anyNamed('referenceText'),
        ),
      ).thenAnswer(
        (_) async => const SpeechEvaluationResult(
          score: 90,
          transcription: 'Hola',
          isMatch: true,
          feedback: ['Good job'],
        ),
      );

      // Simulate flow
      await controller.startRecording(); // Enter recording state
      await controller.stopRecordingAndEvaluate('Hola', 'lesson_123');

      final state = container.read(speechEvaluationControllerProvider('test'));

      expect(state, isA<SpeechEvaluationState>());
      state.mapOrNull(
        success: (s) {
          expect(s.result.score, 90);
          expect(s.result.isMatch, true);
        },
      );

      verify(mockRecorder.stopRecording()).called(1);
      verify(
        mockRepo.evaluateSpeech(
          audioFile: anyNamed('audioFile'),
          referenceText: 'Hola',
        ),
      ).called(1);
    },
  );

  test(
    'stopRecordingAndEvaluate should update state to error on failure',
    () async {
      final container = createContainer();
      final controller = container.read(
        speechEvaluationControllerProvider('test').notifier,
      );

      when(
        mockRecorder.stopRecording(),
      ).thenAnswer((_) async => '/tmp/audio.m4a');
      when(
        mockRepo.evaluateSpeech(
          audioFile: anyNamed('audioFile'),
          referenceText: anyNamed('referenceText'),
        ),
      ).thenThrow(Exception('API Error'));

      await controller.stopRecordingAndEvaluate('Hola', 'lesson_123');

      final state = container.read(speechEvaluationControllerProvider('test'));

      expect(state, const SpeechEvaluationState.error('Exception: API Error'));
    },
  );
}
