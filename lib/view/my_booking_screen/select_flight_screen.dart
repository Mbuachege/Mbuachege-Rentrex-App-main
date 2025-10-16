import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prime_travel_flutter_ui_kit/util/common_button.dart';
import '../../util/asset_image_paths.dart';
import '../../util/colors.dart';
import '../../util/font_family.dart';
import '../../util/size_config.dart';
import '../../util/string_config.dart';

class SelectFlightScreen extends StatefulWidget {
  const SelectFlightScreen({Key? key}) : super(key: key);

  @override
  State<SelectFlightScreen> createState() => _SelectFlightScreenState();
}

class _SelectFlightScreenState extends State<SelectFlightScreen> {
  List<Map<String, dynamic>> flightList = [
    {"title": StringConfig.lionAir, "Icon": AssetImagePaths.lionAirLogo},
    {"title": StringConfig.citilink, "Icon": AssetImagePaths.citiLinkLogo},
    {"title": StringConfig.lionAir, "Icon": AssetImagePaths.lionAirLogo},
    {"title": StringConfig.citilink, "Icon": AssetImagePaths.citiLinkLogo},
    {"title": StringConfig.lionAir, "Icon": AssetImagePaths.lionAirLogo},
    {"title": StringConfig.citilink, "Icon": AssetImagePaths.citiLinkLogo},
  ];
  List<Map<String, dynamic>> detailBottomList = [
    {
      "title": StringConfig.cabinBag,
      "Icon": AssetImagePaths.cabinBagIcon,
      "subtitle": StringConfig.w8kgs,
    },
    {
      "title": StringConfig.checkIn,
      "Icon": AssetImagePaths.checkInIcon,
      "subtitle": StringConfig.w25kgs,
    },
    {
      "title": StringConfig.cancellation,
      "Icon": AssetImagePaths.cancellationIcon,
      "subtitle": StringConfig.cancellationFeeStarting,
    },
    {
      "title": StringConfig.dateChanges,
      "Icon": AssetImagePaths.datechangeIcon,
      "subtitle": StringConfig.dateChangesFeeStarting,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorFile.whiteColor,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: ColorFile.whiteColor,
        elevation: 0,
        title: const Text(StringConfig.selectFlight,
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
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: SizeFile.height20),
            child: Column(children: [
              const SizedBox(height: SizeFile.height10),
              ListView.builder(
                itemCount: flightList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      detailBottomSheet(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: SizeFile.height20),
                      padding: const EdgeInsets.only(
                        top: SizeFile.height10,
                        bottom: SizeFile.height10,
                      ),
                      decoration: BoxDecoration(
                          color: ColorFile.whiteColor,
                          borderRadius: BorderRadius.circular(SizeFile.height8),
                          border: Border.all(color: ColorFile.whiteColor),
                          boxShadow: const [
                            BoxShadow(
                                blurStyle: BlurStyle.normal,
                                spreadRadius: SizeFile.height3,
                                color: ColorFile.verticalDividerColor,
                                blurRadius: SizeFile.height3,
                                offset: Offset(1, 1))
                          ]),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: SizeFile.height28,
                                width: SizeFile.height46,
                                margin: const EdgeInsets.only(
                                    right: SizeFile.height12,
                                    left: SizeFile.height12,
                                    bottom: SizeFile.height12),
                                decoration: BoxDecoration(
                                    color: ColorFile.whiteColor,
                                    borderRadius:
                                        BorderRadius.circular(SizeFile.height4),
                                    border:
                                        Border.all(color: ColorFile.whiteColor),
                                    boxShadow: const [
                                      BoxShadow(
                                          spreadRadius: SizeFile.height3,
                                          color: ColorFile.verticalDividerColor,
                                          blurRadius: SizeFile.height3,
                                          offset: Offset(0, 0))
                                    ]),
                                child: Image.asset(
                                  flightList[index]["Icon"],
                                  height: SizeFile.height11,
                                  width: SizeFile.height38,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: SizeFile.height8,
                                      bottom: SizeFile.height12),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(flightList[index]["title"],
                                          style: const TextStyle(
                                              decorationColor:
                                                  ColorFile.onBordingColor,
                                              color: ColorFile.onBordingColor,
                                              fontFamily: satoshiMedium,
                                              fontWeight: FontWeight.w500,
                                              fontSize: SizeFile.height14)),
                                      const Text(StringConfig.r783T,
                                          style: TextStyle(
                                              decorationColor:
                                                  ColorFile.onBordingColor,
                                              color: ColorFile.orContinue,
                                              fontFamily: satoshiRegular,
                                              fontWeight: FontWeight.w400,
                                              fontSize: SizeFile.height12)),
                                    ],
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                    right: SizeFile.height11,
                                    left: SizeFile.height11),
                                child: Text(StringConfig.time1hr30Min,
                                    style: TextStyle(
                                        decorationColor:
                                            ColorFile.onBordingColor,
                                        color: ColorFile.orContinue,
                                        fontFamily: satoshiRegular,
                                        fontWeight: FontWeight.w400,
                                        fontSize: SizeFile.height12)),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: SizeFile.height12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(StringConfig.time0900AM,
                                    style: TextStyle(
                                        decorationColor:
                                            ColorFile.onBordingColor,
                                        color: ColorFile.appColor,
                                        fontFamily: satoshiMedium,
                                        fontWeight: FontWeight.w500,
                                        fontSize: SizeFile.height12)),
                                Text(StringConfig.time1030AM,
                                    style: TextStyle(
                                        color: ColorFile.appColor,
                                        fontFamily: satoshiMedium,
                                        fontWeight: FontWeight.w500,
                                        fontSize: SizeFile.height12)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: SizeFile.height12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(StringConfig.yIA,
                                    style: TextStyle(
                                        decorationColor:
                                            ColorFile.onBordingColor,
                                        color: ColorFile.onBordingColor,
                                        fontFamily: satoshiBold,
                                        fontWeight: FontWeight.w700,
                                        fontSize: SizeFile.height14)),
                                Image.asset(
                                  AssetImagePaths.flightDotCircle,
                                  height: SizeFile.height28,
                                ),
                                const Text(StringConfig.lOP,
                                    style: TextStyle(
                                        color: ColorFile.onBordingColor,
                                        fontFamily: satoshiBold,
                                        fontWeight: FontWeight.w700,
                                        fontSize: SizeFile.height14)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: SizeFile.height12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(StringConfig.yogyakarta,
                                    style: TextStyle(
                                        color: ColorFile.orContinue,
                                        fontFamily: satoshiMedium,
                                        fontWeight: FontWeight.w500,
                                        fontSize: SizeFile.height12)),
                                Text(StringConfig.lombok,
                                    style: TextStyle(
                                        color: ColorFile.orContinue,
                                        fontFamily: satoshiMedium,
                                        fontWeight: FontWeight.w500,
                                        fontSize: SizeFile.height12)),
                              ],
                            ),
                          ),
                          Container(
                            height: SizeFile.height1,
                            width: Get.width,
                            margin: const EdgeInsets.only(
                                top: SizeFile.height16,
                                bottom: SizeFile.height12),
                            color: ColorFile.appColor.withValues(alpha: 0.15),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: SizeFile.height26,
                                width: SizeFile.height101,
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(
                                    right: SizeFile.height12,
                                    left: SizeFile.height12),
                                decoration: BoxDecoration(
                                  color: ColorFile.appColor
                                      .withValues(alpha: 0.15),
                                  borderRadius:
                                      BorderRadius.circular(SizeFile.height4),
                                ),
                                child: const Text(StringConfig.businessClass,
                                    style: TextStyle(
                                        decorationColor:
                                            ColorFile.onBordingColor,
                                        color: ColorFile.appColor,
                                        fontFamily: satoshiMedium,
                                        fontWeight: FontWeight.w500,
                                        fontSize: SizeFile.height12)),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                    right: SizeFile.height12,
                                    left: SizeFile.height12),
                                child: Text(StringConfig.$2860_20,
                                    style: TextStyle(
                                        decorationColor:
                                            ColorFile.onBordingColor,
                                        color: ColorFile.appColor,
                                        fontFamily: satoshiBold,
                                        fontWeight: FontWeight.w700,
                                        fontSize: SizeFile.height14)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            ])),
      ),
    );
  }

  detailBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: ColorFile.whiteColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(SizeFile.height16),
        topRight: Radius.circular(SizeFile.height16),
      )),
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: SizeFile.height24, vertical: SizeFile.height17),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(StringConfig.economyBasicEconomySaver,
                        style: TextStyle(
                            color: ColorFile.onBordingColor,
                            fontFamily: satoshiMedium,
                            fontWeight: FontWeight.w500,
                            fontSize: SizeFile.height16)),
                    GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Image.asset(
                          AssetImagePaths.closeIcon,
                          height: SizeFile.height10,
                          width: SizeFile.height10,
                          color: ColorFile.blackColor,
                        ))
                  ],
                ),
              ),
              Divider(
                color: ColorFile.appColor.withValues(alpha: 0.15),
                height: SizeFile.height1,
                thickness: SizeFile.height1,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: SizeFile.height24, vertical: SizeFile.height10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: SizeFile.height16),
                    const Text(StringConfig.fareOfferedByAirline,
                        style: TextStyle(
                            color: ColorFile.orContinue,
                            fontFamily: satoshiMedium,
                            fontWeight: FontWeight.w500,
                            fontSize: SizeFile.height12)),
                    const SizedBox(height: SizeFile.height16),
                    ListView.builder(
                        itemCount: detailBottomList.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          detailBottomList[index]["Icon"],
                                          height: SizeFile.height13,
                                          width: SizeFile.height16,
                                          color: ColorFile.appColor,
                                        ),
                                        const SizedBox(width: SizeFile.height8),
                                        Text(detailBottomList[index]["title"],
                                            textAlign: TextAlign.start,
                                            style: const TextStyle(
                                                color: ColorFile.onBordingColor,
                                                fontFamily: satoshiMedium,
                                                fontWeight: FontWeight.w500,
                                                fontSize: SizeFile.height14)),
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Text(
                                        detailBottomList[index]["subtitle"],
                                        style: const TextStyle(
                                            color: ColorFile.orContinue,
                                            fontFamily: satoshiRegular,
                                            fontWeight: FontWeight.w400,
                                            fontSize: SizeFile.height12)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: SizeFile.height12)
                            ],
                          );
                        }),
                    const SizedBox(height: SizeFile.height10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                            text: const TextSpan(
                                text: StringConfig.totalDot,
                                style: TextStyle(
                                    color: ColorFile.onBordingColor,
                                    fontFamily: satoshiRegular,
                                    fontWeight: FontWeight.w400,
                                    fontSize: SizeFile.height14),
                                children: [
                              TextSpan(
                                  text: StringConfig.$2860,
                                  style: TextStyle(
                                      color: ColorFile.appColor,
                                      fontFamily: satoshiBold,
                                      fontWeight: FontWeight.w400,
                                      fontSize: SizeFile.height14))
                            ])),
                        GestureDetector(
                            // onTap: () {
                            //   Get.to(
                            //       SelectYourPaymentScreen(flight: "Flight"));
                            // },
                            child: ShortButton(
                          text: StringConfig.bookNow,
                          textColor: ColorFile.whiteColor,
                          buttonColor: ColorFile.appColor,
                        ))
                      ],
                    )
                  ],
                ),
              ),
            ],
          );
        });
      },
    );
  }
}
