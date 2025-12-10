import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import '../api/api_client.dart';
import '../services/auth_service.dart';
import 'app_user.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  final Dio _api;
  final AuthService _authService;
  final Ref _ref;

  AuthRepository(this._api, this._authService, this._ref);

  Future<AppUser?> login(String email, [String? password]) async {
    try {
      // 1. Try Firebase Login if password is provided
      String? token;
      if (password != null) {
        try {
          await _authService.signInWithEmailAndPassword(email, password);
          token = await _authService.getIdToken();
        } catch (e) {
          debugPrint('Firebase Login Failed: $e');
          // Auto-Register fallback
          if (e is firebase.FirebaseAuthException &&
              (e.code == 'user-not-found' || e.code == 'invalid-credential')) {
            debugPrint('User not found, attempting registration...');
            try {
              await _authService.createUserWithEmailAndPassword(
                email,
                password,
              );
              token = await _authService.getIdToken();
            } catch (regError) {
              debugPrint('Registration failed: $regError');
            }
          }
        }
      }

      // 2. Call Backend
      final headers = token != null
          ? {'Authorization': 'Bearer $token'}
          : <String, dynamic>{};
      final response = await _api.post(
        '/api/auth/login',
        data: {'email': email},
        options: Options(headers: headers),
      );

      final user = AppUser.fromJson(response.data);

      // Persist userId
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', user.id);
      await prefs.setString('userEmail', user.email);
      await prefs.setBool('isPremium', user.isPremium);
      await prefs.setInt('totalXp', user.totalXp);
      await prefs.setInt('currentStreak', user.currentStreak);
      if (user.displayName != null) {
        await prefs.setString('userDisplayName', user.displayName!);
      }

      // Update State
      _ref.read(currentUserProvider.notifier).setUser(user);

      return user;
    } catch (e) {
      debugPrint('Login failed: $e');
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
    final totalXp = prefs.getInt('totalXp') ?? 0;
    final currentStreak = prefs.getInt('currentStreak') ?? 0;

    if (userId != null && userEmail != null) {
      final user = AppUser(
        id: userId,
        email: userEmail,
        displayName: userDisplayName,
        isPremium: isPremium,
        totalXp: totalXp,
        currentStreak: currentStreak,
      );
      _ref.read(currentUserProvider.notifier).setUser(user);
    }
  }

  AppUser? get currentUser => _ref.read(currentUserProvider);
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
  AppUser? build() => null;

  void setUser(AppUser? user) => state = user;
}
