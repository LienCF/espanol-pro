import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/course_learning/data/app_database.dart';
import '../constants/api_constants.dart';
import '../database/database_provider.dart';

part 'asset_service.g.dart';

class AssetService {
  final AppDatabase _db;

  AssetService(this._db);

  /// Resolves an asset URL. Returns a local File path if downloaded,
  /// otherwise returns the original network URL.
  Future<String> resolve(String url) async {
    if (!url.startsWith('http')) {
      // If it's a local asset (bundled) or absolute file path, return as is
      if (url.startsWith('assets/') || url.startsWith('/')) {
        return url;
      }
      // Otherwise, assume it's a relative path on the backend (e.g. "audio/file.mp3")
      return '${ApiConstants.baseUrl}/$url';
    }

    final asset = await (_db.select(
      _db.offlineAssetsTable,
    )..where((t) => t.url.equals(url))).getSingleOrNull();

    if (asset != null) {
      final file = File(asset.localPath);
      if (await file.exists()) {
        return file.path;
      } else {
        // Stale entry, delete it
        await (_db.delete(
          _db.offlineAssetsTable,
        )..where((t) => t.url.equals(url))).go();
      }
    }

    return url;
  }

  Future<bool> isDownloaded(String url) async {
    final asset = await (_db.select(
      _db.offlineAssetsTable,
    )..where((t) => t.url.equals(url))).getSingleOrNull();
    return asset != null && await File(asset.localPath).exists();
  }
}

@Riverpod(keepAlive: true)
AssetService assetService(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return AssetService(db);
}
