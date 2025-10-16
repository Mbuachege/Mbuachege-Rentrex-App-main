import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prime_travel_flutter_ui_kit/model/auth_models.dart';
import 'package:prime_travel_flutter_ui_kit/services/secure_store.dart';

class AuthApi {
  final Dio _dio;

  AuthApi(String baseUrl)
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          headers: {'accept': '*/*'},
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 15),
        ));

  Future<AuthResponse> login({
    required String username,
    required String password,
  }) async {
    try {
      final res = await _dio.post(
        '/api/Token',
        data: {
          'username': username,
          'password': password,
        },
        options: Options(contentType: 'application/json-patch+json'),
      );
      print('Response: ${res.data}');
      print("✅ Loginnn successful!");
      final auth = AuthResponse.fromJson(res.data as Map<String, dynamic>);

      // Persist tokens and profile in secure storage
      await SecureStore.saveAuth(
        token: auth.token,
        tokenExpiration: auth.tokenExpiration
            .toIso8601String(), // Convert DateTime to String
        refreshToken: auth.refreshToken,
        profileJson: jsonEncode(auth.toJson()),
      );
      final box = GetStorage();
      box.write('isLoggedIn', true);
      box.write('userEmail', auth.email);
      box.write('userName', auth.username);
      box.write('mobileno', auth.mobileNo);
      return auth;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // Token refresh method (assuming API exposes a refresh endpoint)
  Future<String> refreshToken() async {
    final refresh = await SecureStore.getRefreshToken();
    if (refresh == null) throw Exception('Missing refresh token');

    try {
      final res = await _dio.post(
        '/api/Token/refresh', // Adjust API path if needed
        data: {'refreshToken': refresh},
      );

      final data = res.data as Map<String, dynamic>;
      final newToken = data['token'] as String;
      final newExp = DateTime.parse(data['tokenExpiration'] as String);
      final newRefresh = data['refreshToken'] as String? ?? refresh;

      // Update stored tokens
      // Ensure tokenExpiration is passed as String
      await SecureStore.saveAuth(
        token: newToken,
        tokenExpiration: newExp.toIso8601String(), // Convert DateTime to String
        refreshToken: newRefresh,
        profileJson: await SecureStore.getProfileJson() ?? '{}',
      );

      return newToken;
    } catch (e) {
      throw Exception('Token refresh failed: $e');
    }
  }

  Dio get dio => _dio;
}
