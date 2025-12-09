import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Español Pro'**
  String get appTitle;

  /// No description provided for @goPro.
  ///
  /// In en, this message translates to:
  /// **'Go Pro'**
  String get goPro;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @coursesTab.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get coursesTab;

  /// No description provided for @skillsTab.
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get skillsTab;

  /// No description provided for @leaderboardTab.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get leaderboardTab;

  /// No description provided for @generalProficiency.
  ///
  /// In en, this message translates to:
  /// **'General Proficiency'**
  String get generalProficiency;

  /// No description provided for @specializedTracks.
  ///
  /// In en, this message translates to:
  /// **'Specialized Tracks (ESP)'**
  String get specializedTracks;

  /// No description provided for @lessonsCompleted.
  ///
  /// In en, this message translates to:
  /// **'{completed} / {total} lessons completed'**
  String lessonsCompleted(int completed, int total);

  /// No description provided for @lessonCompleted.
  ///
  /// In en, this message translates to:
  /// **'Lesson Completed!'**
  String get lessonCompleted;

  /// No description provided for @lessonNotFound.
  ///
  /// In en, this message translates to:
  /// **'Lesson not found'**
  String get lessonNotFound;

  /// No description provided for @downloadingContent.
  ///
  /// In en, this message translates to:
  /// **'Downloading content...'**
  String get downloadingContent;

  /// No description provided for @completeLesson.
  ///
  /// In en, this message translates to:
  /// **'Complete Lesson'**
  String get completeLesson;

  /// No description provided for @completeDrill.
  ///
  /// In en, this message translates to:
  /// **'Complete Drill'**
  String get completeDrill;

  /// No description provided for @nextQuestion.
  ///
  /// In en, this message translates to:
  /// **'Next Question'**
  String get nextQuestion;

  /// No description provided for @finishQuiz.
  ///
  /// In en, this message translates to:
  /// **'Finish Quiz'**
  String get finishQuiz;

  /// No description provided for @finishSave.
  ///
  /// In en, this message translates to:
  /// **'Finish & Save'**
  String get finishSave;

  /// No description provided for @quizCompleted.
  ///
  /// In en, this message translates to:
  /// **'Quiz Completed!'**
  String get quizCompleted;

  /// No description provided for @scoreResult.
  ///
  /// In en, this message translates to:
  /// **'Score: {score} / {total}'**
  String scoreResult(int score, int total);

  /// No description provided for @typeResponse.
  ///
  /// In en, this message translates to:
  /// **'Type your response (in Spanish)...'**
  String get typeResponse;

  /// No description provided for @endChat.
  ///
  /// In en, this message translates to:
  /// **'End Chat & Complete'**
  String get endChat;

  /// No description provided for @tapToFlip.
  ///
  /// In en, this message translates to:
  /// **'Tap to flip back'**
  String get tapToFlip;

  /// No description provided for @tapToReveal.
  ///
  /// In en, this message translates to:
  /// **'Tap to reveal'**
  String get tapToReveal;

  /// No description provided for @nextCard.
  ///
  /// In en, this message translates to:
  /// **'Next Card'**
  String get nextCard;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @finishReading.
  ///
  /// In en, this message translates to:
  /// **'Finish Reading'**
  String get finishReading;

  /// No description provided for @listenAndSelect.
  ///
  /// In en, this message translates to:
  /// **'Listen & Select'**
  String get listenAndSelect;

  /// No description provided for @continueBtn.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueBtn;

  /// No description provided for @correct.
  ///
  /// In en, this message translates to:
  /// **'Correct!'**
  String get correct;

  /// No description provided for @incorrect.
  ///
  /// In en, this message translates to:
  /// **'Incorrect.'**
  String get incorrect;

  /// No description provided for @pronunciationFeedback.
  ///
  /// In en, this message translates to:
  /// **'Pronunciation Feedback'**
  String get pronunciationFeedback;

  /// No description provided for @gotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get gotIt;

  /// No description provided for @holdToRecord.
  ///
  /// In en, this message translates to:
  /// **'Hold to record'**
  String get holdToRecord;

  /// No description provided for @noCoursesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No courses available yet.'**
  String get noCoursesAvailable;

  /// No description provided for @noSkillsData.
  ///
  /// In en, this message translates to:
  /// **'No skills data yet.'**
  String get noSkillsData;

  /// No description provided for @trackMasteryHint.
  ///
  /// In en, this message translates to:
  /// **'Complete lessons to track your mastery!'**
  String get trackMasteryHint;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @errorWithMsg.
  ///
  /// In en, this message translates to:
  /// **'Error: {msg}'**
  String errorWithMsg(String msg);

  /// No description provided for @audioDrillComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Audio Drill Module Coming Soon'**
  String get audioDrillComingSoon;

  /// No description provided for @unknownLessonType.
  ///
  /// In en, this message translates to:
  /// **'Unknown Lesson Type'**
  String get unknownLessonType;

  /// No description provided for @noContentAvailable.
  ///
  /// In en, this message translates to:
  /// **'No content available'**
  String get noContentAvailable;

  /// No description provided for @noQuizContent.
  ///
  /// In en, this message translates to:
  /// **'No quiz content available'**
  String get noQuizContent;

  /// No description provided for @noFlashcards.
  ///
  /// In en, this message translates to:
  /// **'No flashcards available'**
  String get noFlashcards;

  /// No description provided for @micPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission not granted'**
  String get micPermissionDenied;

  /// No description provided for @speechEvalFailed.
  ///
  /// In en, this message translates to:
  /// **'Speech evaluation failed'**
  String get speechEvalFailed;

  /// No description provided for @audioPlaybackError.
  ///
  /// In en, this message translates to:
  /// **'Audio Playback Error: {error}'**
  String audioPlaybackError(String error);

  /// No description provided for @drillBase.
  ///
  /// In en, this message translates to:
  /// **'Base'**
  String get drillBase;

  /// No description provided for @drillSubstitute.
  ///
  /// In en, this message translates to:
  /// **'Substitute'**
  String get drillSubstitute;

  /// No description provided for @questionProgress.
  ///
  /// In en, this message translates to:
  /// **'Question {current} of {total}'**
  String questionProgress(int current, int total);

  /// No description provided for @rankLabel.
  ///
  /// In en, this message translates to:
  /// **'Rank'**
  String get rankLabel;

  /// No description provided for @xpLabel.
  ///
  /// In en, this message translates to:
  /// **'XP'**
  String get xpLabel;

  /// No description provided for @streakLabel.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get streakLabel;

  /// No description provided for @noLeaderboardData.
  ///
  /// In en, this message translates to:
  /// **'No data yet.'**
  String get noLeaderboardData;

  /// No description provided for @leaderboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get leaderboardTitle;

  /// No description provided for @comprehensionCheck.
  ///
  /// In en, this message translates to:
  /// **'Comprehension Check'**
  String get comprehensionCheck;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
