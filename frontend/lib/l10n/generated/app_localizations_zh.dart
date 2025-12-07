// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '西班牙語 Pro';

  @override
  String get goPro => '升級 Pro';

  @override
  String get logout => '登出';

  @override
  String get coursesTab => '課程';

  @override
  String get skillsTab => '技能';

  @override
  String get generalProficiency => '通用能力 (General)';

  @override
  String get specializedTracks => '專業領域 (ESP)';

  @override
  String lessonsCompleted(int completed, int total) {
    return '已完成 $completed / $total 堂課';
  }

  @override
  String get lessonCompleted => '課程完成！';

  @override
  String get lessonNotFound => '找不到課程';

  @override
  String get downloadingContent => '正在下載內容...';

  @override
  String get completeLesson => '完成課程';

  @override
  String get completeDrill => '完成練習';

  @override
  String get nextQuestion => '下一題';

  @override
  String get finishQuiz => '完成測驗';

  @override
  String get finishSave => '完成並儲存';

  @override
  String get quizCompleted => '測驗完成！';

  @override
  String scoreResult(int score, int total) {
    return '得分：$score / $total';
  }

  @override
  String get typeResponse => '輸入您的回應 (西班牙文)...';

  @override
  String get endChat => '結束對話並完成';

  @override
  String get tapToFlip => '點擊翻回正面';

  @override
  String get tapToReveal => '點擊翻開';

  @override
  String get nextCard => '下一張';

  @override
  String get finish => '完成';

  @override
  String get finishReading => '完成閱讀';

  @override
  String get listenAndSelect => '聽音辨位';

  @override
  String get continueBtn => '繼續';

  @override
  String get correct => '正確！';

  @override
  String get incorrect => '錯誤。';

  @override
  String get pronunciationFeedback => '發音建議';

  @override
  String get gotIt => '知道了';

  @override
  String get holdToRecord => '按住錄音';

  @override
  String get noCoursesAvailable => '尚無課程。';

  @override
  String get noSkillsData => '尚無技能數據。';

  @override
  String get trackMasteryHint => '完成課程以追蹤您的熟練度！';

  @override
  String get loading => '載入中...';

  @override
  String get error => '錯誤';

  @override
  String errorWithMsg(String msg) {
    return '錯誤：$msg';
  }

  @override
  String get audioDrillComingSoon => '聽力訓練模組即將推出';

  @override
  String get unknownLessonType => '未知的課程類型';

  @override
  String get noContentAvailable => '無可用內容';

  @override
  String get noQuizContent => '無測驗內容';

  @override
  String get noFlashcards => '無單字卡';

  @override
  String get micPermissionDenied => '未授權麥克風';

  @override
  String get speechEvalFailed => '語音評測失敗';

  @override
  String audioPlaybackError(String error) {
    return '音訊播放錯誤：$error';
  }

  @override
  String get drillBase => '基礎句';

  @override
  String get drillSubstitute => '替換詞';

  @override
  String questionProgress(int current, int total) {
    return '第 $current 題，共 $total 題';
  }
}
