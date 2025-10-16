import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prime_travel_flutter_ui_kit/controller/home_controller%20copy.dart';
import 'package:prime_travel_flutter_ui_kit/util/common_button.dart';
import 'package:prime_travel_flutter_ui_kit/util/font_family.dart';
import '../../util/asset_image_paths.dart';
import '../../util/colors.dart';
import '../../util/size_config.dart';
import '../../util/string_config.dart';
import '../home_screen/home_screen.dart';

class GiveARatingScreen extends StatefulWidget {
  const GiveARatingScreen({Key? key}) : super(key: key);

  @override
  State<GiveARatingScreen> createState() => _GiveARatingScreenState();
}

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeControllerCopy());
  }
}

class _GiveARatingScreenState extends State<GiveARatingScreen> {
  int rating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorFile.whiteColor,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: ColorFile.whiteColor,
        elevation: 0,
        title: const Text(StringConfig.ratingAndReviews,
            style: TextStyle(
                decorationColor: ColorFile.onBordingColor,
                color: ColorFile.onBordingColor,
                fontFamily: satoshiBold,
                fontWeight: FontWeight.w500,
                fontSize: SizeFile.height22)),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              bottomNavigationIndex = 0;
              Get.offAll(() => HomeScreen(), binding: HomeBinding());
            },
            child: const Center(
              child: Padding(
                padding: EdgeInsets.only(
                    right: SizeFile.height20, left: SizeFile.height20),
                child: Text(StringConfig.skip,
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        decorationColor: ColorFile.onBordingColor,
                        color: ColorFile.onBordingColor,
                        fontFamily: satoshiBold,
                        fontWeight: FontWeight.w500,
                        fontSize: SizeFile.height16)),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(
            left: SizeFile.height20,
            right: SizeFile.height20,
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: IntrinsicHeight(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: SizeFile.height50),
                Center(
                    child: Image.asset(AssetImagePaths.profileImage,
                        height: SizeFile.height126, width: SizeFile.height126)),
                const SizedBox(height: SizeFile.height50),
                const Center(
                  child: Text(StringConfig.howWasYourExperienceWithUs,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          decorationColor: ColorFile.onBordingColor,
                          color: ColorFile.onBordingColor,
                          fontFamily: satoshiMedium,
                          fontWeight: FontWeight.w500,
                          fontSize: SizeFile.height20)),
                ),
                const SizedBox(height: SizeFile.height24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                        onTap: () {
                          setState(() {
                            rating = index += 1;
                          });
                        },
                        child: Padding(
                          padding:
                              const EdgeInsets.only(right: SizeFile.height12),
                          child: Image.asset(
                              index < rating
                                  ? AssetImagePaths.starYellow
                                  : AssetImagePaths.starIcon,
                              height: SizeFile.height26,
                              width: SizeFile.height26),
                        ));
                  }),
                ),
                const SizedBox(height: SizeFile.height70),
                const Text(StringConfig.writeAReviews,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        decorationColor: ColorFile.onBordingColor,
                        color: ColorFile.onBordingColor,
                        fontFamily: satoshiMedium,
                        fontWeight: FontWeight.w500,
                        fontSize: SizeFile.height16)),
                Container(
                  width: Get.width,
                  height: SizeFile.height113,
                  margin: const EdgeInsets.only(top: SizeFile.height14),
                  padding: const EdgeInsets.only(
                      left: SizeFile.height8, right: SizeFile.height8),
                  decoration: BoxDecoration(
                    color: ColorFile.whiteColor,
                    borderRadius: BorderRadius.circular(SizeFile.height8),
                    border: Border.all(color: ColorFile.orContinue),
                  ),
                  child: TextFormField(
                    maxLines: 5,
                    decoration: const InputDecoration(border: InputBorder.none),
                  ),
                ),
                SizedBox(
                  height: SizeFile.height55,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ShortButton(
                        buttonColor: ColorFile.appColor.withValues(alpha: 0.15),
                        textColor: ColorFile.onBordingColor,
                        text: StringConfig.cancel),
                    Spacer(),
                    GestureDetector(
                        onTap: () {
                          bottomNavigationIndex = 0;
                          Get.offAll(() => HomeScreen(),
                              binding: HomeBinding());
                        },
                        child: ShortButton(
                          buttonColor: ColorFile.appColor,
                          textColor: ColorFile.whiteColor,
                          text: StringConfig.submit,
                        )),
                  ],
                ),
                SizedBox(
                  height: SizeFile.height10,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
