import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../api/api_client.dart';
import 'user.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  final Dio _api;
  final Ref _ref;

  AuthRepository(this._api, this._ref);

  Future<User?> login(String email) async {
    try {
      final response = await _api.post('/api/auth/login', data: {'email': email});
      final user = User.fromJson(response.data);
      
      // Persist userId
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', user.id);
      await prefs.setString('userEmail', user.email);
      await prefs.setBool('isPremium', user.isPremium);
      if (user.displayName != null) {
        await prefs.setString('userDisplayName', user.displayName!);
      }

      // Update State
      _ref.read(currentUserProvider.notifier).setUser(user);
      
      return user;
    } catch (e) {
      print('Login failed: $e');
      return null;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _ref.read(currentUserProvider.notifier).setUser(null);
  }

  Future<void> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final userEmail = prefs.getString('userEmail');
    final userDisplayName = prefs.getString('userDisplayName');
    final isPremium = prefs.getBool('isPremium') ?? false;

    if (userId != null && userEmail != null) {
      final user = User(
        id: userId,
        email: userEmail,
        displayName: userDisplayName,
        isPremium: isPremium,
      );
      _ref.read(currentUserProvider.notifier).setUser(user);
    }
  }
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  final api = ref.watch(apiClientProvider);
  return AuthRepository(api, ref);
}

@Riverpod(keepAlive: true)
class CurrentUser extends _$CurrentUser {
  @override
  User? build() => null;

  void setUser(User? user) => state = user;
}
