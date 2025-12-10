import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../core/utils/localization_helper.dart';
import '../../course_learning/data/course_repository.dart';
import '../../course_learning/domain/lesson.dart';
import 'views/dialogue_view.dart';
import 'views/drill_view.dart';
import 'views/flashcard_view.dart';
import 'views/image_quiz_view.dart';
import 'views/quiz_view.dart';
import 'views/reading_view.dart';
import 'views/roleplay_view.dart';

class NextLessonIntent extends Intent {
  const NextLessonIntent();
}

class LessonPlayerScreen extends ConsumerStatefulWidget {
  final String lessonId;
  final String courseId;

  const LessonPlayerScreen({
    super.key,
    required this.lessonId,
    required this.courseId,
  });

  @override
  ConsumerState<LessonPlayerScreen> createState() => _LessonPlayerScreenState();
}

class _LessonPlayerScreenState extends ConsumerState<LessonPlayerScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger fetch if content is missing
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndFetchContent();
    });
  }

  Future<void> _checkAndFetchContent() async {
    final lesson = await ref.read(lessonDetailProvider(widget.lessonId).future);
    if (lesson != null && lesson.contentJson == null) {
      ref.read(courseRepositoryProvider).fetchLessonDetails(widget.lessonId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lessonAsync = ref.watch(lessonDetailProvider(widget.lessonId));
    final l10n = AppLocalizations.of(context)!;

    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.arrowRight): const NextLessonIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          NextLessonIntent: CallbackAction<NextLessonIntent>(
            onInvoke: (NextLessonIntent intent) {
              if (lessonAsync.hasValue) {
                _markComplete(context);
              }
              return null;
            },
          ),
        },
        child: Scaffold(
          appBar: AppBar(
            title: lessonAsync.when(
              data: (lesson) => Text(getLocalized(context, lesson?.title)),
              loading: () => Text(l10n.loading),
              error: (err, stack) => Text(l10n.error),
            ),
          ),
          body: Focus(
            autofocus: true,
            child: lessonAsync.when(
              data: (lesson) {
                if (lesson == null) {
                  return Center(child: Text(l10n.lessonNotFound));
                }
                if (lesson.contentJson == null) {
                  return Center(
                    child: CircularProgressIndicator(
                      semanticsLabel: l10n.downloadingContent,
                    ),
                  );
                }
                return _buildLessonContent(context, lesson, ref);
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) =>
                  Center(child: Text(l10n.errorWithMsg(err.toString()))),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLessonContent(
    BuildContext context,
    Lesson lesson,
    WidgetRef ref,
  ) {
    final l10n = AppLocalizations.of(context)!;
    switch (lesson.contentType) {
      case 'DIALOGUE':
        return DialogueView(
          contentJson: lesson.contentJson,
          onComplete: () => _markComplete(context),
          lessonId: lesson.id,
        );
      case 'DRILL':
        return DrillView(
          contentJson: lesson.contentJson,
          onComplete: () => _markComplete(context),
          lessonId: lesson.id,
        );
      case 'AUDIO_DRILL':
        return Center(child: Text(l10n.audioDrillComingSoon));
      case 'QUIZ':
        return QuizView(
          contentJson: lesson.contentJson,
          onComplete: (score) =>
              _markComplete(context, isQuiz: true, score: score),
        );
      case 'ROLEPLAY':
        return RoleplayView(
          contentJson: lesson.contentJson,
          onComplete: () => _markComplete(context),
        );
      case 'FLASHCARD':
        return FlashcardView(
          contentJson: lesson.contentJson,
          onComplete: () => _markComplete(context),
        );
      case 'READING':
        return ReadingView(
          contentJson: lesson.contentJson,
          onComplete: (score) =>
              _markComplete(context, isQuiz: true, score: score),
        );
      case 'IMAGE_QUIZ':
        return ImageQuizView(
          contentJson: lesson.contentJson,
          onComplete: (score) =>
              _markComplete(context, isQuiz: true, score: score),
        );
      default:
        return Center(child: Text(l10n.unknownLessonType));
    }
  }

  void _markComplete(BuildContext context, {bool isQuiz = false, int? score}) {
    final l10n = AppLocalizations.of(context)!;
    ref
        .read(courseRepositoryProvider)
        .saveLessonProgress(
          lessonId: widget.lessonId,
          courseId: widget.courseId,
          isCorrect: isQuiz ? (score != null && score > 0) : true,
          interactionType: isQuiz ? 'QUIZ' : 'COMPLETION',
        );
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.lessonCompleted)));
    Navigator.of(context).pop();
  }
}
