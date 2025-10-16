import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../util/asset_image_paths.dart';
import '../../util/colors.dart';
import '../../util/font_family.dart';
import '../../util/size_config.dart';
import '../../util/string_config.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorFile.whiteColor,
      appBar: AppBar(
        backgroundColor: ColorFile.whiteColor,
        elevation: 0,
        title: const Text(StringConfig.raisonHotel,
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
      floatingActionButton: Container(
        height: SizeFile.height35,
        width: SizeFile.height85,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: ColorFile.appColor,
          borderRadius: BorderRadius.circular(SizeFile.height13),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AssetImagePaths.startIcon,
              height: SizeFile.height14,
              width: SizeFile.height13,
            ),
            const SizedBox(width: SizeFile.height6),
            const Text(StringConfig.start,
                style: TextStyle(
                    decorationColor: ColorFile.onBordingColor,
                    color: ColorFile.whiteColor,
                    fontFamily: satoshiRegular,
                    fontWeight: FontWeight.w400,
                    fontSize: SizeFile.height14)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(children: [
              Image.asset(AssetImagePaths.hotelMapImage),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: SizeFile.height10, horizontal: SizeFile.height20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return StringConfig.thisFieldIsRequired;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: SizeFile.height3),
                            filled: true,
                            fillColor: ColorFile.whiteColor,
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.circular(SizeFile.height8)),
                            hintText: StringConfig.searchPlaces,
                            hintStyle: const TextStyle(
                                fontSize: SizeFile.height14,
                                color: ColorFile.orContinue),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(SizeFile.height12),
                              child: Image.asset(
                                AssetImagePaths.microphoneIcon,
                                height: SizeFile.height20,
                                width: SizeFile.height20,
                              ),
                            ),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(SizeFile.height16),
                              child: Image.asset(
                                AssetImagePaths.searchIcon,
                                height: SizeFile.height10,
                                width: SizeFile.height10,
                              ),
                            )),
                      ),
                    ),
                    Image.asset(
                      AssetImagePaths.shareWhiteIcon,
                      height: SizeFile.height70,
                      width: SizeFile.height70,
                    )
                  ],
                ),
              ),
            ])
          ],
        ),
      ),
    );
  }
}
