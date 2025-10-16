import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prime_travel_flutter_ui_kit/model/auth_models.dart';
import 'package:prime_travel_flutter_ui_kit/services/auth_api.dart';
import 'package:prime_travel_flutter_ui_kit/services/secure_store.dart';
import 'package:prime_travel_flutter_ui_kit/view/home_screen/home_screen.dart';

class LoginController extends GetxController {
  var signPasswordVisible = false.obs;
  var signConFormPasswordVisible = false.obs;
  // API instance
  final AuthApi api = Get.find<AuthApi>();

  // Text controllers for email & password
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Observable variables
  final RxBool isLoading = false.obs;
  final RxnString errorText = RxnString();
  var passwordVisible = false.obs;

  /// Toggles password visibility
  void togglePasswordVisibility() =>
      passwordVisible.value = !passwordVisible.value;

  /// Main login function
  Future<String?> login() async {
    final email = emailController.text.trim();
    final pass = passwordController.text;

    // Validation
    if (email.isEmpty || pass.isEmpty) {
      errorText.value = 'Email and password are required';
      return errorText.value;
    }

    isLoading.value = true;
    errorText.value = null;

    try {
      // Call API login
      final AuthResponse auth =
          await api.login(username: email, password: pass);

      // Skip OTP for now
      // if (auth.otpRequired == "1") {
      //   return 'otp_required';
      // }

      // Check account status
      if (!auth.active || auth.locked) {
        await SecureStore.clear();
        return 'Account is inactive or locked';
      }

      // Save auth data securely
      await SecureStore.saveAuth(
        token: auth.token,
        tokenExpiration: auth.tokenExpiration.toIso8601String(),
        refreshToken: auth.refreshToken,
        profileJson: jsonEncode(auth.toJson()),
      );

      // Save minimal info in GetStorage
      final box = GetStorage();
      box.write('isLoggedIn', true);
      box.write('userEmail', auth.email);
      box.write('userName', auth.username);
      box.write('mobileno', auth.mobileNo);

      return null; // Success
    } catch (e) {
      errorText.value = 'Login failed. Check your credentials or network.';
      return errorText.value;
    } finally {
      isLoading.value = false;
    }
  }

  /// Main login function
  Future<String?> loginFromGoogle(String email, String pass) async {
    // Basic validation
    if (email.isEmpty || pass.isEmpty) {
      errorText.value = 'Email and password are required';
      return errorText.value;
    }

    isLoading.value = true;
    errorText.value = null;

    try {
      // 🔹 Call login API
      final AuthResponse auth =
          await api.login(username: email, password: pass);

      // 🔹 Check account status
      if (!auth.active || auth.locked) {
        await SecureStore.clear();
        return 'Account is inactive or locked';
      }

      // 🔹 Save auth details securely
      await SecureStore.saveAuth(
        token: auth.token,
        tokenExpiration: auth.tokenExpiration.toIso8601String(),
        refreshToken: auth.refreshToken,
        profileJson: jsonEncode(auth.toJson()),
      );

      // 🔹 Save quick-access info in GetStorage
      final box = GetStorage();
      await box.write('isLoggedIn', true);
      await box.write('userEmail', auth.email);
      await box.write('userName', auth.username);
      await box.write('mobileNo', auth.mobileNo);

      print("✅ Google login successful for ${auth.username}");

      return null; // ✅ Success
    } catch (e) {
      print("❌ Google login failed: $e");
      errorText.value = 'Login failed. Check your credentials or network.';
      return errorText.value;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout(BuildContext context) async {
    final box = GetStorage();
    await box.erase(); // Clear all GetStorage data
    await SecureStore.clear(); // Clear secure storage

    // Reset in-memory/session data if needed (e.g. controllers/providers)
    Get.offAll(() => HomeScreen());
  }

  /// Check if user is logged in
  bool isLoggedIn() {
    final box = GetStorage();
    return box.read('isLoggedIn') == true;
  }

  @override
  void onClose() {
    // emailController.dispose();
    // passwordController.dispose();
    super.onClose();
  }
}
