import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../util/asset_image_paths.dart';
import '../../util/colors.dart';
import '../../util/font_family.dart';
import '../../util/size_config.dart';
import '../../util/string_config.dart';

class TermAndConditionsScreen extends StatefulWidget {
  const TermAndConditionsScreen({Key? key}) : super(key: key);

  @override
  State<TermAndConditionsScreen> createState() =>
      _TermAndConditionsScreenState();
}

class _TermAndConditionsScreenState extends State<TermAndConditionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorFile.whiteColor,
      appBar: AppBar(
        backgroundColor: ColorFile.whiteColor,
        elevation: 0,
        title: const Text(StringConfig.termsAndConditionsa,
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: SizeFile.height20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SizedBox(height: SizeFile.height10),
            Text(StringConfig.clause,
                style: TextStyle(
                    decorationColor: ColorFile.onBordingColor,
                    color: ColorFile.onBordingColor,
                    fontFamily: satoshiBold,
                    fontWeight: FontWeight.w500,
                    fontSize: SizeFile.height16)),
            SizedBox(height: SizeFile.height8),
            Text(StringConfig.loremIpsumDolorSitAmetConsectetur,
                textAlign: TextAlign.left,
                style: TextStyle(
                    decorationColor: ColorFile.onBording2Color,
                    color: ColorFile.onBording2Color,
                    fontFamily: satoshiRegular,
                    fontWeight: FontWeight.w400,
                    fontSize: SizeFile.height14)),
            SizedBox(height: SizeFile.height24),
            Text(StringConfig.clause2,
                style: TextStyle(
                    decorationColor: ColorFile.onBordingColor,
                    color: ColorFile.onBordingColor,
                    fontFamily: satoshiBold,
                    fontWeight: FontWeight.w500,
                    fontSize: SizeFile.height16)),
            SizedBox(height: SizeFile.height8),
            Text(StringConfig.loremIpsumDolorSitAmetConsectetur,
                style: TextStyle(
                    decorationColor: ColorFile.onBording2Color,
                    color: ColorFile.onBording2Color,
                    fontFamily: satoshiRegular,
                    fontWeight: FontWeight.w400,
                    fontSize: SizeFile.height14)),
            SizedBox(height: SizeFile.height8),
            Text(StringConfig.loremIpsumDolorSitAmetConsectetur,
                style: TextStyle(
                    decorationColor: ColorFile.onBording2Color,
                    color: ColorFile.onBording2Color,
                    fontFamily: satoshiRegular,
                    fontWeight: FontWeight.w400,
                    fontSize: SizeFile.height14)),
            SizedBox(height: SizeFile.height24),
            Text(StringConfig.clause3,
                style: TextStyle(
                    decorationColor: ColorFile.onBordingColor,
                    color: ColorFile.onBordingColor,
                    fontFamily: satoshiBold,
                    fontWeight: FontWeight.w500,
                    fontSize: SizeFile.height16)),
            SizedBox(height: SizeFile.height8),
            Text(StringConfig.loremIpsumDolorSitAmetConsectetur,
                style: TextStyle(
                    decorationColor: ColorFile.onBording2Color,
                    color: ColorFile.onBording2Color,
                    fontFamily: satoshiRegular,
                    fontWeight: FontWeight.w400,
                    fontSize: SizeFile.height14)),
          ],
        ),
      ),
    );
  }
}
