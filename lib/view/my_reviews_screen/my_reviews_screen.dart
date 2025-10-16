import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../util/asset_image_paths.dart';
import '../../util/colors.dart';
import '../../util/font_family.dart';
import '../../util/size_config.dart';
import '../../util/string_config.dart';

class MyReviewsScreen extends StatefulWidget {
  const MyReviewsScreen({Key? key}) : super(key: key);

  @override
  State<MyReviewsScreen> createState() => _MyReviewsScreenState();
}

class _MyReviewsScreenState extends State<MyReviewsScreen> {
  List<Map<String, dynamic>> ratingReviewsList = [
    {
      "title": StringConfig.manali,
      "Icon": AssetImagePaths.manaliImage,
      "Date": StringConfig.toDay
    },
    {
      "title": StringConfig.monterey,
      "Icon": AssetImagePaths.montereyReImage,
      "Date": StringConfig.date17Dec2022
    },
    {
      "title": StringConfig.sanFranciso,
      "Icon": AssetImagePaths.sanFrancisoReImage,
      "Date": StringConfig.date12Jan2021
    },
    {
      "title": StringConfig.lockinge,
      "Icon": AssetImagePaths.lockingReImage,
      "Date": StringConfig.date17Dec2022
    },
    {
      "title": StringConfig.atlasHotel,
      "Icon": AssetImagePaths.atlasHotelImage,
      "Date": StringConfig.date02Oct2021
    },
  ];
  int rating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        leading: GestureDetector(
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
                  height: SizeFile.height40,
                  width: SizeFile.height40,
                  color: ColorFile.onBordingColor),
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: SizeFile.height10),
            ListView.builder(
                itemCount: ratingReviewsList.length,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    width: Get.width,
                    height: SizeFile.height104,
                    margin: const EdgeInsets.only(
                        bottom: SizeFile.height24,
                        left: SizeFile.height20,
                        right: SizeFile.height20),
                    padding: const EdgeInsets.only(
                        left: SizeFile.height8,
                        top: SizeFile.height8,
                        right: SizeFile.height8),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              ratingReviewsList[index]["Icon"].toString(),
                              height: SizeFile.height42,
                              width: SizeFile.height42,
                            ),
                            Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: SizeFile.height12,
                                      left: SizeFile.height12),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              ratingReviewsList[index]["title"]
                                                  .toString(),
                                              style: const TextStyle(
                                                  color:
                                                      ColorFile.onBordingColor,
                                                  fontFamily: satoshiMedium,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: SizeFile.height16)),
                                          Text(
                                              ratingReviewsList[index]["Date"]
                                                  .toString(),
                                              style: const TextStyle(
                                                  color: ColorFile.orContinue,
                                                  fontFamily: satoshiRegular,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: SizeFile.height12)),
                                        ],
                                      ),
                                      const SizedBox(height: SizeFile.height8),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Image.asset(
                                            AssetImagePaths.starYellow,
                                            height: SizeFile.height14,
                                            width: SizeFile.height14,
                                          ),
                                          const SizedBox(
                                              width: SizeFile.height4),
                                          Image.asset(
                                            AssetImagePaths.starYellow,
                                            height: SizeFile.height14,
                                            width: SizeFile.height14,
                                          ),
                                          const SizedBox(
                                              width: SizeFile.height4),
                                          Image.asset(
                                            AssetImagePaths.starYellow,
                                            height: SizeFile.height14,
                                            width: SizeFile.height14,
                                          ),
                                          const SizedBox(
                                              width: SizeFile.height4),
                                          Image.asset(
                                            AssetImagePaths.starYellow,
                                            height: SizeFile.height14,
                                            width: SizeFile.height14,
                                          ),
                                          const SizedBox(
                                              width: SizeFile.height4),
                                          Image.asset(
                                            AssetImagePaths.starIcon,
                                            height: SizeFile.height14,
                                            width: SizeFile.height14,
                                          ),
                                        ],
                                      )
                                    ],
                                  )),
                            ),
                          ],
                        ),
                        const SizedBox(height: SizeFile.height10),
                        const Text(StringConfig.thisAppIsVeryHelpfulMySuccess,
                            style: TextStyle(
                                color: ColorFile.onBordingColor,
                                fontFamily: satoshiRegular,
                                fontWeight: FontWeight.w400,
                                fontSize: SizeFile.height12)),
                      ],
                    ),
                  );
                }),
            const Center(
              child: Text(StringConfig.viewAllReviewer,
                  style: TextStyle(
                      color: ColorFile.appColor,
                      fontFamily: satoshiMedium,
                      fontWeight: FontWeight.w700,
                      fontSize: SizeFile.height14)),
            ),
            const SizedBox(height: SizeFile.height8),
          ],
        ),
      ),
    );
  }
}
