import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prime_travel_flutter_ui_kit/controller/language_controller.dart';
import '../../util/asset_image_paths.dart';
import '../../util/colors.dart';
import '../../util/font_family.dart';
import '../../util/size_config.dart';
import '../../util/string_config.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({Key? key}) : super(key: key);

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

final LanguageController languageController = Get.put(LanguageController());

class _OffersScreenState extends State<OffersScreen> {
  @override
  Widget build(BuildContext context) {
    languageController.loadSelectedLanguage();
    return Scaffold(
      backgroundColor: ColorFile.whiteColor,
      appBar: AppBar(
        backgroundColor: ColorFile.whiteColor,
        elevation: 0,
        title: const Text(StringConfig.offers,
            style: TextStyle(
                decorationColor: ColorFile.onBordingColor,
                color: ColorFile.onBordingColor,
                fontFamily: satoshiBold,
                fontWeight: FontWeight.w500,
                fontSize: SizeFile.height22)),
        centerTitle: true,
        leading: GestureDetector(
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
                  height: SizeFile.height18,
                  width: SizeFile.height18,
                  color: ColorFile.onBordingColor),
            )),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(AssetImagePaths.welcomeOfferImage),
          Container(
            width: Get.width,
            margin: const EdgeInsets.only(
                left: SizeFile.height20,
                right: SizeFile.height20,
                top: SizeFile.height24,
                bottom: SizeFile.height24),
            padding: const EdgeInsets.symmetric(
                vertical: SizeFile.height8, horizontal: SizeFile.height8),
            decoration: BoxDecoration(
                color: ColorFile.whiteColor,
                borderRadius: BorderRadius.circular(SizeFile.height8),
                border: Border.all(color: ColorFile.whiteColor),
                boxShadow: const [
                  BoxShadow(
                      spreadRadius: SizeFile.height3,
                      color: ColorFile.verticalDividerColor,
                      blurRadius: SizeFile.height3,
                      offset: Offset(0, 0))
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(AssetImagePaths.upTo60OffImage,
                    height: SizeFile.height80,
                    width: SizeFile.height68,
                    fit: BoxFit.contain),
                Expanded(
                    child: Obx(
                  () => Padding(
                    padding: EdgeInsets.only(
                        left:
                            languageController.arb.value ? 0 : SizeFile.height8,
                        right: languageController.arb.value
                            ? SizeFile.height8
                            : 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(StringConfig.upTo60Off,
                            style: TextStyle(
                                decorationColor: ColorFile.onBordingColor,
                                color: ColorFile.onBordingColor,
                                fontFamily: satoshiBold,
                                fontWeight: FontWeight.w700,
                                fontSize: SizeFile.height15)),
                        const SizedBox(height: SizeFile.height4),
                        const Text(StringConfig.upTo515Cashback,
                            style: TextStyle(
                                decorationColor: ColorFile.onBordingColor,
                                color: ColorFile.onBordingColor,
                                fontFamily: satoshiMedium,
                                fontWeight: FontWeight.w400,
                                fontSize: SizeFile.height10)),
                        const SizedBox(height: SizeFile.height12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: SizeFile.height28,
                              width: SizeFile.height140,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: ColorFile.whiteColor,
                                  borderRadius:
                                      BorderRadius.circular(SizeFile.height6),
                                  border: Border.all(color: ColorFile.border),
                                  boxShadow: const [
                                    BoxShadow(
                                        spreadRadius: 1,
                                        color: ColorFile.whiteColor,
                                        blurRadius: 1,
                                        offset: Offset(0, 0))
                                  ]),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(StringConfig.useCode,
                                      style: TextStyle(
                                          decorationColor:
                                              ColorFile.onBordingColor,
                                          color: ColorFile.onBordingColor,
                                          fontFamily: satoshiRegular,
                                          fontWeight: FontWeight.w400,
                                          fontSize: SizeFile.height12)),
                                  Text(StringConfig.oYORAPIDO,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          decorationColor:
                                              ColorFile.onBordingColor,
                                          color: ColorFile.onBordingColor,
                                          fontFamily: satoshiBold,
                                          fontWeight: FontWeight.w400,
                                          fontSize: SizeFile.height12))
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(AssetImagePaths.expiresIcon,
                                    height: SizeFile.height12,
                                    width: SizeFile.height12),
                                const SizedBox(width: SizeFile.height2),
                                SizedBox(
                                  width: 70,
                                  child: const Text(StringConfig.expiresIn1Day,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          decorationColor:
                                              ColorFile.onBordingColor,
                                          color: ColorFile.canceledColor,
                                          fontFamily: satoshiMedium,
                                          fontWeight: FontWeight.w500,
                                          fontSize: SizeFile.height10)),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )),
              ],
            ),
          ),
          Container(
            width: Get.width,
            padding: const EdgeInsets.symmetric(
                vertical: SizeFile.height8, horizontal: SizeFile.height8),
            margin: const EdgeInsets.only(
                left: SizeFile.height20, right: SizeFile.height20),
            decoration: BoxDecoration(
                color: ColorFile.whiteColor,
                borderRadius: BorderRadius.circular(SizeFile.height8),
                border: Border.all(color: ColorFile.whiteColor),
                boxShadow: const [
                  BoxShadow(
                      spreadRadius: SizeFile.height3,
                      color: ColorFile.verticalDividerColor,
                      blurRadius: SizeFile.height3,
                      offset: Offset(0, 0))
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(AssetImagePaths.upTo50OffImage,
                    height: SizeFile.height80,
                    width: SizeFile.height68,
                    fit: BoxFit.contain),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: SizeFile.height8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(StringConfig.upTo50Off,
                            style: TextStyle(
                                decorationColor: ColorFile.onBordingColor,
                                color: ColorFile.onBordingColor,
                                fontFamily: satoshiBold,
                                fontWeight: FontWeight.w700,
                                fontSize: SizeFile.height15)),
                        const SizedBox(height: SizeFile.height4),
                        const Text(StringConfig.upTo515Cashback,
                            style: TextStyle(
                                decorationColor: ColorFile.onBordingColor,
                                color: ColorFile.onBordingColor,
                                fontFamily: satoshiMedium,
                                fontWeight: FontWeight.w400,
                                fontSize: SizeFile.height10)),
                        const SizedBox(height: SizeFile.height12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: SizeFile.height28,
                              width: SizeFile.height140,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: ColorFile.whiteColor,
                                  borderRadius:
                                      BorderRadius.circular(SizeFile.height6),
                                  border: Border.all(color: ColorFile.border),
                                  boxShadow: const [
                                    BoxShadow(
                                        spreadRadius: 1,
                                        color: ColorFile.whiteColor,
                                        blurRadius: 1,
                                        offset: Offset(0, 0))
                                  ]),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(StringConfig.useCode,
                                      style: TextStyle(
                                          decorationColor:
                                              ColorFile.onBordingColor,
                                          color: ColorFile.onBordingColor,
                                          fontFamily: satoshiRegular,
                                          fontWeight: FontWeight.w400,
                                          fontSize: SizeFile.height12)),
                                  Text(StringConfig.oYORAPIDO,
                                      style: TextStyle(
                                          decorationColor:
                                              ColorFile.onBordingColor,
                                          color: ColorFile.onBordingColor,
                                          fontFamily: satoshiBold,
                                          fontWeight: FontWeight.w400,
                                          fontSize: SizeFile.height12))
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(AssetImagePaths.expiresIcon,
                                    height: SizeFile.height12,
                                    width: SizeFile.height12),
                                const SizedBox(width: SizeFile.height2),
                                SizedBox(
                                  width: 70,
                                  child: Text(StringConfig.expiresIn1Day,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          decorationColor:
                                              ColorFile.onBordingColor,
                                          color: ColorFile.canceledColor,
                                          fontFamily: satoshiMedium,
                                          fontWeight: FontWeight.w500,
                                          fontSize: SizeFile.height10)),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: Get.width,
            padding: const EdgeInsets.symmetric(
                vertical: SizeFile.height8, horizontal: SizeFile.height8),
            margin: const EdgeInsets.only(
                left: SizeFile.height20,
                right: SizeFile.height20,
                top: SizeFile.height24),
            decoration: BoxDecoration(
                color: ColorFile.whiteColor,
                borderRadius: BorderRadius.circular(SizeFile.height8),
                border: Border.all(color: ColorFile.whiteColor),
                boxShadow: const [
                  BoxShadow(
                      spreadRadius: SizeFile.height2,
                      color: ColorFile.verticalDividerColor,
                      blurRadius: SizeFile.height2,
                      offset: Offset(0, 0))
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(AssetImagePaths.upTo350OffImage,
                    height: SizeFile.height80,
                    width: SizeFile.height68,
                    fit: BoxFit.contain),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: SizeFile.height8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(StringConfig.upTo35Off,
                            style: TextStyle(
                                decorationColor: ColorFile.onBordingColor,
                                color: ColorFile.onBordingColor,
                                fontFamily: satoshiBold,
                                fontWeight: FontWeight.w700,
                                fontSize: SizeFile.height15)),
                        const SizedBox(height: SizeFile.height4),
                        const Text(StringConfig.upTo515Cashback,
                            style: TextStyle(
                                decorationColor: ColorFile.onBordingColor,
                                color: ColorFile.onBordingColor,
                                fontFamily: satoshiMedium,
                                fontWeight: FontWeight.w400,
                                fontSize: SizeFile.height10)),
                        const SizedBox(height: SizeFile.height12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: SizeFile.height28,
                              width: SizeFile.height140,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: ColorFile.whiteColor,
                                  borderRadius:
                                      BorderRadius.circular(SizeFile.height6),
                                  border: Border.all(color: ColorFile.border),
                                  boxShadow: const [
                                    BoxShadow(
                                        spreadRadius: 1,
                                        color: ColorFile.whiteColor,
                                        blurRadius: 1,
                                        offset: Offset(0, 0))
                                  ]),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(StringConfig.useCode,
                                      style: TextStyle(
                                          decorationColor:
                                              ColorFile.onBordingColor,
                                          color: ColorFile.onBordingColor,
                                          fontFamily: satoshiRegular,
                                          fontWeight: FontWeight.w400,
                                          fontSize: SizeFile.height12)),
                                  Text(StringConfig.oYORAPIDO,
                                      style: TextStyle(
                                          decorationColor:
                                              ColorFile.onBordingColor,
                                          color: ColorFile.onBordingColor,
                                          fontFamily: satoshiBold,
                                          fontWeight: FontWeight.w400,
                                          fontSize: SizeFile.height12))
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(AssetImagePaths.expiresIcon,
                                    height: SizeFile.height12,
                                    width: SizeFile.height12),
                                const SizedBox(width: SizeFile.height2),
                                SizedBox(
                                  width: SizeFile.height70,
                                  child: const Text(StringConfig.expiresIn1Day,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          decorationColor:
                                              ColorFile.onBordingColor,
                                          color: ColorFile.canceledColor,
                                          fontFamily: satoshiMedium,
                                          fontWeight: FontWeight.w500,
                                          fontSize: SizeFile.height10)),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
