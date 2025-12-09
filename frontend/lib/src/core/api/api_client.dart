import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/auth_service.dart';
import '../constants/api_constants.dart';

part 'api_client.g.dart';

@Riverpod(keepAlive: true)
Dio apiClient(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Attempt to attach token
        try {
          final authService = ref.read(authServiceProvider);
          final token = await authService.getIdToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        } catch (e) {
          // Ignore token errors (might be unauthed request)
          print('Token attach failed: $e');
        }
        return handler.next(options);
      },
    ),
  );

  // Add logger
  dio.interceptors.add(LogInterceptor(responseBody: true));

  return dio;
}
