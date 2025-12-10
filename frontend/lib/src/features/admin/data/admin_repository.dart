import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/api/api_client.dart';
import '../../course_learning/domain/course.dart';

part 'admin_repository.g.dart';

class AdminRepository {
  final Dio _api;

  AdminRepository(this._api);

  Future<void> createCourse(Course course) async {
    try {
      await _api.post('/api/admin/courses', data: course.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateCourse(Course course) async {
    try {
      await _api.put('/api/admin/courses/${course.id}', data: course.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCourse(String id) async {
    try {
      await _api.delete('/api/admin/courses/$id');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> generateLesson(
    String topic,
    String level,
  ) async {
    try {
      final response = await _api.post(
        '/api/ai/generate-lesson',
        data: {'topic': topic, 'level': level},
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}

@riverpod
AdminRepository adminRepository(Ref ref) {
  final api = ref.watch(apiClientProvider);
  return AdminRepository(api);
}
