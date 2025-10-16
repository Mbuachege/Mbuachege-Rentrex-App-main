import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:prime_travel_flutter_ui_kit/View/profile/profile_screen.dart';
import 'package:prime_travel_flutter_ui_kit/controller/drawer_controller.dart';
import 'package:prime_travel_flutter_ui_kit/services/secure_store.dart';
import 'package:prime_travel_flutter_ui_kit/util/colors.dart';
import 'package:prime_travel_flutter_ui_kit/util/font_family.dart';
import 'package:prime_travel_flutter_ui_kit/util/size_config.dart';
import 'package:prime_travel_flutter_ui_kit/view/home_screen/home_screen.dart';
import 'package:prime_travel_flutter_ui_kit/view/login_screem/login_screen.dart';
import 'package:prime_travel_flutter_ui_kit/view/my_booking_screen/booking_screen.dart';
import '../../controller/login_controller.dart';
import '../../util/asset_image_paths.dart';
import '../../util/string_config.dart';
import '../settings_screen/settings_screen.dart';

class DrawerScreen extends StatelessWidget {
  final Function(int)? onItemTap; // <--- add this
  DrawerScreen({super.key, this.onItemTap});

  // Drawer items
  final List<Map<String, String>> drawerItems = const [
    {"title": StringConfig.home, "icon": AssetImagePaths.homeIcon},
    {"title": StringConfig.myBooking, "icon": AssetImagePaths.myBookingIcon},
    {"title": StringConfig.myProfile, "icon": AssetImagePaths.userRounded},
    {"title": StringConfig.settings, "icon": AssetImagePaths.settingsIcon},
  ];

  final DrawerListController drawerListController =
      Get.put(DrawerListController());
  final LoginController loginController = Get.put(LoginController());

  @override
  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final email = box.read('userEmail'); // <-- fetch from storage

    final isLoggedIn = email != null;

    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: SizeFile.height20,
            vertical: SizeFile.height20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: SizeFile.height40),

              // ✅ Profile section
              Row(
                children: [
                  ClipOval(
                    child: Image.asset(
                      AssetImagePaths.drawerProfileImage,
                      height: SizeFile.height60,
                      width: SizeFile.height60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome",
                          style: const TextStyle(
                            color: ColorFile.onBordingColor,
                            fontFamily: satoshiMedium,
                            fontSize: SizeFile.height14,
                          ),
                        ),
                        Text(
                          isLoggedIn ? email : "Guest",
                          style: const TextStyle(
                            color: ColorFile.appColor,
                            fontFamily: satoshiBold,
                            fontSize: SizeFile.height16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: SizeFile.height30),

              // Drawer menu list (unchanged)...
              Expanded(
                child: ListView.separated(
                  itemCount: drawerItems.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: SizeFile.height10),
                  itemBuilder: (context, index) {
                    return Obx(() {
                      final bool selected =
                          drawerListController.selectedDrawer.value == index;
                      return GestureDetector(
                        onTap: () => _onItemTap(index),
                        child: Container(
                          height: SizeFile.height40,
                          padding: const EdgeInsets.symmetric(
                              horizontal: SizeFile.height10),
                          decoration: BoxDecoration(
                            color: selected
                                ? ColorFile.appColor
                                : ColorFile.whiteColor,
                            borderRadius:
                                BorderRadius.circular(SizeFile.height5),
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                drawerItems[index]["icon"]!,
                                height: SizeFile.height20,
                                color: selected
                                    ? ColorFile.whiteColor
                                    : ColorFile.onBordingColor,
                              ),
                              const SizedBox(width: SizeFile.height18),
                              Text(
                                drawerItems[index]["title"]!,
                                style: TextStyle(
                                  fontSize: SizeFile.height18,
                                  fontFamily: satoshiRegular,
                                  fontWeight: FontWeight.w500,
                                  color: selected
                                      ? ColorFile.whiteColor
                                      : ColorFile.onBordingColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  },
                ),
              ),

              // ✅ Login / Logout button
              Padding(
                padding: const EdgeInsets.only(top: SizeFile.height20),
                child: GestureDetector(
                  onTap: () {
                    Get.back(); // close drawer
                    if (isLoggedIn) {
                      _showLogoutDialog(context);
                    } else {
                      Get.to(() => LoginScreen()); // navigate to login
                    }
                  },
                  child: Row(
                    children: [
                      Image.asset(AssetImagePaths.logoutIcon,
                          height: SizeFile.height22),
                      const SizedBox(width: SizeFile.height20),
                      Text(
                        isLoggedIn ? StringConfig.logOut : StringConfig.logIn,
                        style: const TextStyle(
                          fontSize: SizeFile.height16,
                          color: ColorFile.onBordingColor,
                          fontFamily: satoshiMedium,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onItemTap(int index) {
    drawerListController.selectedDrawer.value = index;

    if (index == 0) {
      Get.back();
      return;
    }
    if (onItemTap != null) {
      onItemTap!(index);
    }
    final routeMap = <int, Widget>{
      1: BookingScreen(isAppbar: false),
      2: ProfileScreen(isAppbar: false),
      3: SettingScreen(),
    };

    final page = routeMap[index];
    if (page != null) Get.to(page);
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Center(
            child: Text(
              StringConfig.logOut,
              style: TextStyle(
                color: ColorFile.logOutColor,
                fontFamily: satoshiBold,
                fontWeight: FontWeight.w700,
                fontSize: SizeFile.height18,
              ),
            ),
          ),
          content: const Text(
            StringConfig.areYouSureYouWantToLogOut,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ColorFile.onBordingColor,
              fontFamily: satoshiMedium,
              fontWeight: FontWeight.w500,
              fontSize: SizeFile.height14,
            ),
          ),
          backgroundColor: ColorFile.whiteColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(SizeFile.height28)),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(), // cancel
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                final box = GetStorage();
                await box.erase();
                await SecureStore.clear();

                Get.offAll(() => HomeScreen()); // reset navigation
              },
              child: const Text("Log Out"),
            ),
          ],
        );
      },
    );
  }
}
