import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prime_travel_flutter_ui_kit/controller/international_controller.dart';
import 'package:prime_travel_flutter_ui_kit/util/string_config.dart';
import '../../util/asset_image_paths.dart';
import '../../util/colors.dart';
import '../../util/font_family.dart';
import '../../util/size_config.dart';

class InterNationalTripScreen extends StatefulWidget {
  const InterNationalTripScreen({Key? key}) : super(key: key);

  @override
  State<InterNationalTripScreen> createState() =>
      _InterNationalTripScreenState();
}

class _InterNationalTripScreenState extends State<InterNationalTripScreen> {
  InternationalController internationalController =
      Get.put(InternationalController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorFile.whiteColor,
      appBar: _buildAppbar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: SizeFile.height10),
            GridView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: SizeFile.height20,
                ),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: SizeFile.height15,
                  mainAxisSpacing: SizeFile.height16,
                  crossAxisCount: 2,
                ),
                itemCount: internationalController.internationalList.length,
                itemBuilder: (BuildContext ctx, index) {
                  return Container(
                    padding: EdgeInsets.all(SizeFile.height8),
                    decoration: BoxDecoration(
                        color: ColorFile.whiteColor,
                        borderRadius: BorderRadius.circular(SizeFile.height10),
                        border: Border.all(
                            color: ColorFile.borderColor,
                            width: SizeFile.height1)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(children: [
                          Image.asset(
                            internationalController
                                    .internationalList[index].icon ??
                                "",
                            fit: BoxFit.fitWidth,
                            height: SizeFile.height104,
                            width: double.infinity,
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: SizeFile.height94,
                                  right: SizeFile.height8),
                              child: GestureDetector(
                                onTap: () {
                                  internationalController
                                          .tripSelectItems[index] =
                                      !internationalController
                                          .tripSelectItems[index];
                                  setState(() {});
                                },
                                child: Image.asset(
                                  internationalController.tripSelectItems[index]
                                      ? AssetImagePaths.redHeard
                                      : AssetImagePaths.heartCircle,
                                  height: SizeFile.height20,
                                ),
                              ),
                            ),
                          ),
                        ]),
                        const SizedBox(height: SizeFile.height3),
                        Text(
                            internationalController
                                .internationalList[index].text
                                .toString(),
                            style: const TextStyle(
                                color: ColorFile.onBordingColor,
                                fontFamily: satoshiMedium,
                                fontWeight: FontWeight.w400,
                                fontSize: SizeFile.height14)),
                        const SizedBox(height: SizeFile.height2),
                        Row(
                          children: [
                            Image.asset(
                              AssetImagePaths.southeastLogo,
                              height: SizeFile.height10,
                              width: SizeFile.height10,
                            ),
                            const SizedBox(width: SizeFile.height5),
                            const Text(StringConfig.southeastAsiaEast,
                                style: TextStyle(
                                    color: ColorFile.onBordingColor,
                                    fontFamily: satoshiRegular,
                                    fontWeight: FontWeight.w400,
                                    fontSize: SizeFile.height12)),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
            SizedBox(height: SizeFile.height20)
          ],
        ),
      ),
    );
  }

  _buildAppbar() {
    return AppBar(
      scrolledUnderElevation: 0.0,
      backgroundColor: ColorFile.whiteColor,
      elevation: 0,
      title: const Text(StringConfig.internationalTrip,
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
              left: SizeFile.height5,
              top: SizeFile.height20,
              bottom: SizeFile.height20,
            ),
            child: Image.asset(AssetImagePaths.backArrow2,
                height: SizeFile.height18,
                width: SizeFile.height18,
                color: ColorFile.onBordingColor),
          )),
    );
  }
}
