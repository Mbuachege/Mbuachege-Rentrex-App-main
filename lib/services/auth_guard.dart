import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prime_travel_flutter_ui_kit/services/secure_store.dart';
import 'package:prime_travel_flutter_ui_kit/view/login_screem/login_screen.dart';

class AuthGuard {
  static Future<bool> ensureSignedIn(BuildContext context) async {
    try {
      final token = await SecureStore.getToken();
      final expStr = await SecureStore.getTokenExpiration();

      if (token != null && token.isNotEmpty && expStr != null) {
        final exp = DateTime.tryParse(expStr);
        if (exp != null &&
            exp.isAfter(DateTime.now().add(const Duration(minutes: 1)))) {
          return true; // Token is valid, proceed
        }
      }
    } catch (e) {
      // Error handling for token retrieval
    }

    // If no token or token expired, show login screen and expect it to pop(true) on success
    final ok = await Get.to<bool>(
      () => LoginScreen(
        popOnSuccess: () {
          Navigator.pop(context, true); // This will pop with true on success
        },
      ),
    );

    return ok == true;
  }
}
