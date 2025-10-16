import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prime_travel_flutter_ui_kit/controller/language_controller.dart';
import 'package:prime_travel_flutter_ui_kit/util/asset_image_paths.dart';
import 'package:prime_travel_flutter_ui_kit/util/colors.dart';
import 'package:prime_travel_flutter_ui_kit/util/font_family.dart';
import 'package:prime_travel_flutter_ui_kit/util/size_config.dart';
import 'package:prime_travel_flutter_ui_kit/util/string_config.dart';

class LanguageScreen extends StatelessWidget {
  LanguageScreen({super.key});

  final LanguageController _languageController = Get.put(LanguageController());

  @override
  Widget build(BuildContext context) {
    _languageController.loadSelectedLanguage();
    return Scaffold(
      backgroundColor: ColorFile.whiteColor,
      appBar: AppBar(
          backgroundColor: ColorFile.whiteColor,
          elevation: 0,
          title: Text(StringConfig.languages.tr,
              style: TextStyle(
                  decorationColor: ColorFile.onBordingColor,
                  color: ColorFile.onBordingColor,
                  fontFamily: satoshiBold,
                  fontWeight: FontWeight.w400,
                  fontSize: SizeFile.height22)),
          centerTitle: true,
          leading: Obx(() => RotationTransition(
                turns: AlwaysStoppedAnimation(
                    _languageController.arb.value ? 0.5 : 1.0),
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
              ))),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: SizeFile.height20),
          child: Column(
            children: [
              const SizedBox(height: SizeFile.height10),
              _languages(context, StringConfig.english, StringConfig.english),
              const SizedBox(height: SizeFile.height16),
              _languages(context, StringConfig.hindi, StringConfig.hindi),
              const SizedBox(height: SizeFile.height16),
              _languages(context, StringConfig.french, StringConfig.french),
              const SizedBox(height: SizeFile.height16),
              _languages(context, StringConfig.arabic, StringConfig.arabic),
              const SizedBox(height: SizeFile.height16),
              _languages(context, StringConfig.german, StringConfig.german),
              const SizedBox(height: SizeFile.height16),
              _languages(context, StringConfig.chinese, StringConfig.chinese),
            ],
          ),
        ),
      ),
    );
  }

  Widget _languages(context, String values, String title) {
    return Center(
      child: Container(
        height: SizeFile.height56,
        width: Get.width,
        decoration: BoxDecoration(
            color: ColorFile.whiteColor,
            borderRadius: BorderRadius.circular(SizeFile.height8),
            border: Border.all(
                color: ColorFile.dividerColor.withValues(alpha: 0.15), width: 0.5),
            boxShadow: const [
              BoxShadow(
                  spreadRadius: 0,
                  color: ColorFile.border,
                  blurRadius: 3,
                  offset: Offset(0, 0))
            ]),
        child: RadioListTile(
          contentPadding: EdgeInsets.only(left: 16, right: 10),
          activeColor: ColorFile.appColor,
          value: values,
          controlAffinity: ListTileControlAffinity.trailing,
          groupValue: _languageController.languageName.value,
          onChanged: (value) {
            _languageController.languageName.value = value.toString();
            _languageController.changeLanguage(language: value);
          },
          title: Text(title,
              style: TextStyle(
                fontFamily: satoshiMedium,
                color: ColorFile.onBordingColor,
                fontWeight: FontWeight.w500,
                fontSize: SizeFile.height16,
              )),
        ),
      ),
    );
  }
}
