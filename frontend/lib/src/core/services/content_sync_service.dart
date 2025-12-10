import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'content_sync_service.g.dart';

class ContentSyncService {
  final Dio _dio;

  ContentSyncService(this._dio);

  List<String> extractAssetsFromContent(String contentJson) {
    final assets = <String>[];
    // Simple regex to find our R2 URLs or any audio URL
    // Assuming URLs match patterns like https://.../filename.mp3 or /audio/filename.mp3
    // But our content uses relative or absolute paths.
    // Example: "audio": "audio/lesson_1_dialogue.mp3"

    final regex = RegExp(
      r'"(https?://[^"]+\.(?:mp3|m4a|wav))"|"(audio/[^"]+\.(?:mp3|m4a|wav))"',
    );
    final matches = regex.allMatches(contentJson);

    for (final match in matches) {
      final url = match.group(1) ?? match.group(2);
      if (url != null) {
        assets.add(url);
      }
    }
    return assets;
  }

  Future<void> downloadAssets(List<String> assets) async {
    if (assets.isEmpty) return;

    final docDir = await getApplicationDocumentsDirectory();
    final assetsDir = Directory(p.join(docDir.path, 'assets'));
    if (!assetsDir.existsSync()) {
      await assetsDir.create(recursive: true);
    }

    debugPrint('Downloading ${assets.length} assets...');

    for (final asset in assets) {
      try {
        // Normalize URL
        String url = asset;
        if (!url.startsWith('http')) {
          // Assume relative to backend base URL if configured, or predefined CDN
          // For now, let's assume the asset string IS the key or relative path.
          // If it's just "audio/file.mp3", we need to construct the full URL.
          // Let's use the Dio base URL if possible, or a known CDN constant.
          // But `_dio` has baseUrl.
          if (url.startsWith('/')) url = url.substring(1);
        }

        final fileName = p.basename(url);
        final savePath = p.join(assetsDir.path, fileName);
        final file = File(savePath);

        if (await file.exists()) {
          // Skip if already exists (could check hash/size in future)
          continue;
        }

        await _dio.download(
          url,
          savePath,
          onReceiveProgress: (received, total) {
            // Optional: Report progress
          },
        );
        // debugPrint('Downloaded: $fileName');
      } catch (e) {
        debugPrint('Failed to download asset $asset: $e');
      }
    }
    debugPrint('Asset download complete.');
  }

  Future<File?> getLocalAsset(String assetUrl) async {
    final docDir = await getApplicationDocumentsDirectory();
    final fileName = p.basename(assetUrl);
    final file = File(p.join(docDir.path, 'assets', fileName));

    if (await file.exists()) {
      return file;
    }
    return null;
  }
}

@Riverpod(keepAlive: true)
ContentSyncService contentSyncService(Ref ref) {
  // Use a separate Dio instance or the same one.
  // If assets are on CDN (R2 public), we might not need auth headers for GET,
  // but if they are protected, we do.
  // Let's use a plain Dio for R2 public links if they are absolute,
  // or the API client if they are proxied via our API.
  // Assuming proxied via /audio/:filename or direct R2 public URL.
  return ContentSyncService(Dio());
}
