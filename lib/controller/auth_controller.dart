// lib/auth/auth_controller.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prime_travel_flutter_ui_kit/model/auth_models.dart';
import 'package:prime_travel_flutter_ui_kit/services/auth_api.dart';
import 'package:prime_travel_flutter_ui_kit/services/secure_store.dart';

class AuthController extends ChangeNotifier {
  final AuthApi api;
  AuthResponse? _auth;
  bool _loading = false;

  AuthController(this.api);

  AuthResponse? get auth => _auth;
  bool get isLoading => _loading;
  bool get isLoggedIn => _auth != null;

  Future<void> tryAutoLogin() async {
    final profileJson = await SecureStore.getProfileJson();
    final token = await SecureStore.getToken();
    final expStr = await SecureStore.getTokenExpiration();
    if (profileJson == null || token == null || expStr == null) return;

    final exp = DateTime.tryParse(expStr);
    if (exp == null) return;

    // If token expired, you could attempt refresh here
    if (DateTime.now().isAfter(exp)) {
      try {
        await api.refreshToken();
      } catch (_) {
        await SecureStore.clear();
        return;
      }
    }

    _auth = AuthResponse.fromJson(jsonDecode(profileJson));
    notifyListeners();
  }

  Future<String?> login(String username, String password) async {
    _loading = true;
    notifyListeners();
    try {
      final res = await api.login(username: username, password: password);

      // OTP gate: let UI decide next step if required
      if (res.otpRequired == "1") {
        _auth = res; // store so UI can show OTP page
        notifyListeners();
        return 'otp_required';
      }

      _auth = res;
      final box = GetStorage();
      box.write('isLoggedIn', true);
      box.write('userEmail', res.email);
      box.write('userName', res.username);
      box.write('mobileno', res.mobileNo);
      notifyListeners();
      return null;
    } catch (e) {
      return 'Login failed';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await SecureStore.clear();
    _auth = null;
    notifyListeners();
  }
}
