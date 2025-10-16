import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prime_travel_flutter_ui_kit/controller/sign_up_controller.dart';
import 'package:prime_travel_flutter_ui_kit/util/colors.dart';
import 'package:prime_travel_flutter_ui_kit/util/common_button.dart';
import 'package:prime_travel_flutter_ui_kit/util/size_config.dart';
import 'package:prime_travel_flutter_ui_kit/util/font_family.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  final formKey = GlobalKey<FormState>();
  final signUpController = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorFile.whiteColor,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: ColorFile.whiteColor,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(
            color: ColorFile.onBordingColor,
            fontFamily: satoshiMedium,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: SizeFile.height20),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: SizeFile.height20),

                // First Name
                TextFormField(
                  controller: signUpController.firstNameController,
                  validator: (val) => val == null || val.trim().isEmpty
                      ? "First name required"
                      : null,
                  decoration: const InputDecoration(
                    labelText: "First Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: SizeFile.height20),

                // Email
                TextFormField(
                  controller: signUpController.emailController,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return "Email required";
                    } else if (!signUpController.regExp.hasMatch(val)) {
                      return "Invalid email format";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: SizeFile.height20),

                // Mobile No
                TextFormField(
                  controller: signUpController.mobileNoController,
                  validator: (val) => val == null || val.trim().isEmpty
                      ? "Mobile number required"
                      : null,
                  decoration: const InputDecoration(
                    labelText: "Mobile Number",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: SizeFile.height20),

                // Password
                Obx(() => TextFormField(
                      controller: signUpController.passwordController,
                      obscureText: !signUpController.signPasswordVisible.value,
                      validator: (val) => val == null || val.trim().isEmpty
                          ? "Password required"
                          : null,
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            signUpController.signPasswordVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            signUpController.signPasswordVisible.value =
                                !signUpController.signPasswordVisible.value;
                          },
                        ),
                      ),
                    )),
                const SizedBox(height: SizeFile.height30),

                // Sign Up Button
                Center(
                  child: GestureDetector(
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        signUpController.registerUser();
                      }
                    },
                    child: ButtonCommon(
                      text: "Sign Up",
                      buttonColor: ColorFile.appColor,
                      textColor: ColorFile.whiteColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
