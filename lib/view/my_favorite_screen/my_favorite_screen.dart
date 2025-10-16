import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prime_travel_flutter_ui_kit/controller/international_controller.dart';
import '../../util/asset_image_paths.dart';
import '../../util/colors.dart';
import '../../util/font_family.dart';
import '../../util/size_config.dart';
import '../../util/string_config.dart';
import 'empty_favourite_screen.dart';

class MyFavoriteScreen extends StatelessWidget {
  MyFavoriteScreen({Key? key}) : super(key: key);

  final favoriteController = Get.put(InternationalController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorFile.whiteColor,
      appBar: AppBar(
        backgroundColor: ColorFile.whiteColor,
        elevation: 0,
        title: const Text(StringConfig.favorite,
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
                left: SizeFile.height1,
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
        children: [
          const SizedBox(height: SizeFile.height10),
          GridView.builder(
              padding:
                  const EdgeInsets.symmetric(horizontal: SizeFile.height20),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: SizeFile.height172,
                  mainAxisExtent: SizeFile.height172,
                  crossAxisSpacing: SizeFile.height20,
                  mainAxisSpacing: SizeFile.height20),
              itemCount: favoriteController.internationalTripList.length,
              itemBuilder: (BuildContext ctx, index) {
                return GestureDetector(
                  onTap: () {
                    Get.to(const EmptyFavouriteScreen());
                  },
                  child: Container(
                    height: SizeFile.height172,
                    width: SizeFile.height148,
                    decoration: BoxDecoration(
                      color: ColorFile.whiteColor,
                      borderRadius: BorderRadius.circular(SizeFile.height10),
                      border: Border.all(
                          color: ColorFile.whiteColor, width: SizeFile.height1),
                      boxShadow: const [
                        BoxShadow(
                          spreadRadius: SizeFile.height3,
                          color: ColorFile.verticalDividerColor,
                          blurRadius: SizeFile.height3,
                          offset: Offset(0, 0),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image section
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(SizeFile.height8),
                              child: Image.asset(
                                favoriteController
                                    .internationalTripList[index].icon!,
                                height: SizeFile
                                    .height90, // ↓ reduce this from height105
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: SizeFile.height6,
                              right: SizeFile.height6,
                              child: GestureDetector(
                                onTap: () {
                                  favoriteController
                                          .internationalTripIndex[index] =
                                      !favoriteController
                                          .internationalTripIndex[index];
                                },
                                child: Obx(() => Image.asset(
                                      favoriteController
                                              .internationalTripIndex[index]
                                          ? AssetImagePaths.heartCircle
                                          : AssetImagePaths.redHeard,
                                      height: SizeFile.height20,
                                    )),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: SizeFile.height8),
                          child: Text(
                            favoriteController
                                .internationalTripList[index].text!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                              color: ColorFile.onBordingColor,
                              fontFamily: satoshiMedium,
                              fontWeight: FontWeight.w500,
                              fontSize: SizeFile.height14,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: SizeFile.height8),
                          child: Row(
                            children: [
                              Image.asset(
                                AssetImagePaths.southeastLogo,
                                height: SizeFile.height12,
                                width: SizeFile.height12,
                              ),
                              const SizedBox(width: SizeFile.height5),
                              const Expanded(
                                child: Text(
                                  StringConfig.southeastAsiaEast,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                    color: ColorFile.onBording2Color,
                                    fontFamily: satoshiRegular,
                                    fontWeight: FontWeight.w400,
                                    fontSize: SizeFile.height12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
