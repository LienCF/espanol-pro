import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../api/api_client.dart';
import '../services/auth_service.dart';
import 'user.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  final Dio _api;
  final AuthService _authService;
  final Ref _ref;

  AuthRepository(this._api, this._authService, this._ref);

  Future<User?> login(String email, [String? password]) async {
    try {
      // 1. Try Firebase Login if password is provided
      String? token;
      if (password != null) {
        try {
          await _authService.signInWithEmailAndPassword(email, password);
          token = await _authService.getIdToken();
        } catch (e) {
          print('Firebase Login Failed: $e');
          // Fallback or rethrow? For this scaffold, we might want to fallback to dev-login
          // if Firebase isn't configured.
        }
      }

      // 2. Call Backend
      final headers = token != null ? {'Authorization': 'Bearer $token'} : <String, dynamic>{};
      final response = await _api.post(
        '/api/auth/login', 
        data: {'email': email},
        options: Options(headers: headers)
      );
      
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
    await _authService.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _ref.read(currentUserProvider.notifier).setUser(null);
  }

  Future<void> restoreSession() async {
    // Initialize Firebase
    await _authService.initialize();

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

  User? get currentUser => _ref.read(currentUserProvider);
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  final api = ref.watch(apiClientProvider);
  final authService = ref.watch(authServiceProvider);
  return AuthRepository(api, authService, ref);
}

@Riverpod(keepAlive: true)
class CurrentUser extends _$CurrentUser {
  @override
  User? build() => null;

  void setUser(User? user) => state = user;
}
