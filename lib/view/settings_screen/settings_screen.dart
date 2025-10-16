import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:prime_travel_flutter_ui_kit/View/settings_screen/privacy_policy_screen.dart';
import 'package:prime_travel_flutter_ui_kit/View/settings_screen/term_and_conditions_screen.dart';
import 'package:prime_travel_flutter_ui_kit/controller/language_controller.dart';
import 'package:prime_travel_flutter_ui_kit/view/settings_screen/language_screen.dart';
import '../../controller/setting_controller.dart';
import '../../util/asset_image_paths.dart';
import '../../util/colors.dart';
import '../../util/font_family.dart';
import '../../util/size_config.dart';
import '../../util/string_config.dart';
import 'help_screen.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({Key? key}) : super(key: key);

  final SettingController settingController = Get.put(SettingController());
  final LanguageController languageController = Get.put(LanguageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorFile.whiteColor,
      appBar: AppBar(
          backgroundColor: ColorFile.whiteColor,
          elevation: 0,
          title: Text(StringConfig.setting.tr,
              style: TextStyle(
                  decorationColor: ColorFile.onBordingColor,
                  color: ColorFile.onBordingColor,
                  fontFamily: satoshiBold,
                  fontWeight: FontWeight.w400,
                  fontSize: SizeFile.height22)),
          centerTitle: true,
          leading: Obx(
            () => RotationTransition(
              turns: AlwaysStoppedAnimation(
                  languageController.arb.value ? 0.5 : 1.0),
              child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: SizeFile.height6,
                      top: SizeFile.height20,
                      bottom: SizeFile.height20,
                    ),
                    child: Image.asset(AssetImagePaths.backArrow2,
                        height: SizeFile.height10,
                        width: SizeFile.height18,
                        color: ColorFile.onBordingColor),
                  )),
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: SizeFile.height20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: SizeFile.height10),
            Container(
              height: SizeFile.height56,
              width: Get.width,
              padding: const EdgeInsets.only(
                  left: SizeFile.height12, right: SizeFile.height12),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  color: ColorFile.whiteColor,
                  borderRadius: BorderRadius.circular(SizeFile.height8),
                  border: Border.all(color: ColorFile.whiteColor),
                  boxShadow: const [
                    BoxShadow(
                        spreadRadius: 1,
                        color: ColorFile.border,
                        blurRadius: 1,
                        offset: Offset(0, 0))
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(StringConfig.notifications.tr,
                      style: TextStyle(
                        fontFamily: satoshiMedium,
                        color: ColorFile.onBordingColor,
                        fontWeight: FontWeight.w500,
                        fontSize: SizeFile.height16,
                      )),
                  Obx(
                    () => FlutterSwitch(
                      width: SizeFile.height35,
                      height: SizeFile.height22,
                      toggleSize: SizeFile.height18,
                      padding: SizeFile.height1,
                      value: settingController.switchValue.value,
                      activeColor: ColorFile.appColor,
                      borderRadius: SizeFile.height40,
                      onToggle: (value) =>
                          settingController.toggleSwitch(value),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: SizeFile.height16),
            GestureDetector(
              onTap: () {
                Get.to(LanguageScreen());
              },
              child: Container(
                height: SizeFile.height56,
                width: Get.width,
                padding: const EdgeInsets.only(
                    left: SizeFile.height12, right: SizeFile.height12),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    color: ColorFile.whiteColor,
                    borderRadius: BorderRadius.circular(SizeFile.height8),
                    border: Border.all(color: ColorFile.whiteColor),
                    boxShadow: const [
                      BoxShadow(
                          spreadRadius: 1,
                          color: ColorFile.border,
                          blurRadius: 1,
                          offset: Offset(0, 0))
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(StringConfig.languages.tr,
                        style: TextStyle(
                          fontFamily: satoshiMedium,
                          color: ColorFile.onBordingColor,
                          fontWeight: FontWeight.w500,
                          fontSize: SizeFile.height16,
                        )),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Image.asset(
                        AssetImagePaths.arrowRightIos,
                        height: 15,
                        width: 15,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: SizeFile.height16),
            GestureDetector(
              onTap: () {
                Get.to(const HelpScreen());
              },
              child: Container(
                height: SizeFile.height56,
                width: Get.width,
                decoration: BoxDecoration(
                    color: ColorFile.whiteColor,
                    borderRadius: BorderRadius.circular(SizeFile.height8),
                    border: Border.all(color: ColorFile.whiteColor),
                    boxShadow: const [
                      BoxShadow(
                          spreadRadius: 1,
                          color: ColorFile.border,
                          blurRadius: 1,
                          offset: Offset(0, 0))
                    ]),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      Text(StringConfig.help.tr,
                          style: TextStyle(
                            fontFamily: satoshiMedium,
                            color: ColorFile.onBordingColor,
                            fontWeight: FontWeight.w500,
                            fontSize: SizeFile.height16,
                          )),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: SizeFile.height16),
            GestureDetector(
              onTap: () {
                Get.to(const TermAndConditionsScreen());
              },
              child: Container(
                height: SizeFile.height56,
                width: Get.width,
                decoration: BoxDecoration(
                    color: ColorFile.whiteColor,
                    borderRadius: BorderRadius.circular(SizeFile.height8),
                    border: Border.all(color: ColorFile.whiteColor),
                    boxShadow: const [
                      BoxShadow(
                          spreadRadius: 1,
                          color: ColorFile.border,
                          blurRadius: 1,
                          offset: Offset(0, 0))
                    ]),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      Text(StringConfig.termsAndConditions.tr,
                          style: TextStyle(
                            fontFamily: satoshiMedium,
                            color: ColorFile.onBordingColor,
                            fontWeight: FontWeight.w500,
                            fontSize: SizeFile.height16,
                          )),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: SizeFile.height16),
            GestureDetector(
              onTap: () {
                Get.to(const PrivacyPolicyScreen());
              },
              child: Container(
                height: SizeFile.height56,
                width: Get.width,
                decoration: BoxDecoration(
                    color: ColorFile.whiteColor,
                    borderRadius: BorderRadius.circular(SizeFile.height8),
                    border: Border.all(color: ColorFile.whiteColor),
                    boxShadow: const [
                      BoxShadow(
                          spreadRadius: 1,
                          color: ColorFile.border,
                          blurRadius: 1,
                          offset: Offset(0, 0))
                    ]),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      Text(StringConfig.privacyAndPolicy.tr,
                          style: TextStyle(
                            fontFamily: satoshiMedium,
                            color: ColorFile.onBordingColor,
                            fontWeight: FontWeight.w500,
                            fontSize: SizeFile.height16,
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
