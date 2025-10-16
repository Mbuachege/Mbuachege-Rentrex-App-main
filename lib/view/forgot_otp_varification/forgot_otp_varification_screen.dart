import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:prime_travel_flutter_ui_kit/util/asset_image_paths.dart';
import 'package:prime_travel_flutter_ui_kit/util/colors.dart';
import 'package:prime_travel_flutter_ui_kit/util/font_family.dart';
import 'package:prime_travel_flutter_ui_kit/util/size_config.dart';
import 'package:prime_travel_flutter_ui_kit/util/string_config.dart';

import '../../util/common_button.dart';
import '../create_new_password/create_new_password_screen.dart';

class ForgotOtpVerificationScreen extends StatelessWidget {
  ForgotOtpVerificationScreen({Key? key}) : super(key: key);

  final forgotOtpController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorFile.whiteColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: SizeFile.height20),
          child: Form(
            key: formKey,
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
                const Text(StringConfig.oTPVerification,
                    style: TextStyle(
                        fontSize: SizeFile.height26,
                        color: ColorFile.onBordingColor,
                        fontWeight: FontWeight.w500,
                        fontFamily: satoshiMedium)),
                const SizedBox(height: SizeFile.height4),
                const Text(StringConfig.weVeSendAOneTimePassword,
                    style: TextStyle(
                        fontSize: SizeFile.height14,
                        color: ColorFile.onBording2Color,
                        fontWeight: FontWeight.w400,
                        fontFamily: satoshiRegular)),
                const SizedBox(height: SizeFile.height30),
                Center(
                  child: Pinput(
                    defaultPinTheme: defaultPinTheme,
                    controller: forgotOtpController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return StringConfig.thisFieldIsRequired;
                      }
                      return null;
                    },
                    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                    showCursor: true,
                    // ignore: avoid_print
                    onCompleted: (pin) => print(pin),
                  ),
                ),
                const SizedBox(height: SizeFile.height40),
                const Center(
                  child: Text(StringConfig.resendCodeIn,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: SizeFile.height14,
                          color: ColorFile.onBording2Color,
                          fontFamily: satoshiRegular)),
                ),
                const Center(
                  child: Text(StringConfig.double25,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: SizeFile.height14,
                          color: ColorFile.appColor,
                          fontFamily: satoshiBold)),
                ),
                const SizedBox(height: SizeFile.height40),
                GestureDetector(
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      Get.to(CreateNewPasswordScreen());
                    }
                  },
                  child: ButtonCommon(
                    text: StringConfig.verify,
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

  final defaultPinTheme = PinTheme(
    width: SizeFile.height48,
    height: SizeFile.height56,
    margin: const EdgeInsets.only(left: SizeFile.height12),
    textStyle: const TextStyle(
        fontSize: SizeFile.height20,
        color: ColorFile.appColor,
        fontWeight: FontWeight.w400),
    decoration: BoxDecoration(
      border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
      borderRadius: BorderRadius.circular(SizeFile.height8),
    ),
  );
}
