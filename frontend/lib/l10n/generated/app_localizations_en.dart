// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Español Pro';

  @override
  String get goPro => 'Go Pro';

  @override
  String get logout => 'Logout';

  @override
  String get coursesTab => 'Courses';

  @override
  String get skillsTab => 'Skills';

  @override
  String get leaderboardTab => 'Leaderboard';

  @override
  String get generalProficiency => 'General Proficiency';

  @override
  String get specializedTracks => 'Specialized Tracks (ESP)';

  @override
  String lessonsCompleted(int completed, int total) {
    return '$completed / $total lessons completed';
  }

  @override
  String get lessonCompleted => 'Lesson Completed!';

  @override
  String get lessonNotFound => 'Lesson not found';

  @override
  String get downloadingContent => 'Downloading content...';

  @override
  String get completeLesson => 'Complete Lesson';

  @override
  String get completeDrill => 'Complete Drill';

  @override
  String get nextQuestion => 'Next Question';

  @override
  String get finishQuiz => 'Finish Quiz';

  @override
  String get finishSave => 'Finish & Save';

  @override
  String get quizCompleted => 'Quiz Completed!';

  @override
  String scoreResult(int score, int total) {
    return 'Score: $score / $total';
  }

  @override
  String get typeResponse => 'Type your response (in Spanish)...';

  @override
  String get endChat => 'End Chat & Complete';

  @override
  String get tapToFlip => 'Tap to flip back';

  @override
  String get tapToReveal => 'Tap to reveal';

  @override
  String get nextCard => 'Next Card';

  @override
  String get finish => 'Finish';

  @override
  String get finishReading => 'Finish Reading';

  @override
  String get listenAndSelect => 'Listen & Select';

  @override
  String get continueBtn => 'Continue';

  @override
  String get correct => 'Correct!';

  @override
  String get incorrect => 'Incorrect.';

  @override
  String get pronunciationFeedback => 'Pronunciation Feedback';

  @override
  String get gotIt => 'Got it';

  @override
  String get holdToRecord => 'Hold to record';

  @override
  String get noCoursesAvailable => 'No courses available yet.';

  @override
  String get noSkillsData => 'No skills data yet.';

  @override
  String get trackMasteryHint => 'Complete lessons to track your mastery!';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String errorWithMsg(String msg) {
    return 'Error: $msg';
  }

  @override
  String get audioDrillComingSoon => 'Audio Drill Module Coming Soon';

  @override
  String get unknownLessonType => 'Unknown Lesson Type';

  @override
  String get noContentAvailable => 'No content available';

  @override
  String get noQuizContent => 'No quiz content available';

  @override
  String get noFlashcards => 'No flashcards available';

  @override
  String get micPermissionDenied => 'Microphone permission not granted';

  @override
  String get speechEvalFailed => 'Speech evaluation failed';

  @override
  String audioPlaybackError(String error) {
    return 'Audio Playback Error: $error';
  }

  @override
  String get drillBase => 'Base';

  @override
  String get drillSubstitute => 'Substitute';

  @override
  String questionProgress(int current, int total) {
    return 'Question $current of $total';
  }

  @override
  String get rankLabel => 'Rank';

  @override
  String get xpLabel => 'XP';

  @override
  String get streakLabel => 'Streak';

  @override
  String get noLeaderboardData => 'No data yet.';

  @override
  String get leaderboardTitle => 'Leaderboard';

  @override
  String get comprehensionCheck => 'Comprehension Check';
}
