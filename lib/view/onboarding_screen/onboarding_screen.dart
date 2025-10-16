import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prime_travel_flutter_ui_kit/util/asset_image_paths.dart';
import 'package:prime_travel_flutter_ui_kit/util/colors.dart';
import 'package:prime_travel_flutter_ui_kit/util/font_family.dart';
import 'package:prime_travel_flutter_ui_kit/util/size_config.dart';
import 'package:prime_travel_flutter_ui_kit/util/string_config.dart';
import '../../controller/on_bording_controller.dart';
import '../home_screen/home_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  final OnBoardingController onBoardingController =
      Get.put(OnBoardingController());
  final List<String> titlesList = [
    StringConfig.peopleDonTakeTripsTripsTakePeople,
    StringConfig.lifeSsShortAndTheWorldIsWide,
    StringConfig.getReadyForYourLifetimeJourney
  ];
  final List<String> descriptionsList = [
    StringConfig.toGetTheBestOfYourAdventure,
    StringConfig.toGetTheBestOfYouComfort,
    StringConfig.toGetTheBestOfYourBooking
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorFile.whiteColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
            right: SizeFile.height8,
            top: MediaQuery.of(context).size.height / 35),
        child: GestureDetector(
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
            );
          },
          child: Obx(
            () => Text(
                onBoardingController.pageViewIndex.value == 0 ||
                        onBoardingController.pageViewIndex.value == 1
                    ? StringConfig.skip
                    : "",
                style: TextStyle(
                    fontFamily: satoshiMedium,
                    color: ColorFile.appColor,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                    fontSize: SizeFile.height16)),
          ),
        ),
      ),
      body: Obx(() => Column(children: [
            SizedBox(
              height: Get.height * .90,
              child: PageView.builder(
                controller: _pageController,
                allowImplicitScrolling: true,
                onPageChanged: (value) {
                  onBoardingController.pageViewIndex.value = value;
                },
                itemCount: 3,
                itemBuilder: (context, index) {
                  index = onBoardingController.pageViewIndex.value;
                  return Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(children: [
                        Image.asset(
                          'assets/images/onboarding_image${index + 1}.png',
                          height: Get.height / 1.6,
                          fit: BoxFit.cover,
                        ),
                      ]),
                      const SizedBox(height: SizeFile.height32),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          titlesList[index],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontFamily: satoshiRegular,
                              fontSize: SizeFile.height24,
                              fontWeight: FontWeight.w500,
                              color: ColorFile.onBordingColor),
                        ),
                      ),
                      const SizedBox(height: SizeFile.height8),
                      Text(
                        descriptionsList[index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontFamily: satoshiRegular,
                            fontSize: SizeFile.height16,
                            fontWeight: FontWeight.w400,
                            color: ColorFile.onBording2Color),
                      ),
                    ],
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (int index) => buildDot(index: index),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    right: SizeFile.height20, left: SizeFile.height20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    onBoardingController.pageViewIndex.value == 0 ||
                            onBoardingController.pageViewIndex.value == 1
                        ? GestureDetector(
                            onTap: () {
                              onBoardingController.pageViewIndex.value += 1;
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(
                                  right: SizeFile.height6,
                                  left: SizeFile.height6),
                              child: Text(StringConfig.next,
                                  style: TextStyle(
                                      fontFamily: satoshiRegular,
                                      fontSize: SizeFile.height20,
                                      fontWeight: FontWeight.w500,
                                      color: ColorFile.nextButton)),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomeScreen()),
                                (route) => false,
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(
                                  right: SizeFile.height6,
                                  left: SizeFile.height6),
                              child: Text(StringConfig.getStarted,
                                  style: TextStyle(
                                      fontFamily: satoshiRegular,
                                      fontWeight: FontWeight.w500,
                                      fontSize: SizeFile.height20,
                                      color: ColorFile.nextButton)),
                            ),
                          ),
                    onBoardingController.pageViewIndex.value == 0 ||
                            onBoardingController.pageViewIndex.value == 1
                        ? GestureDetector(
                            onTap: () {
                              onBoardingController.pageViewIndex.value += 1;
                            },
                            child: CircleAvatar(
                                radius: SizeFile.height23,
                                backgroundColor: ColorFile.appColor,
                                child: Image.asset(AssetImagePaths.next,
                                    height: SizeFile.height13,
                                    width: SizeFile.height17)))
                        : GestureDetector(
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomeScreen()),
                                (route) => false,
                              );
                            },
                            child: CircleAvatar(
                                radius: SizeFile.height23,
                                backgroundColor: ColorFile.appColor,
                                child: Image.asset(AssetImagePaths.next,
                                    height: SizeFile.height13,
                                    width: SizeFile.height17)),
                          )
                  ],
                ),
              ),
            ),
            const SizedBox(height: SizeFile.height10)
          ])),
    );
  }

  Widget buildDot({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: SizeFile.height8),
      height: SizeFile.height7,
      width: SizeFile.height7,
      decoration: BoxDecoration(
        color: onBoardingController.pageViewIndex.value == index
            ? ColorFile.appColor
            : Colors.grey,
        borderRadius: BorderRadius.circular(SizeFile.height6),
      ),
    );
  }
}
