import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prime_travel_flutter_ui_kit/controller/login_controller.dart';
import 'package:prime_travel_flutter_ui_kit/controller/sign_up_controller.dart';
import 'package:prime_travel_flutter_ui_kit/services/firebase_service.dart';
import 'package:prime_travel_flutter_ui_kit/util/asset_image_paths.dart';
import 'package:prime_travel_flutter_ui_kit/util/colors.dart';
import 'package:prime_travel_flutter_ui_kit/util/common_button.dart';
import 'package:prime_travel_flutter_ui_kit/util/font_family.dart';
import 'package:prime_travel_flutter_ui_kit/util/size_config.dart';
import 'package:prime_travel_flutter_ui_kit/util/string_config.dart';
import 'package:prime_travel_flutter_ui_kit/view/home_screen/home_screen.dart';
import 'package:prime_travel_flutter_ui_kit/view/sign_up_screen/sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  final Function? popOnSuccess; // Callback to return on success

  const LoginScreen({Key? key, this.popOnSuccess}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final FirebaseServices firebaseServices = Get.find<FirebaseServices>();

  /// Ensure only one instance of controller
  final loginController = Get.put(LoginController());
  final signUpController = Get.put(SignUpController());

  bool passwordVisible = false;

  @override
  void initState() {
    passwordVisible = false; // start with password hidden
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorFile.whiteColor,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: ColorFile.whiteColor,
        elevation: 0,
        leading: const SizedBox(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: SizeFile.height20),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: SizeFile.height35),

                const Text(
                  StringConfig.welcomeBack,
                  style: TextStyle(
                    fontSize: SizeFile.height26,
                    color: ColorFile.onBordingColor,
                    fontFamily: satoshiMedium,
                  ),
                ),
                const SizedBox(height: SizeFile.height4),
                const Text(
                  StringConfig.pleaseEnterYourDetails,
                  style: TextStyle(
                    fontSize: SizeFile.height14,
                    color: ColorFile.onBording2Color,
                    fontFamily: satoshiRegular,
                  ),
                ),
                const SizedBox(height: SizeFile.height30),

                // Email input field
                TextFormField(
                  controller: loginController.emailController,
                  validator: (value) {
                    final email = value?.trim() ?? "";
                    print('Email entered: $email');

                    if (email.isEmpty) {
                      return "\u24D8 ${StringConfig.thisFieldIsRequired}";
                    } else if (!signUpController.regExp.hasMatch(email)) {
                      return "\u24D8 Invalid email id";
                    }
                    return null;
                  },
                  cursorColor: ColorFile.appColor,
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: ColorFile.redColor),
                      borderRadius: BorderRadius.circular(SizeFile.height8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: ColorFile.appColor),
                      borderRadius: BorderRadius.circular(SizeFile.height8),
                    ),
                    hintText: StringConfig.enterEmail,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(SizeFile.height12),
                      child: Image.asset(
                        AssetImagePaths.emailIcon,
                        height: SizeFile.height18,
                        width: SizeFile.height18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: SizeFile.height20),

                // Password input field
                TextFormField(
                  controller: loginController.passwordController,
                  validator: (value) {
                    final pwd = value?.trim() ?? "";
                    print('Password entered: $pwd');

                    if (pwd.isEmpty) {
                      return "\u24D8 ${StringConfig.thisFieldIsRequired}";
                    }
                    return null;
                  },
                  obscureText: !passwordVisible,
                  cursorColor: ColorFile.appColor,
                  decoration: InputDecoration(
                    isDense: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: ColorFile.appColor),
                      borderRadius: BorderRadius.circular(SizeFile.height8),
                    ),
                    hintText: StringConfig.enterPassword,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(SizeFile.height12),
                      child: Image.asset(
                        AssetImagePaths.passwordLock,
                        height: SizeFile.height18,
                        width: SizeFile.height18,
                      ),
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(SizeFile.height12),
                        child: Image.asset(
                          passwordVisible
                              ? AssetImagePaths.passwordVisible
                              : AssetImagePaths.passwordNotVisible,
                          height: SizeFile.height20,
                          width: SizeFile.height20,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: SizeFile.height12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: Implement Forgot Password Navigation
                      Get.snackbar("Forgot Password",
                          "Redirect to reset password screen");
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: ColorFile.appColor,
                        fontSize: SizeFile.height14,
                        fontFamily: satoshiMedium,
                      ),
                    ),
                  ),
                ),
                // Error handling and login button
                Obx(() {
                  final err = loginController.errorText.value;
                  if (err == null) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      err,
                      style: const TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  );
                }),

                const SizedBox(height: SizeFile.height10),

                Obx(() => GestureDetector(
                      onTap: loginController.isLoading.value
                          ? null
                          : () async {
                              if (!formKey.currentState!.validate()) return;

                              final result = await loginController.login();

                              if (result == null) {
                                // login successful
                                if (Navigator.canPop(context)) {
                                  Navigator.pop(context);
                                }
                                Get.offAll(() => HomeScreen());
                              } else {
                                loginController.errorText.value = result;
                              }
                            },
                      child: ButtonCommon(
                        text: loginController.isLoading.value
                            ? 'Signing in...'
                            : StringConfig.logIn,
                        buttonColor: ColorFile.appColor,
                        textColor: ColorFile.whiteColor,
                      ),
                    )),
                const SizedBox(height: SizeFile.height20),

                // Divider
                Row(
                  children: const [
                    Expanded(child: Divider(thickness: 1)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text("or continue with"),
                    ),
                    Expanded(child: Divider(thickness: 1)),
                  ],
                ),
                const SizedBox(height: SizeFile.height20),

                // Social logins
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        try {
                          final success =
                              await firebaseServices.signInWithGoogleAndSync();

                          if (success) {
                            Get.snackbar(
                              "Google Login",
                              "Welcome back!",
                              snackPosition: SnackPosition.BOTTOM,
                            );
                            Get.offAll(() => const HomeScreen());
                          } else {
                            Get.snackbar(
                                "Google Login", "Sign-in cancelled or failed");
                          }
                        } catch (e, s) {
                          print("❌ Google Login Failed: $e");
                          print("Stacktrace: $s");
                          Get.snackbar("Google Login Failed", e.toString());
                        }
                      },
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image.asset(
                            "assets/images/googlelogo.png",
                            height: 28,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                const SizedBox(height: SizeFile.height20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        fontSize: SizeFile.height14,
                        fontFamily: satoshiRegular,
                        color: ColorFile.onBording2Color,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.to(() => SignUpScreen());
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: ColorFile.appColor,
                          fontSize: SizeFile.height14,
                          fontFamily: satoshiMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
