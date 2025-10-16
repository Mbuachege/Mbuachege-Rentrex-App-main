import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dio/dio.dart';
import 'package:prime_travel_flutter_ui_kit/services/auth_api.dart';
import 'package:prime_travel_flutter_ui_kit/services/secure_store.dart';
import 'package:prime_travel_flutter_ui_kit/model/auth_models.dart';

class FirebaseServices {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthApi _authApi;
  final Dio _dio;

  FirebaseServices(String baseUrl)
      : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            headers: {'accept': '*/*'},
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 15),
          ),
        ),
        _authApi = AuthApi(baseUrl);

  /// Continue with Google
  Future<bool> signInWithGoogleAndSync() async {
    print("🔹 Starting Google Sign-In...");
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print("❌ Google Sign-In cancelled.");
        return false;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user == null) throw Exception("No Firebase user found.");

      print("✅ Firebase sign-in successful: ${user.email}");

      final userData = {
        "firstName": user.displayName?.split(" ").first ?? "User",
        "otherNames": user.displayName?.split(" ").skip(1).join(" ") ?? "",
        "userName": user.email?.split("@").first ?? user.uid,
        "email": user.email,
        "mobileNo": user.phoneNumber ?? "",
        "isAdminRole": false,
        "roles": ["User"],
        "isActive": true,
        "password": user.uid, // use UID as password
      };

      bool userExists = false;

      try {
        await _dio.post("/api/User", data: userData);
        print("✅ User created successfully: $userData");
      } on DioException catch (e) {
        if (e.response?.statusCode == 409) {
          print("⚠️ User already exists, proceeding to login...");
          userExists = true;
        } else {
          print("❌ User creation failed: ${e.response?.statusCode}");
          rethrow;
        }
      }

      // Try login via Auth API
      try {
        await _authApi.login(username: user.email!, password: user.uid);
        print("✅ Login successful!");
        return true;
      } catch (e) {
        print("❌ Login failed: $e");
        throw Exception(
            "Wrong credentials. Please reset your password or use another account.");
      }
    } catch (e) {
      print("❌ Google Sign-In or sync failed: $e");
      return false;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    print("🚪 Signed out successfully");
  }
}
