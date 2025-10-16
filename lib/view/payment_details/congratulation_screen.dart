import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prime_travel_flutter_ui_kit/controller/home_controller%20copy.dart';
import 'package:prime_travel_flutter_ui_kit/services/booking_api%20.dart';
import 'package:prime_travel_flutter_ui_kit/util/asset_image_paths.dart';
import 'package:prime_travel_flutter_ui_kit/util/colors.dart';
import 'package:prime_travel_flutter_ui_kit/util/size_config.dart';
import 'package:prime_travel_flutter_ui_kit/util/string_config.dart';
import 'package:prime_travel_flutter_ui_kit/view/my_booking_screen/UnlockAccessScreen%20.dart';
import 'package:prime_travel_flutter_ui_kit/view/my_booking_screen/booking_screen.dart';
import '../../util/common_button.dart';
import '../../util/font_family.dart';
import '../home_screen/home_screen.dart';
// import '../my_booking_screen/my_bookings_screen.dart'; // ✅ Uncomment if you have MyBookingsScreen

class CongratulationScreen extends StatefulWidget {
  final String unitName;
  const CongratulationScreen({Key? key, required this.unitName})
      : super(key: key);

  @override
  State<CongratulationScreen> createState() => _CongratulationScreenState();
}

class _CongratulationScreenState extends State<CongratulationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorFile.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: SizeFile.height20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: Get.height / 10.5),

              // 🎉 Image
              Image.asset(
                AssetImagePaths.congratulationIcon,
                height: SizeFile.height189,
              ),
              const SizedBox(height: SizeFile.height40),

              // 🎉 Message
              Text(
                "${StringConfig.congratulation}\n ${widget.unitName} ${StringConfig.bookingCongratulation}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  decorationColor: ColorFile.onBordingColor,
                  color: ColorFile.onBordingColor,
                  fontFamily: satoshiMedium,
                  fontWeight: FontWeight.w500,
                  fontSize: SizeFile.height18,
                ),
              ),

              const Spacer(),

              // 🔑 Unlock button
              GestureDetector(
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const UnlockAccessScreen(),
                    ),
                  );
                },
                child: ButtonCommon(
                  text: StringConfig.unlock,
                  buttonColor: ColorFile.appColor,
                  textColor: ColorFile.whiteColor,
                ),
              ),

              const SizedBox(height: 12),

              // 🏠 Home + 📖 My Bookings buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.home_outlined),
                      label: const Text('Home'),
                      onPressed: () {
                        Get.delete<
                            HomeControllerCopy>(); // clear old controller
                        Get.put(
                            HomeControllerCopy()); // reinitialize controller
                        Get.offAll(() => const HomeScreen());
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ColorFile.onBordingColor,
                        side: BorderSide(color: ColorFile.borderColor),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.book_online_outlined),
                      label: const Text('My Bookings'),
                      onPressed: () {
                        // Option 1: direct navigation if screen exists
                        Get.to(() => BookingScreen(isAppbar: false));

                        // Option 2: named route
                        // Get.toNamed('/bookings');
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ColorFile.onBordingColor,
                        side: BorderSide(color: ColorFile.borderColor),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: SizeFile.height20),
            ],
          ),
        ),
      ),
    );
  }
}
