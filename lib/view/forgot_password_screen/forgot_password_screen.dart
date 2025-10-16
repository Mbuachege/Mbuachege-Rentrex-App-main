import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../util/asset_image_paths.dart';
import '../../util/colors.dart';
import '../../util/common_button.dart';
import '../../util/font_family.dart';
import '../../util/size_config.dart';
import '../../util/string_config.dart';
import '../otp_screen/otp_screen.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorFile.whiteColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: SizeFile.height20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: SizeFile.height20),
                GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: SizeFile.height1,
                        top: SizeFile.height20,
                        bottom: SizeFile.height20,
                      ),
                      child: Image.asset(AssetImagePaths.backArrow2,
                          height: SizeFile.height18,
                          width: SizeFile.height18,
                          color: ColorFile.onBordingColor),
                    )),
                const SizedBox(height: SizeFile.height30),
                const Text(StringConfig.forgotPassword,
                    style: TextStyle(
                        fontSize: SizeFile.height26,
                        fontWeight: FontWeight.w500,
                        color: ColorFile.onBordingColor,
                        fontFamily: satoshiMedium)),
                const SizedBox(height: SizeFile.height4),
                const Text(StringConfig.pleaseEnterYourEmail,
                    style: TextStyle(
                        fontSize: SizeFile.height14,
                        color: ColorFile.onBording2Color,
                        fontFamily: satoshiRegular)),
                const SizedBox(height: SizeFile.height30),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return StringConfig.thisFieldIsRequired;
                    }
                    return null;
                  },
                  cursorColor: ColorFile.appColor,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorFile.appColor),
                          borderRadius:
                              BorderRadius.circular(SizeFile.height8)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorFile.appColor),
                          borderRadius:
                              BorderRadius.circular(SizeFile.height8)),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorFile.appColor),
                          borderRadius:
                              BorderRadius.circular(SizeFile.height8)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorFile.appColor),
                          borderRadius:
                              BorderRadius.circular(SizeFile.height8)),
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorFile.appColor),
                          borderRadius:
                              BorderRadius.circular(SizeFile.height8)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorFile.appColor),
                          borderRadius:
                              BorderRadius.circular(SizeFile.height8)),
                      hintText: StringConfig.enterEmail,
                      hintStyle: const TextStyle(
                          fontSize: SizeFile.height14,
                          color: ColorFile.orContinue),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(SizeFile.height12),
                        child: Image.asset(
                          AssetImagePaths.emailIcon,
                          height: SizeFile.height20,
                          width: SizeFile.height20,
                        ),
                      )),
                ),
                const SizedBox(height: SizeFile.height100),
                GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      Get.to(OtpScreen(status: "Reset"));
                    }
                  },
                  child: ButtonCommon(
                    text: StringConfig.send,
                    buttonColor: ColorFile.appColor,
                    textColor: ColorFile.whiteColor,
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
