import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/auth_repository.dart';

part 'subscription_repository.g.dart';

@Riverpod(keepAlive: true)
class SubscriptionRepository extends _$SubscriptionRepository {
  @override
  FutureOr<bool> build() async {
    final user = ref.watch(currentUserProvider);
    return user?.isPremium ?? false;
  }

  Future<void> upgradeToPro() async {
    // Simulate payment processing delay
    await Future.delayed(const Duration(seconds: 2));
    
    // In a real app, we'd call the backend to verify receipt
    // For MVP, we update local state (and should ideally call backend to update DB)
    
    // Mock: Update user state locally via AuthRepository? 
    // AuthRepository manages the source of truth.
    // Let's cheat for MVP: Update SharedPreferences and trigger a reload or re-login logic.
    // Better: Add a method to AuthRepository to `setPremium(true)`.
    
    // Since we can't easily modify AuthRepository from here without it exposing a setter,
    // let's assume AuthRepository exposes a method to refresh profile or set premium.
    
    // For this MVP, we'll just update the shared prefs and force a state update.
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isPremium', true);
    
    // Refresh auth state
    final user = ref.read(currentUserProvider);
    if (user != null) {
      ref.read(currentUserProvider.notifier).setUser(user.copyWith(isPremium: true));
    }
    
    // Force rebuild
    state = const AsyncValue.data(true);
  }
}
