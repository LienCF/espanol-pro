import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:path/path.dart' as p;
import 'package:drift/drift.dart';
import '../../features/course_learning/data/app_database.dart';
import '../database/database_provider.dart';
import '../api/api_client.dart';

part 'download_manager.g.dart';

class DownloadManager {
  final Dio _dio;
  final AppDatabase _db;

  DownloadManager(this._dio, this._db);

  Future<void> downloadAsset(
    String url, {
    Function(int, int)? onProgress,
  }) async {
    if (!url.startsWith('http')) return;

    // Check if already downloaded
    final existing = await (_db.select(
      _db.offlineAssetsTable,
    )..where((t) => t.url.equals(url))).getSingleOrNull();
    if (existing != null && await File(existing.localPath).exists()) {
      return;
    }

    try {
      final dir = await getApplicationDocumentsDirectory();
      // Create a safe filename from URL
      final filename = p.basename(Uri.parse(url).path);
      final safeFilename = '${filename.hashCode}_$filename';
      final savePath = p.join(dir.path, 'offline_assets', safeFilename);

      // Ensure directory exists
      await Directory(p.dirname(savePath)).create(recursive: true);

      // Download
      await _dio.download(url, savePath, onReceiveProgress: onProgress);

      // Save to DB
      final file = File(savePath);
      final size = await file.length();

      await _db
          .into(_db.offlineAssetsTable)
          .insert(
            OfflineAssetsTableCompanion.insert(
              url: url,
              localPath: savePath,
              fileSize: Value(size),
              downloadedAt: Value(DateTime.now()),
            ),
            mode: InsertMode.insertOrReplace,
          );
    } catch (e) {
      debugPrint('Download failed for $url: $e');
      rethrow;
    }
  }

  Future<void> deleteAsset(String url) async {
    final asset = await (_db.select(
      _db.offlineAssetsTable,
    )..where((t) => t.url.equals(url))).getSingleOrNull();

    if (asset != null) {
      final file = File(asset.localPath);
      if (await file.exists()) {
        await file.delete();
      }
      await (_db.delete(
        _db.offlineAssetsTable,
      )..where((t) => t.url.equals(url))).go();
    }
  }
}

@Riverpod(keepAlive: true)
DownloadManager downloadManager(Ref ref) {
  final dio = ref.watch(apiClientProvider);
  final db = ref.watch(appDatabaseProvider);
  return DownloadManager(dio, db);
}
