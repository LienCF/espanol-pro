import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/api/api_client.dart';

part 'analytics_repository.g.dart';

class AnalyticsRepository {
  final Dio _api;

  AnalyticsRepository(this._api);

  Future<void> logEvent(
    String eventName, {
    Map<String, dynamic>? properties,
  }) async {
    try {
      await _api.post(
        '/api/analytics/event',
        data: {'eventName': eventName, 'properties': properties ?? {}},
      );
    } catch (e) {
      // Analytics should fail silently
      debugPrint('Analytics Error: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getStats() async {
    try {
      final response = await _api.get('/api/admin/analytics/stats');
      final List<dynamic> list = response.data['stats'];
      return list.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (e) {
      debugPrint('Analytics Stats Error: $e');
      return [];
    }
  }
}

@riverpod
AnalyticsRepository analyticsRepository(Ref ref) {
  final api = ref.watch(apiClientProvider);
  return AnalyticsRepository(api);
}
