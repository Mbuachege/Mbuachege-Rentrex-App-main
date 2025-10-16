// lib/auth/auth_interceptor.dart
import 'package:dio/dio.dart';
import 'secure_store.dart';
import 'auth_api.dart';

class AuthInterceptor extends Interceptor {
  final AuthApi api;
  AuthInterceptor(this.api);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await SecureStore.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // If unauthorized, try refresh once
    if (err.response?.statusCode == 401) {
      try {
        final newToken = await api.refreshToken();
        // retry the original request with new token
        final req = err.requestOptions;
        req.headers['Authorization'] = 'Bearer $newToken';
        final cloneResponse = await api.dio.fetch(req);
        return handler.resolve(cloneResponse);
      } catch (_) {
        // Refresh failed -> clear and bubble up
        await SecureStore.clear();
      }
    }
    super.onError(err, handler);
  }
}
