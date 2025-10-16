import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prime_travel_flutter_ui_kit/util/common_button.dart';
import '../../util/asset_image_paths.dart';
import '../../util/colors.dart';
import '../../util/font_family.dart';
import '../../util/size_config.dart';
import '../../util/string_config.dart';

class EditScreen extends StatefulWidget {
  final String name;
  final String email;
  final String phone;

  const EditScreen({
    Key? key,
    required this.name,
    required this.email,
    required this.phone,
  }) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    emailController = TextEditingController(text: widget.email);
    phoneController = TextEditingController(text: widget.phone);
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorFile.whiteColor,
      appBar: _buildAppbar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: SizeFile.height20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: SizeFile.height16),

            // 🔹 Name Field
            TextFormField(
              controller: nameController,
              decoration: _inputDecoration("Full Name"),
            ),
            const SizedBox(height: SizeFile.height16),

            // 🔹 Phone Field
            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: _inputDecoration("Phone Number"),
            ),
            const SizedBox(height: SizeFile.height16),

            // 🔹 Email Field
            TextFormField(
              controller: emailController,
              decoration: _inputDecoration("Email Address"),
            ),

            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: ShortButton(
                    buttonColor: ColorFile.appColor.withValues(alpha: 0.15),
                    textColor: ColorFile.onBordingColor,
                    text: StringConfig.cancel,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Save back or update storage if needed
                    Get.back(result: {
                      "name": nameController.text.trim(),
                      "email": emailController.text.trim(),
                      "phone": phoneController.text.trim(),
                    });
                  },
                  child: ShortButton(
                    buttonColor: ColorFile.appColor,
                    textColor: ColorFile.whiteColor,
                    text: StringConfig.saveDetails,
                  ),
                ),
              ],
            ),
            const SizedBox(height: SizeFile.height20),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      isDense: true,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: ColorFile.appColor),
        borderRadius: BorderRadius.circular(SizeFile.height8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorFile.appColor),
        borderRadius: BorderRadius.circular(SizeFile.height8),
      ),
      hintText: hint,
      hintStyle: const TextStyle(
        fontSize: SizeFile.height14,
        color: ColorFile.onBordingColor,
      ),
    );
  }

  AppBar _buildAppbar() {
    return AppBar(
      backgroundColor: ColorFile.whiteColor,
      elevation: 0,
      title: const Text(
        StringConfig.editProfile,
        style: TextStyle(
          color: ColorFile.onBordingColor,
          fontFamily: satoshiBold,
          fontWeight: FontWeight.w400,
          fontSize: SizeFile.height22,
        ),
      ),
      centerTitle: true,
      leading: GestureDetector(
        onTap: () => Get.back(),
        child: Padding(
          padding: const EdgeInsets.only(
            left: SizeFile.height15,
            top: SizeFile.height20,
            bottom: SizeFile.height20,
          ),
          child: Image.asset(
            AssetImagePaths.backArrow2,
            height: SizeFile.height10,
            width: SizeFile.height18,
            color: ColorFile.onBordingColor,
          ),
        ),
      ),
    );
  }
}
