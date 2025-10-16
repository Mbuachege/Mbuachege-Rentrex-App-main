import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:prime_travel_flutter_ui_kit/util/asset_image_paths.dart';
import 'package:prime_travel_flutter_ui_kit/util/colors.dart';
import 'package:prime_travel_flutter_ui_kit/util/size_config.dart';
import 'package:prime_travel_flutter_ui_kit/util/string_config.dart';
import 'package:share_plus/share_plus.dart';
import '../../controller/hotel_details_controller.dart';
import '../../util/common_button.dart';
import '../../util/font_family.dart';
import '../place_details/bottom_date_picker.dart';
import '../place_details/rating_review_screen.dart';

class HotelDetailsScreen extends StatefulWidget {
  const HotelDetailsScreen({Key? key}) : super(key: key);

  @override
  State<HotelDetailsScreen> createState() => _HotelDetailsScreenState();
}

class _HotelDetailsScreenState extends State<HotelDetailsScreen> {
  HotelDetailsController hotelDetailsController =
      Get.put(HotelDetailsController());
  DateTime selectedDate = DateTime.now();
  bool heartCircleVisible = false;
  int hotelImageIndex = 0;
  List<Map<String, dynamic>> reviewerList = [
    {
      "title": StringConfig.wadeWarren,
      "Icon": AssetImagePaths.wadeWarrenImage,
      "Date": StringConfig.toDay
    },
    {
      "title": StringConfig.ralphEdwards,
      "Icon": AssetImagePaths.ralphImage,
      "Date": StringConfig.yesterday
    },
    {
      "title": StringConfig.devonLane,
      "Icon": AssetImagePaths.devonImage,
      "Date": StringConfig.date10072022
    },
  ];
  List rulesAndInformationList = [
    StringConfig.guestWithFeverAreNotAllowed,
    StringConfig.guestsFromContainmentZones,
    StringConfig.unmarriedCouplesAreNotAllowed,
    StringConfig.guestsFromContainmentZones,
    StringConfig.guestWithFeverAreNotAllowed,
  ];

  List hotelImageList = [
    AssetImagePaths.hotel1Image,
    AssetImagePaths.place2,
    AssetImagePaths.place3Image,
    AssetImagePaths.place4Image,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorFile.whiteColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(hotelImageIndex == 0
                    ? AssetImagePaths.popularHotelImage
                    : hotelImageIndex == 1
                        ? AssetImagePaths.picturesqueImage
                        : hotelImageIndex == 2
                            ? AssetImagePaths.popularHotelImage
                            : hotelImageIndex == 3
                                ? AssetImagePaths.picturesqueImage
                                : AssetImagePaths.popularHotelImage),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: SizeFile.height20,
                      vertical: SizeFile.height30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: SizeFile.height1,
                              top: SizeFile.height20,
                              bottom: SizeFile.height20),
                          child: Image.asset(AssetImagePaths.backArrow2,
                              height: SizeFile.height18,
                              width: SizeFile.height18,
                              color: ColorFile.whiteColor),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Share.share(StringConfig.john);
                        },
                        child: Image.asset(AssetImagePaths.circleShareIcon,
                            color: ColorFile.whiteColor,
                            height: SizeFile.height36,
                            width: SizeFile.height36),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: SizeFile.height200),
                    _buildHotelImageList()
                  ],
                )
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: SizeFile.height20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: SizeFile.height16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(StringConfig.raisonHotel,
                          style: TextStyle(
                              color: ColorFile.onBordingColor,
                              fontFamily: satoshiMedium,
                              fontWeight: FontWeight.w500,
                              fontSize: SizeFile.height26)),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              heartCircleVisible = !heartCircleVisible;
                            });
                          },
                          child: Image.asset(
                            heartCircleVisible
                                ? AssetImagePaths.heartCircle
                                : AssetImagePaths.redHeard,
                            height: SizeFile.height26,
                            width: SizeFile.height26,
                          ))
                    ],
                  ),
                  const SizedBox(height: SizeFile.height16),
                  RichText(
                      text: const TextSpan(
                          text: StringConfig.price598Line,
                          style: TextStyle(
                              decorationColor: ColorFile.onBordingColor,
                              color: ColorFile.appColor,
                              fontFamily: satoshiBold,
                              fontWeight: FontWeight.w700,
                              fontSize: SizeFile.height15),
                          children: [
                        TextSpan(
                            text: StringConfig.perNight,
                            style: TextStyle(
                                decorationColor: ColorFile.onBordingColor,
                                color: ColorFile.orContinue,
                                fontFamily: satoshiRegular,
                                fontWeight: FontWeight.w700,
                                fontSize: SizeFile.height12))
                      ])),
                  const SizedBox(height: SizeFile.height16),
                  const Text(StringConfig.setInManali5kmFromHidimbaDeviTemple,
                      style: TextStyle(
                          color: ColorFile.onBordingColor,
                          fontFamily: satoshiRegular,
                          fontWeight: FontWeight.w500,
                          fontSize: SizeFile.height13)),
                  const SizedBox(height: SizeFile.height16),
                  const Text(StringConfig.dateOfTravelGuests,
                      style: TextStyle(
                          color: ColorFile.onBordingColor,
                          fontFamily: satoshiBold,
                          fontWeight: FontWeight.w400,
                          fontSize: SizeFile.height16)),
                  const SizedBox(height: SizeFile.height20),
                  Container(
                    width: Get.width,
                    height: SizeFile.height60,
                    padding: EdgeInsets.symmetric(vertical: SizeFile.height8),
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(SizeFile.height6),
                        color: ColorFile.whiteColor,
                        boxShadow: const [
                          BoxShadow(
                              offset: Offset(0, 0),
                              blurStyle: BlurStyle.outer,
                              blurRadius: 1,
                              spreadRadius: 1,
                              color: ColorFile.appSubText)
                        ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: SizeFile.height12),
                        GestureDetector(
                          onTap: () {
                            Get.bottomSheet(BottomDatePicker());
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: SizeFile.height18),
                            child: Image.asset(AssetImagePaths.calendarIcon,
                                height: SizeFile.height15,
                                width: SizeFile.height15),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.bottomSheet(BottomDatePicker());
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: SizeFile.height8,
                                right: SizeFile.height8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(StringConfig.date16Feb17Feb,
                                    style: TextStyle(
                                        color: ColorFile.onBordingColor,
                                        fontFamily: satoshiBold,
                                        fontWeight: FontWeight.w400,
                                        fontSize: SizeFile.height15)),
                                Text(StringConfig.time1200PM1200AM,
                                    style: TextStyle(
                                        color: ColorFile.onBording2Color,
                                        fontFamily: satoshiRegular,
                                        fontWeight: FontWeight.w400,
                                        fontSize: SizeFile.height13)),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: SizeFile.height12),
                          child: VerticalDivider(
                            color: ColorFile.verticalDividerColor,
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: SizeFile.height18,
                              left: SizeFile.height20),
                          child: Image.asset(
                            AssetImagePaths.userRounded,
                            height: SizeFile.height18,
                            width: SizeFile.height18,
                            color: ColorFile.appColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            hotelDetailsController.roomBottomSheet(context);
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: SizeFile.height8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(StringConfig.room1,
                                    style: TextStyle(
                                        color: ColorFile.onBordingColor,
                                        fontFamily: satoshiBold,
                                        fontWeight: FontWeight.w400,
                                        fontSize: SizeFile.height15)),
                                Text(StringConfig.guests1,
                                    style: TextStyle(
                                        color: ColorFile.onBording2Color,
                                        fontFamily: satoshiRegular,
                                        fontWeight: FontWeight.w400,
                                        fontSize: SizeFile.height13)),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: SizeFile.height20),
                  GestureDetector(
                    // onTap: () {
                    //   Get.to(SelectYourPaymentScreen(flight: "Hotel"));
                    // },
                    child: ButtonCommon(
                      text: StringConfig.bookNow,
                      buttonColor: ColorFile.appColor,
                      textColor: ColorFile.whiteColor,
                    ),
                  ),
                  const SizedBox(height: SizeFile.height20),
                  Container(
                      width: Get.width,
                      padding: EdgeInsets.all(SizeFile.height8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(SizeFile.height6),
                          color: ColorFile.whiteColor,
                          boxShadow: const [
                            BoxShadow(
                                offset: Offset(0, 0),
                                blurStyle: BlurStyle.outer,
                                blurRadius: SizeFile.height2,
                                spreadRadius: SizeFile.height2,
                                color: ColorFile.appSubText)
                          ]),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    AssetImagePaths.mapImage,
                                    height: SizeFile.height56,
                                    width: SizeFile.height56,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: SizeFile.height8,
                                        left: SizeFile.height8),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(StringConfig.southeastAsiaFarEast,
                                            style: TextStyle(
                                                color:
                                                    ColorFile.onBording2Color,
                                                fontFamily: satoshiRegular,
                                                fontWeight: FontWeight.w400,
                                                fontSize: SizeFile.height14)),
                                        GestureDetector(
                                          onTap: () async {
                                            final availableMaps =
                                                await MapLauncher.installedMaps;
                                            // openMaps();
                                            availableMaps[0].showMarker(
                                              coords: Coords(
                                                  37.4220041, -122.0862462),
                                              title: StringConfig.google,
                                              description:
                                                  StringConfig.googlePlex,
                                            );
                                          },
                                          child: Text(StringConfig.viewOnMap,
                                              style: TextStyle(
                                                  color: ColorFile.appColor,
                                                  fontFamily: satoshiBold,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: SizeFile.height13)),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      )),
                  const SizedBox(height: SizeFile.height22),
                  const Text(StringConfig.amenities,
                      style: TextStyle(
                          color: ColorFile.onBordingColor,
                          fontFamily: satoshiMedium,
                          fontWeight: FontWeight.w500,
                          fontSize: SizeFile.height16)),
                  const SizedBox(height: SizeFile.height16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            AssetImagePaths.wifiImage,
                            height: SizeFile.height36,
                            width: SizeFile.height40,
                          ),
                          Text(StringConfig.wiFi,
                              style: TextStyle(
                                  color: ColorFile.onBordingColor,
                                  fontFamily: satoshiMedium,
                                  fontWeight: FontWeight.w500,
                                  fontSize: SizeFile.height12)),
                        ],
                      ),
                      Column(
                        children: [
                          Image.asset(
                            AssetImagePaths.barImage,
                            height: SizeFile.height36,
                            width: SizeFile.height40,
                          ),
                          Text(StringConfig.bar,
                              style: TextStyle(
                                  color: ColorFile.onBordingColor,
                                  fontFamily: satoshiMedium,
                                  fontWeight: FontWeight.w500,
                                  fontSize: SizeFile.height12)),
                        ],
                      ),
                      Column(
                        children: [
                          Image.asset(
                            AssetImagePaths.breakfastImage,
                            height: SizeFile.height36,
                            width: SizeFile.height40,
                          ),
                          Text(StringConfig.breakFast,
                              style: TextStyle(
                                  color: ColorFile.onBordingColor,
                                  fontFamily: satoshiMedium,
                                  fontWeight: FontWeight.w500,
                                  fontSize: SizeFile.height12)),
                        ],
                      ),
                      Column(
                        children: [
                          Image.asset(
                            AssetImagePaths.poolImage,
                            height: SizeFile.height36,
                            width: SizeFile.height40,
                          ),
                          Text(StringConfig.pool,
                              style: TextStyle(
                                  color: ColorFile.onBordingColor,
                                  fontFamily: satoshiMedium,
                                  fontWeight: FontWeight.w500,
                                  fontSize: SizeFile.height12)),
                        ],
                      ),
                      Column(
                        children: [
                          Image.asset(
                            AssetImagePaths.allImage,
                            height: SizeFile.height36,
                            width: SizeFile.height40,
                          ),
                          Text(StringConfig.all,
                              style: TextStyle(
                                  color: ColorFile.onBordingColor,
                                  fontFamily: satoshiMedium,
                                  fontWeight: FontWeight.w500,
                                  fontSize: SizeFile.height12)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: SizeFile.height22),
                  const Text(StringConfig.rulesAndInformation,
                      style: TextStyle(
                          color: ColorFile.onBordingColor,
                          fontFamily: satoshiMedium,
                          fontWeight: FontWeight.w500,
                          fontSize: SizeFile.height16)),
                  const SizedBox(height: SizeFile.height16),
                  Container(
                    width: Get.width,
                    height: SizeFile.height51,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(SizeFile.height6),
                        color: ColorFile.whiteColor,
                        boxShadow: const [
                          BoxShadow(
                              offset: Offset(0, 0),
                              blurStyle: BlurStyle.outer,
                              blurRadius: SizeFile.height3,
                              spreadRadius: SizeFile.height3,
                              color: ColorFile.verticalDividerColor)
                        ]),
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Text(StringConfig.checkIn2PM,
                                    style: TextStyle(
                                        color: ColorFile.onBordingColor,
                                        fontFamily: satoshiBold,
                                        fontWeight: FontWeight.w500,
                                        fontSize: SizeFile.height14)),
                                Text(StringConfig.time2PM,
                                    style: TextStyle(
                                        color: ColorFile.onBordingColor,
                                        fontFamily: satoshiRegular,
                                        fontWeight: FontWeight.w500,
                                        fontSize: SizeFile.height14)),
                              ],
                            ),
                          ),
                          Container(
                            width: SizeFile.height1,
                            height: SizeFile.height30,
                            color: ColorFile.verticalDividerColor,
                          ),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Text(StringConfig.checkOut12PM,
                                    style: TextStyle(
                                        color: ColorFile.onBordingColor,
                                        fontFamily: satoshiBold,
                                        fontWeight: FontWeight.w500,
                                        fontSize: SizeFile.height14)),
                                Text(StringConfig.time12PM,
                                    style: TextStyle(
                                        color: ColorFile.onBordingColor,
                                        fontFamily: satoshiRegular,
                                        fontWeight: FontWeight.w500,
                                        fontSize: SizeFile.height14)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: SizeFile.height16),
                  ...List.generate(
                      rulesAndInformationList.length,
                      (index) => Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const CircleAvatar(
                                radius: SizeFile.height4,
                                backgroundColor: ColorFile.onBordingColor,
                              ),
                              const SizedBox(width: SizeFile.height6),
                              Text(rulesAndInformationList[index].toString(),
                                  style: const TextStyle(
                                      color: ColorFile.onBordingColor,
                                      fontFamily: satoshiRegular,
                                      fontWeight: FontWeight.w400,
                                      fontSize: SizeFile.height14)),
                            ],
                          )),
                  const SizedBox(height: SizeFile.height32),
                  const Text(StringConfig.reviewer,
                      style: TextStyle(
                          color: ColorFile.onBordingColor,
                          fontFamily: satoshiMedium,
                          fontWeight: FontWeight.w500,
                          fontSize: SizeFile.height16)),
                  const SizedBox(height: SizeFile.height10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            AssetImagePaths.wadeWarrenImage,
                            height: SizeFile.height50,
                            width: SizeFile.height50,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: SizeFile.height12,
                                  left: SizeFile.height12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text(StringConfig.wadeWarren,
                                          style: TextStyle(
                                              color: ColorFile.onBordingColor,
                                              fontFamily: satoshiMedium,
                                              fontWeight: FontWeight.w500,
                                              fontSize: SizeFile.height16)),
                                      Text(StringConfig.toDay,
                                          style: TextStyle(
                                              color: ColorFile.orContinue,
                                              fontFamily: satoshiRegular,
                                              fontWeight: FontWeight.w500,
                                              fontSize: SizeFile.height11)),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        AssetImagePaths.starYellow,
                                        height: SizeFile.height14,
                                        width: SizeFile.height14,
                                      ),
                                      const SizedBox(width: SizeFile.height4),
                                      Image.asset(
                                        AssetImagePaths.starYellow,
                                        height: SizeFile.height14,
                                        width: SizeFile.height14,
                                      ),
                                      const SizedBox(width: SizeFile.height4),
                                      Image.asset(
                                        AssetImagePaths.starYellow,
                                        height: SizeFile.height14,
                                        width: SizeFile.height14,
                                      ),
                                      const SizedBox(width: SizeFile.height4),
                                      Image.asset(
                                        AssetImagePaths.starYellow,
                                        height: SizeFile.height14,
                                        width: SizeFile.height14,
                                      ),
                                      const SizedBox(width: SizeFile.height4),
                                      Image.asset(
                                        AssetImagePaths.starIcon,
                                        height: SizeFile.height14,
                                        width: SizeFile.height14,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Text(StringConfig.goodHotelWorthEveryPenny,
                          style: TextStyle(
                              color: ColorFile.rangeColor,
                              fontFamily: satoshiMedium,
                              fontWeight: FontWeight.w400,
                              fontSize: SizeFile.height14)),
                      Container(
                        width: Get.width,
                        margin: const EdgeInsets.only(top: SizeFile.height10),
                        height: SizeFile.height1,
                        color: ColorFile.appColor.withValues(alpha: 0.15),
                      ),
                      const SizedBox(height: SizeFile.height10)
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            AssetImagePaths.ralphImage,
                            height: SizeFile.height50,
                            width: SizeFile.height50,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: SizeFile.height12,
                                  left: SizeFile.height12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text(StringConfig.ralphEdwards,
                                          style: TextStyle(
                                              color: ColorFile.onBordingColor,
                                              fontFamily: satoshiMedium,
                                              fontWeight: FontWeight.w500,
                                              fontSize: SizeFile.height16)),
                                      Text(StringConfig.toDay,
                                          style: TextStyle(
                                              color: ColorFile.orContinue,
                                              fontFamily: satoshiRegular,
                                              fontWeight: FontWeight.w500,
                                              fontSize: SizeFile.height11)),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        AssetImagePaths.starYellow,
                                        height: SizeFile.height14,
                                        width: SizeFile.height14,
                                      ),
                                      const SizedBox(width: SizeFile.height4),
                                      Image.asset(
                                        AssetImagePaths.starYellow,
                                        height: SizeFile.height14,
                                        width: SizeFile.height14,
                                      ),
                                      const SizedBox(width: SizeFile.height4),
                                      Image.asset(
                                        AssetImagePaths.starYellow,
                                        height: SizeFile.height14,
                                        width: SizeFile.height14,
                                      ),
                                      const SizedBox(width: SizeFile.height4),
                                      Image.asset(
                                        AssetImagePaths.starYellow,
                                        height: SizeFile.height14,
                                        width: SizeFile.height14,
                                      ),
                                      const SizedBox(width: SizeFile.height4),
                                      Image.asset(
                                        AssetImagePaths.starIcon,
                                        height: SizeFile.height14,
                                        width: SizeFile.height14,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Text(StringConfig.goodHotelWorthEveryPenny,
                          style: TextStyle(
                              color: ColorFile.rangeColor,
                              fontFamily: satoshiMedium,
                              fontWeight: FontWeight.w400,
                              fontSize: SizeFile.height14)),
                      Container(
                        width: Get.width,
                        margin: const EdgeInsets.only(top: SizeFile.height10),
                        height: SizeFile.height1,
                        color: ColorFile.appColor.withValues(alpha: 0.15),
                      ),
                      const SizedBox(height: SizeFile.height10)
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            AssetImagePaths.devonImage,
                            height: SizeFile.height50,
                            width: SizeFile.height50,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: SizeFile.height12,
                                  right: SizeFile.height12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text(StringConfig.devonLane,
                                          style: TextStyle(
                                              color: ColorFile.onBordingColor,
                                              fontFamily: satoshiMedium,
                                              fontWeight: FontWeight.w500,
                                              fontSize: SizeFile.height16)),
                                      Text(StringConfig.toDay,
                                          style: TextStyle(
                                              color: ColorFile.orContinue,
                                              fontFamily: satoshiRegular,
                                              fontWeight: FontWeight.w500,
                                              fontSize: SizeFile.height11)),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        AssetImagePaths.starYellow,
                                        height: SizeFile.height14,
                                        width: SizeFile.height14,
                                      ),
                                      const SizedBox(width: SizeFile.height4),
                                      Image.asset(
                                        AssetImagePaths.starYellow,
                                        height: SizeFile.height14,
                                        width: SizeFile.height14,
                                      ),
                                      const SizedBox(width: SizeFile.height4),
                                      Image.asset(
                                        AssetImagePaths.starYellow,
                                        height: SizeFile.height14,
                                        width: SizeFile.height14,
                                      ),
                                      const SizedBox(width: SizeFile.height4),
                                      Image.asset(
                                        AssetImagePaths.starYellow,
                                        height: SizeFile.height14,
                                        width: SizeFile.height14,
                                      ),
                                      const SizedBox(width: SizeFile.height4),
                                      Image.asset(
                                        AssetImagePaths.starIcon,
                                        height: SizeFile.height14,
                                        width: SizeFile.height14,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Text(StringConfig.goodHotelWorthEveryPenny,
                          style: TextStyle(
                              color: ColorFile.rangeColor,
                              fontFamily: satoshiMedium,
                              fontWeight: FontWeight.w400,
                              fontSize: SizeFile.height14)),
                      Container(
                        width: Get.width,
                        margin: const EdgeInsets.only(top: SizeFile.height10),
                        height: SizeFile.height1,
                        color: ColorFile.appColor.withValues(alpha: 0.15),
                      ),
                      const SizedBox(height: SizeFile.height10)
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(const RatingAndReviewScreen());
                    },
                    child: const Center(
                      child: Text(StringConfig.seeMore,
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              decorationColor: ColorFile.appColor,
                              color: ColorFile.appColor,
                              fontFamily: satoshiMedium,
                              fontWeight: FontWeight.w500,
                              fontSize: SizeFile.height16)),
                    ),
                  ),
                  const SizedBox(height: SizeFile.height20),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildHotelImageList() {
    return ListView.builder(
        itemCount: hotelImageList.length,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: hotelImageIndex == index
                    ? SizeFile.height20
                    : SizeFile.height26),
            child: Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () {
                  hotelImageIndex = index;
                  setState(() {});
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: SizeFile.height7),
                  child: Image.asset(hotelImageList[index],
                      height: hotelImageIndex == index
                          ? SizeFile.height54
                          : SizeFile.height42,
                      width: hotelImageIndex == index
                          ? SizeFile.height60
                          : SizeFile.height47),
                ),
              ),
            ),
          );
        });
  }
}
