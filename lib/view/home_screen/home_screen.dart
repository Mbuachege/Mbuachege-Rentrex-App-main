import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:prime_travel_flutter_ui_kit/util/asset_image_paths.dart';
import 'package:prime_travel_flutter_ui_kit/util/colors.dart';
import '../../controller/home_controller copy.dart';
import '../../util/font_family.dart';
import '../../util/size_config.dart';
import '../../util/string_config.dart';
import '../my_booking_screen/booking_screen.dart';
import '../profile/profile_screen.dart';
import '../upcoming_trip/info_support_screen.dart';
import 'drawer_screen.dart';
import 'home_page.dart';
import 'notification_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

String appBarTitle = "";
int bottomNavigationIndex = 0;
List<Widget> bottomPageList = <Widget>[
  const HomePage(),
  BookingScreen(isAppbar: true),
  InfoSupportScreen(isAppbar: true),
  ProfileScreen(isAppbar: true),
];

class _HomeScreenState extends State<HomeScreen> with RestorationMixin {
  final RestorableInt _bottomNavigationIndex = RestorableInt(0);
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  HomeControllerCopy homeController = Get.put(HomeControllerCopy());

  @override
  String? get restorationId => 'home_screen';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_bottomNavigationIndex, 'bottom_nav_index');
  }

  void onItemTapped(int index) {
    setState(() {
      _bottomNavigationIndex.value = index;
      homeController.appbarTitle.value = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorFile.whiteColor,
      key: _globalKey,
      appBar: _buildAppbar(),
      drawer: DrawerScreen(onItemTap: onItemTapped),
      body: bottomPageList[bottomNavigationIndex],
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
            top: Platform.isAndroid ? SizeFile.height80 : SizeFile.height100),
        child: PersistentTabView(
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.only(left: 0, right: 0),
          context,
          onItemSelected: onItemTapped,
          screens: bottomPageList,
          items: [
            PersistentBottomNavBarItem(
              activeColorPrimary: ColorFile.appColor,
              iconSize: SizeFile.height60,
              icon: Image.asset(
                  bottomNavigationIndex == 0
                      ? AssetImagePaths.bottomNavigationFeelIcon1
                      : AssetImagePaths.bottomNavigationIcon1,
                  height: SizeFile.height22,
                  width: SizeFile.height22),
              title: "Home",
            ),
            PersistentBottomNavBarItem(
              activeColorPrimary: ColorFile.appColor,
              icon: Image.asset(
                  bottomNavigationIndex == 1
                      ? AssetImagePaths.bottomNavigationFeelIcon2
                      : AssetImagePaths.bottomNavigationIcon2,
                  color: bottomNavigationIndex == 1
                      ? ColorFile.appColor
                      : ColorFile.orContinue,
                  height: SizeFile.height22,
                  width: SizeFile.height22),
              title: "History",
            ),
            PersistentBottomNavBarItem(
                activeColorPrimary: ColorFile.appColor,
                icon: Image.asset(
                    bottomNavigationIndex == 2
                        ? AssetImagePaths.bottomNavigationFeelIcon3
                        : AssetImagePaths.bottomNavigationIcon3,
                    color: bottomNavigationIndex == 2
                        ? ColorFile.appColor
                        : ColorFile.orContinue,
                    height: SizeFile.height26,
                    width: SizeFile.height26),
                title: "Profile"),
            PersistentBottomNavBarItem(
              activeColorPrimary: ColorFile.appColor,
              icon: Image.asset(
                  bottomNavigationIndex == 3
                      ? AssetImagePaths.bottomNavigationFeelIcon4
                      : AssetImagePaths.profileImage,
                  height: SizeFile.height24,
                  width: SizeFile.height24),
              title: "About us",
            )
          ],
          confineToSafeArea: true,
          backgroundColor: ColorFile.whiteColor,
          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset: true,
          stateManagement: true,
          hideNavigationBarWhenKeyboardAppears: true,
          navBarHeight: kBottomNavigationBarHeight,
          decoration: NavBarDecoration(
            colorBehindNavBar: ColorFile.whiteColor,
            boxShadow: [
              BoxShadow(
                color: ColorFile.emailBorderColor,
                offset: Offset(0, 0),
                spreadRadius: SizeFile.height2,
                blurRadius: SizeFile.height2,
              ),
            ],
          ),
          navBarStyle: NavBarStyle.style5,
        ),
      ),
    );
  }

  PreferredSize _buildAppbar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(SizeFile.height40),
      child: AppBar(
        backgroundColor: ColorFile.whiteColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: ColorFile.blackColor),
        title: Obx(
          () => Text(
            homeController.appbarTitle.value,
            style: const TextStyle(
              color: ColorFile.onBordingColor,
              fontFamily: satoshiBold,
              fontWeight: FontWeight.w400,
              fontSize: SizeFile.height22,
            ),
          ),
        ),
        leading: IconButton(
          padding: const EdgeInsets.only(left: SizeFile.height8),
          icon: const Icon(Icons.menu),
          onPressed: () {
            _globalKey.currentState!.openDrawer();
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: SizeFile.height8),
            child: IconButton(
              icon: Image.asset(
                AssetImagePaths.notificationIcon,
                height: SizeFile.height24,
                width: SizeFile.height24,
              ),
              onPressed: () {
                Get.to(const NotificationScreen());
              },
            ),
          ),
          if (bottomNavigationIndex == 3)
            Padding(
              padding: const EdgeInsets.only(right: SizeFile.height12),
              child: TextButton(
                onPressed: () {
                  // Get.to(EditScreen());
                },
                child: const Text(
                  StringConfig.edit,
                  style: TextStyle(
                    color: ColorFile.appColor,
                    fontFamily: satoshiMedium,
                    fontWeight: FontWeight.w500,
                    fontSize: SizeFile.height16,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _bottomNavigationIndex.dispose();
    super.dispose();
  }
}
