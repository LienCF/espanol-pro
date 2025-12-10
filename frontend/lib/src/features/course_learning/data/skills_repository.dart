import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/auth/auth_repository.dart';
import '../domain/skill.dart';

final skillsRepositoryProvider = Provider<SkillsRepository>((ref) {
  return SkillsRepository(
    apiClient: ref.watch(apiClientProvider),
    authRepository: ref.watch(authRepositoryProvider),
  );
});

final userSkillsProvider = FutureProvider<List<Skill>>((ref) async {
  final repo = ref.watch(skillsRepositoryProvider);
  return repo.fetchUserSkills();
});

class SkillsRepository {
  final Dio apiClient;
  final AuthRepository authRepository;

  SkillsRepository({required this.apiClient, required this.authRepository});

  Future<List<Skill>> fetchUserSkills() async {
    final userId = authRepository.currentUser?.id;
    if (userId == null) return [];

    try {
      final response = await apiClient.get('/api/users/$userId/skills');
      final List<dynamic> data = response.data;
      return data.map((json) => Skill.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error fetching skills: $e');
      return [];
    }
  }
}
