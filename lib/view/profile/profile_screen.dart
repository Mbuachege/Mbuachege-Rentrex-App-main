import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prime_travel_flutter_ui_kit/util/asset_image_paths.dart';
import 'package:prime_travel_flutter_ui_kit/util/colors.dart';
import 'package:prime_travel_flutter_ui_kit/util/size_config.dart';
import 'package:prime_travel_flutter_ui_kit/view/login_screem/login_screen.dart';
import '../../util/font_family.dart';
import '../../util/string_config.dart';
import 'edit_screen.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key, this.isAppbar = false}) : super(key: key);
  bool isAppbar;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? image;

  // ✅ user data
  String? userName;
  String? userEmail;
  String? userPhone;
  String? userDob;

  @override
  void initState() {
    super.initState();
    _checkLoginBeforeLoading();
  }

  /// ✅ Check login before loading profile
  void _checkLoginBeforeLoading() {
    final box = GetStorage();
    final isLoggedIn = box.read('isLoggedIn') ?? false;

    if (!isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showLoginDialog();
      });
    } else {
      loadUserData();
    }
  }

  void loadUserData() {
    final box = GetStorage();
    setState(() {
      userName = box.read('userName') ?? "Unknown User";
      userEmail = box.read('userEmail') ?? "No email";
      userPhone = box.read('mobileno') ?? "+000000000";
    });
  }

  /// 🔑 Show login dialog
  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        elevation: 5,
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.account_circle_outlined,
                      color: Colors.blueAccent, size: 40),
                  SizedBox(width: 8),
                  Text("Login Required",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent)),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                "Please log in to view your profile.",
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(
                            popOnSuccess: () {
                              Navigator.pop(context, true);
                              loadUserData();
                            },
                          ),
                        ),
                      );
                    },
                    child: const Text("Login",
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.blueAccent),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        userName = "Unknown User";
                        userEmail = "No email";
                        userPhone = "Not provided";
                      });
                    },
                    child: const Text("Cancel",
                        style:
                            TextStyle(fontSize: 16, color: Colors.blueAccent)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorFile.whiteColor,
      appBar: widget.isAppbar
          ? null
          : AppBar(
              backgroundColor: ColorFile.redColor,
              centerTitle: true,
              title: Text(StringConfig.profile,
                  style: const TextStyle(
                      color: ColorFile.onBordingColor,
                      fontFamily: satoshiBold,
                      fontWeight: FontWeight.w400,
                      fontSize: SizeFile.height22)),
              leading: GestureDetector(
                onTap: () => Get.back(),
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
                ),
              ),
              elevation: 0,
              actions: [
                GestureDetector(
                  onTap: () {
                    final box = GetStorage();
                    final name = box.read('userName') ?? "";
                    final email = box.read('userEmail') ?? "";
                    final phone = box.read('userPhone') ?? "";

                    Get.to(() => EditScreen(
                          name: name,
                          email: email,
                          phone: phone,
                        ));
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(
                        right: SizeFile.height40, left: SizeFile.height20),
                    child: Text(StringConfig.edit,
                        style: TextStyle(
                            color: ColorFile.appColor,
                            fontFamily: satoshiMedium,
                            fontWeight: FontWeight.w500,
                            fontSize: SizeFile.height16)),
                  ),
                )
              ],
            ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: SizeFile.height20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: SizeFile.height20),
            // ✅ Profile Image
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  ClipOval(
                    child: image != null
                        ? Image.file(
                            image!,
                            height: SizeFile.height126,
                            width: SizeFile.height126,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            AssetImagePaths.profileImage,
                            height: SizeFile.height126,
                            width: SizeFile.height126,
                            fit: BoxFit.cover,
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: SizeFile.height15),
                    child: GestureDetector(
                      onTap: pickImageC,
                      child: Image.asset(
                        AssetImagePaths.plusIcon,
                        height: SizeFile.height24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SizeFile.height20),
            profileRow(
              icon: AssetImagePaths.userIcon,
              label: StringConfig.name,
              value: userName ?? "Unknown User",
            ),
            divider(),
            profileRow(
              icon: AssetImagePaths.phoneNumberIcon,
              label: StringConfig.phoneNumber,
              value: userPhone ?? "Not provided",
            ),
            divider(),
            profileRow(
              icon: AssetImagePaths.emailIcon,
              label: StringConfig.emailId,
              value: userEmail ?? "No email",
            ),
            divider(),
          ],
        ),
      ),
    );
  }

  Widget profileRow(
      {required String icon, required String label, required String value}) {
    return Row(
      children: [
        Image.asset(icon,
            color: ColorFile.appColor,
            height: SizeFile.height16,
            width: SizeFile.height16),
        const SizedBox(width: SizeFile.height12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: SizeFile.height18),
                child: Text(label,
                    style: const TextStyle(
                        color: ColorFile.onBordingColor,
                        fontFamily: satoshiRegular,
                        fontWeight: FontWeight.w400,
                        fontSize: SizeFile.height18)),
              ),
              Text(value,
                  style: const TextStyle(
                      color: ColorFile.orContinue,
                      fontFamily: satoshiRegular,
                      fontWeight: FontWeight.w400,
                      fontSize: SizeFile.height14)),
            ],
          ),
        ),
      ],
    );
  }

  Widget divider() => Container(
        width: Get.width,
        height: SizeFile.height1,
        color: ColorFile.verticalDividerColor,
        margin: const EdgeInsets.symmetric(vertical: SizeFile.height20),
      );

  Future pickImageC() async {
    try {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked == null) return;
      setState(() => image = File(picked.path));
    } on PlatformException catch (e) {
      log('Failed to pick image: $e');
    }
  }
}
