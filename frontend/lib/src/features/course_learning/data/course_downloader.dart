import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/services/download_manager.dart';
import 'course_repository.dart';
// For drift models if needed, though repo returns domain models

part 'course_downloader.g.dart';

class CourseDownloader {
  final CourseRepository _courseRepo;
  final DownloadManager _downloadManager;

  CourseDownloader(this._courseRepo, this._downloadManager);

  Future<void> downloadCourse(
    String courseId, {
    Function(double)? onProgress,
  }) async {
    // 1. Fetch Units
    final units = await _courseRepo.watchUnits(courseId).first;

    final allAssets = <String>{};

    // 2. Iterate Units & Lessons to find assets
    for (final unit in units) {
      final lessons = await _courseRepo.watchLessons(unit.id).first;
      for (final lesson in lessons) {
        if (lesson.contentJson != null) {
          final assets = _parseAssets(lesson.contentType, lesson.contentJson!);
          allAssets.addAll(assets);
        }
      }
    }

    if (allAssets.isEmpty) {
      onProgress?.call(1.0);
      return;
    }

    // 3. Download Assets
    int completed = 0;
    int total = allAssets.length;

    for (final url in allAssets) {
      try {
        await _downloadManager.downloadAsset(url);
      } catch (e) {
        print('Failed to download asset $url: $e');
        // Continue despite errors? Yes for now.
      }
      completed++;
      onProgress?.call(completed / total);
    }
  }

  Set<String> _parseAssets(String contentType, String jsonStr) {
    final assets = <String>{};
    try {
      final dynamic data = jsonDecode(jsonStr);

      switch (contentType) {
        case 'DIALOGUE':
          // List of lines. Each line has 'audio_ref'.
          if (data is List) {
            for (final item in data) {
              if (item['audio_ref'] != null) assets.add(item['audio_ref']);
            }
          }
          break;
        case 'DRILL':
          // List of items. 'audio' field.
          if (data is List) {
            for (final item in data) {
              if (item['audio'] != null) assets.add(item['audio']);
            }
          }
          break;
        case 'FLASHCARD':
          // List of cards. 'audio' field.
          if (data is List) {
            for (final item in data) {
              if (item['audio'] != null) assets.add(item['audio']);
            }
          }
          break;
        case 'IMAGE_QUIZ':
          // 'question_audio', and options may have images?
          if (data is List) {
            for (final item in data) {
              if (item['question_audio'] != null)
                assets.add(item['question_audio']);
              if (item['options'] is List) {
                for (final opt in item['options']) {
                  // If options have images? Currently local schema says just text/correct.
                  // If we add images later, parse here.
                }
              }
            }
          }
          break;
        case 'QUIZ':
        case 'READING':
        case 'ROLEPLAY':
          // Usually text based, but might have audio prompts later.
          // Check for common keys just in case.
          if (data is Map) {
            if (data['audio'] != null) assets.add(data['audio']);
          }
          break;
      }
    } catch (e) {
      print('Error parsing content for assets: $e');
    }
    return assets;
  }
}

@riverpod
CourseDownloader courseDownloader(Ref ref) {
  return CourseDownloader(
    ref.watch(courseRepositoryProvider),
    ref.watch(downloadManagerProvider),
  );
}
