import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/api/api_client.dart';
import '../../../core/auth/auth_repository.dart';
import '../domain/skill.dart';

part 'skill_repository.g.dart';

class SkillRepository {
  final Dio _api;
  final String? _userId;

  SkillRepository(this._api, this._userId);

  Future<List<Skill>> getSkills() async {
    if (_userId == null) return [];

    try {
      final response = await _api.get('/api/users/$_userId/skills');
      final List<dynamic> data = response.data;
      return data.map((json) => Skill.fromJson(json)).toList();
    } catch (e) {
      // Fallback or rethrow
      return [];
    }
  }
}

@riverpod
SkillRepository skillRepository(Ref ref) {
  final api = ref.watch(apiClientProvider);
  final user = ref.watch(currentUserProvider);
  return SkillRepository(api, user?.id);
}

@riverpod
Future<List<Skill>> userSkills(Ref ref) async {
  final repo = ref.watch(skillRepositoryProvider);
  return repo.getSkills();
}
