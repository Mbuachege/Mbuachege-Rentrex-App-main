import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:prime_travel_flutter_ui_kit/view/login_screem/login_screen.dart';

class SignUpController extends GetxController {
  // Text controllers
  final firstNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileNoController = TextEditingController();
  final passwordController = TextEditingController();

  // Toggle password visibility
  var signPasswordVisible = false.obs;

  // Email regex
  RegExp regExp = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  Future<void> registerUser() async {
    final url = Uri.parse("http://appvacation.digikatech.africa/api/User");

    final body = {
      "firstName": firstNameController.text,
      "otherNames": firstNameController.text,
      "userName": firstNameController.text,
      "email": emailController.text,
      "mobileNo": mobileNoController.text,
      "password": passwordController.text,
      "isAdminRole": false,
      "roles": ["User"],
      "isActive": true,
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // ✅ show snackbar first
        Get.snackbar(
          "Success",
          "Account created successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
        );

        // ✅ small delay so user sees message
        await Future.delayed(const Duration(seconds: 1));

        // ✅ then redirect to login
        // Get.offAllNamed("/login");
        Get.offAll(() => LoginScreen());
      } else {
        Get.snackbar(
          "Error",
          "Failed: ${response.body}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }
}
