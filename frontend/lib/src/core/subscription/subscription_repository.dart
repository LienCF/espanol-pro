import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart';
import '../api/api_client.dart';
import '../auth/auth_repository.dart';

part 'subscription_repository.g.dart';

@Riverpod(keepAlive: true)
class SubscriptionRepository extends _$SubscriptionRepository {
  @override
  FutureOr<bool> build() async {
    final user = ref.watch(currentUserProvider);
    return user?.isPremium ?? false;
  }

  Future<void> startCheckoutSession() async {
    final api = ref.read(apiClientProvider);
    try {
      final response = await api.post('/api/payments/create-checkout-session');
      final url = response.data['url'];
      if (url != null) {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          throw Exception('Could not launch payment URL');
        }
      }
    } catch (e) {
      print('Checkout failed: $e');
      rethrow;
    }
  }

  Future<void> refreshSubscriptionStatus() async {
    // Force refresh user profile from backend
    final user = ref.read(currentUserProvider);
    if (user != null) {
      await ref
          .read(authRepositoryProvider)
          .login(user.email); // Re-fetch profile
    }
  }
}
