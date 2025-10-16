import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prime_travel_flutter_ui_kit/util/colors.dart';
import '../../util/asset_image_paths.dart';
import '../../util/font_family.dart';
import '../../util/size_config.dart';
import '../../util/string_config.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  bool isReservation = false;
  bool isOffers = false;
  bool isLikes = false;
  bool isMore = false;
  bool isOffers2 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorFile.whiteColor,
      appBar: AppBar(
        backgroundColor: ColorFile.whiteColor,
        elevation: 0,
        title: const Text(StringConfig.help,
            style: TextStyle(
                decorationColor: ColorFile.onBordingColor,
                color: ColorFile.onBordingColor,
                fontFamily: satoshiBold,
                fontWeight: FontWeight.w400,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
              left: SizeFile.height20,
              right: SizeFile.height20,
              bottom: SizeFile.height15),
          child: Column(
            children: [
              const SizedBox(height: SizeFile.height10),
              Container(
                width: Get.width,
                padding: const EdgeInsets.symmetric(vertical: SizeFile.height2),
                decoration: BoxDecoration(
                    color: ColorFile.whiteColor,
                    borderRadius: BorderRadius.circular(SizeFile.height6),
                    border: Border.all(color: ColorFile.whiteColor),
                    boxShadow: const [
                      BoxShadow(
                          color: ColorFile.verticalDividerColor,
                          blurRadius: 2,
                          spreadRadius: 2,
                          offset: Offset(0, 0))
                    ]),
                child: ExpansionTile(
                  collapsedBackgroundColor: ColorFile.whiteColor,
                  clipBehavior: Clip.none,
                  shape: InputBorder.none,
                  backgroundColor: ColorFile.whiteColor,
                  title: const Text(
                    StringConfig.howDoICancelMyReservation,
                    style: TextStyle(
                      fontFamily: satoshiMedium,
                      color: ColorFile.onBordingColor,
                      fontWeight: FontWeight.w500,
                      fontSize: SizeFile.height16,
                    ),
                  ),
                  trailing: Image.asset(
                    isReservation
                        ? AssetImagePaths.arrowUpOutlinedIcon
                        : AssetImagePaths.arrowDownIcon,
                    color: ColorFile.greyColor,
                    height: SizeFile.height15,
                    width: SizeFile.height15,
                  ),
                  children: <Widget>[
                    Container(
                      width: Get.width,
                      height: SizeFile.height1,
                      color: ColorFile.appColor.withValues(alpha: 0.15),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                          left: SizeFile.height12,
                          right: SizeFile.height24,
                          top: SizeFile.height8),
                      child: Text(
                          StringConfig
                              .loremIpsumDolorSitAmetConsecteturAdipiscingElit,
                          style: TextStyle(
                            fontFamily: satoshiRegular,
                            color: ColorFile.orContinue,
                            fontWeight: FontWeight.w400,
                            fontSize: SizeFile.height14,
                          )),
                    )
                  ],
                  onExpansionChanged: (bool expanded) {
                    setState(() => isReservation = expanded);
                  },
                ),
              ),
              const SizedBox(height: SizeFile.height16),
              Container(
                width: Get.width,
                padding: const EdgeInsets.symmetric(vertical: SizeFile.height2),
                decoration: BoxDecoration(
                    color: ColorFile.whiteColor,
                    borderRadius: BorderRadius.circular(SizeFile.height6),
                    border: Border.all(color: ColorFile.whiteColor),
                    boxShadow: const [
                      BoxShadow(
                          color: ColorFile.verticalDividerColor,
                          blurRadius: 2,
                          spreadRadius: 2,
                          offset: Offset(0, 0))
                    ]),
                child: ExpansionTile(
                  collapsedBackgroundColor: ColorFile.whiteColor,
                  clipBehavior: Clip.none,
                  shape: InputBorder.none,
                  backgroundColor: ColorFile.whiteColor,
                  title: const Text(
                    StringConfig.howCanIGetMoreOffers,
                    style: TextStyle(
                      fontFamily: satoshiMedium,
                      color: ColorFile.onBordingColor,
                      fontWeight: FontWeight.w500,
                      fontSize: SizeFile.height16,
                    ),
                  ),
                  trailing: Image.asset(
                    isOffers
                        ? AssetImagePaths.arrowUpOutlinedIcon
                        : AssetImagePaths.arrowDownIcon,
                    color: ColorFile.greyColor,
                    height: SizeFile.height15,
                    width: SizeFile.height15,
                  ),
                  children: <Widget>[
                    Container(
                      width: Get.width,
                      height: SizeFile.height1,
                      color: ColorFile.appColor.withValues(alpha: 0.15),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                          left: SizeFile.height12,
                          right: SizeFile.height24,
                          top: SizeFile.height8),
                      child:
                          Text(StringConfig.loremIpsumDolorSitAmetConsectetur,
                              style: TextStyle(
                                fontFamily: satoshiRegular,
                                color: ColorFile.orContinue,
                                fontWeight: FontWeight.w400,
                                fontSize: SizeFile.height14,
                              )),
                    )
                  ],
                  onExpansionChanged: (bool expanded) {
                    setState(() => isOffers = expanded);
                  },
                ),
              ),
              const SizedBox(height: SizeFile.height16),
              Container(
                width: Get.width,
                padding: const EdgeInsets.symmetric(vertical: SizeFile.height2),
                decoration: BoxDecoration(
                    color: ColorFile.whiteColor,
                    borderRadius: BorderRadius.circular(SizeFile.height6),
                    border: Border.all(color: ColorFile.whiteColor),
                    boxShadow: const [
                      BoxShadow(
                          color: ColorFile.verticalDividerColor,
                          blurRadius: 2,
                          spreadRadius: 2,
                          offset: Offset(0, 0))
                    ]),
                child: ExpansionTile(
                  collapsedBackgroundColor: ColorFile.whiteColor,
                  clipBehavior: Clip.none,
                  shape: InputBorder.none,
                  backgroundColor: ColorFile.whiteColor,
                  title: const Text(
                    StringConfig.howDoIGetMoreLikes,
                    style: TextStyle(
                      fontFamily: satoshiMedium,
                      color: ColorFile.onBordingColor,
                      fontWeight: FontWeight.w500,
                      fontSize: SizeFile.height16,
                    ),
                  ),
                  trailing: Image.asset(
                    isLikes
                        ? AssetImagePaths.arrowUpOutlinedIcon
                        : AssetImagePaths.arrowDownIcon,
                    color: ColorFile.greyColor,
                    height: SizeFile.height15,
                    width: SizeFile.height15,
                  ),
                  children: <Widget>[
                    Container(
                      width: Get.width,
                      height: SizeFile.height1,
                      color: ColorFile.appColor.withValues(alpha: 0.15),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                          left: SizeFile.height12,
                          right: SizeFile.height24,
                          top: SizeFile.height8),
                      child:
                          Text(StringConfig.loremIpsumDolorSitAmetConsectetur,
                              style: TextStyle(
                                fontFamily: satoshiRegular,
                                color: ColorFile.orContinue,
                                fontWeight: FontWeight.w400,
                                fontSize: SizeFile.height14,
                              )),
                    )
                  ],
                  onExpansionChanged: (bool expanded) {
                    setState(() => isLikes = expanded);
                  },
                ),
              ),
              const SizedBox(height: SizeFile.height16),
              Container(
                width: Get.width,
                padding: const EdgeInsets.symmetric(vertical: SizeFile.height2),
                decoration: BoxDecoration(
                    color: ColorFile.whiteColor,
                    borderRadius: BorderRadius.circular(SizeFile.height6),
                    border: Border.all(color: ColorFile.whiteColor),
                    boxShadow: const [
                      BoxShadow(
                          color: ColorFile.verticalDividerColor,
                          blurRadius: 2,
                          spreadRadius: 2,
                          offset: Offset(0, 0))
                    ]),
                child: ExpansionTile(
                  collapsedBackgroundColor: ColorFile.whiteColor,
                  clipBehavior: Clip.none,
                  shape: InputBorder.none,
                  backgroundColor: ColorFile.whiteColor,
                  title: const Text(
                    StringConfig.howDoIGetMore,
                    style: TextStyle(
                      fontFamily: satoshiMedium,
                      color: ColorFile.onBordingColor,
                      fontWeight: FontWeight.w500,
                      fontSize: SizeFile.height16,
                    ),
                  ),
                  trailing: Image.asset(
                    isMore
                        ? AssetImagePaths.arrowUpOutlinedIcon
                        : AssetImagePaths.arrowDownIcon,
                    color: ColorFile.greyColor,
                    height: SizeFile.height15,
                    width: SizeFile.height15,
                  ),
                  children: <Widget>[
                    Container(
                      width: Get.width,
                      height: SizeFile.height1,
                      color: ColorFile.appColor.withValues(alpha: 0.15),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                          left: SizeFile.height12,
                          right: SizeFile.height24,
                          top: SizeFile.height8),
                      child:
                          Text(StringConfig.loremIpsumDolorSitAmetConsectetur,
                              style: TextStyle(
                                fontFamily: satoshiRegular,
                                color: ColorFile.orContinue,
                                fontWeight: FontWeight.w400,
                                fontSize: SizeFile.height14,
                              )),
                    )
                  ],
                  onExpansionChanged: (bool expanded) {
                    setState(() => isMore = expanded);
                  },
                ),
              ),
              const SizedBox(height: SizeFile.height16),
              Container(
                width: Get.width,
                padding: const EdgeInsets.symmetric(vertical: SizeFile.height2),
                decoration: BoxDecoration(
                    color: ColorFile.whiteColor,
                    borderRadius: BorderRadius.circular(SizeFile.height6),
                    border: Border.all(color: ColorFile.whiteColor),
                    boxShadow: const [
                      BoxShadow(
                          color: ColorFile.verticalDividerColor,
                          blurRadius: 2,
                          spreadRadius: 2,
                          offset: Offset(0, 0))
                    ]),
                child: ExpansionTile(
                  collapsedBackgroundColor: ColorFile.whiteColor,
                  clipBehavior: Clip.none,
                  shape: InputBorder.none,
                  backgroundColor: ColorFile.whiteColor,
                  title: const Text(
                    StringConfig.howCanIGetMoreOffers,
                    style: TextStyle(
                      fontFamily: satoshiMedium,
                      color: ColorFile.onBordingColor,
                      fontWeight: FontWeight.w500,
                      fontSize: SizeFile.height16,
                    ),
                  ),
                  trailing: Image.asset(
                    isOffers2
                        ? AssetImagePaths.arrowUpOutlinedIcon
                        : AssetImagePaths.arrowDownIcon,
                    color: ColorFile.greyColor,
                    height: SizeFile.height15,
                    width: SizeFile.height15,
                  ),
                  children: <Widget>[
                    Container(
                      width: Get.width,
                      height: SizeFile.height1,
                      color: ColorFile.appColor.withValues(alpha: 0.15),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                          left: SizeFile.height12,
                          right: SizeFile.height24,
                          top: SizeFile.height8),
                      child:
                          Text(StringConfig.loremIpsumDolorSitAmetConsectetur,
                              style: TextStyle(
                                fontFamily: satoshiRegular,
                                color: ColorFile.orContinue,
                                fontWeight: FontWeight.w400,
                                fontSize: SizeFile.height14,
                              )),
                    )
                  ],
                  onExpansionChanged: (bool expanded) {
                    setState(() => isOffers2 = expanded);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
