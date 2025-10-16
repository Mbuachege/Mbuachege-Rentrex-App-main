import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prime_travel_flutter_ui_kit/util/colors.dart';
import 'package:prime_travel_flutter_ui_kit/util/font_family.dart';
import 'package:prime_travel_flutter_ui_kit/util/size_config.dart';

class InfoSupportScreen extends StatelessWidget {
  const InfoSupportScreen({Key? key, required bool isAppbar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 236, 236),
      appBar: AppBar(
        backgroundColor: ColorFile.appColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Support & Info",
          style: TextStyle(
            color: Color.fromRGBO(255, 252, 252, 1),
            fontFamily: satoshiBold,
            fontWeight: FontWeight.w500,
            fontSize: SizeFile.height20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color.fromARGB(255, 255, 255, 255)),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(SizeFile.height16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 About Us Section
            sectionHeader("About Us"),
            cardBox("Welcome to RentRestX\n\n"
                "We connect travelers with unique vacation rentals and experiences. "
                "Our mission is to make your journey seamless, from booking to check-in, "
                "with safe and secure payment options, verified listings, and instant confirmations."),

            const SizedBox(height: SizeFile.height20),

            // 🔹 Rules & Guidelines
            sectionHeader("Rules & Guidelines"),
            cardBox("✅ Please respect property rules during your stay.\n\n"
                "✅ Cancellations must follow the property’s cancellation policy.\n\n"
                "✅ Report any issues through the Support tab for quick resolution.\n\n"
                "✅ Keep your account secure; do not share your login details.\n\n"
                "✅ Ensure payments are completed only via the app to stay protected."),

            const SizedBox(height: SizeFile.height20),

            // 🔹 Support / Help Center
            sectionHeader("Help Center & Support"),
            cardBox("📞 Customer Support: +254 700 123 456\n\n"
                "📧 Email: support@rentrestx.com\n\n"
                "💬 Live Chat: Available in the app (24/7)\n\n"
                "❓ Frequently Asked Questions:\n"
                "- How do I cancel a booking?\n"
                "- How do I request a refund?\n"
                "- What should I do if I have issues at check-in?\n\n"
                "Our team is here to make sure your journey is stress-free!"),

            const SizedBox(height: SizeFile.height20),

            // 🔹 Extra Section
            sectionHeader("More Information"),
            cardBox(
                "🔒 Security: We use encrypted transactions to protect your data.\n\n"
                "💡 Tip: Save your favorite properties to your wishlist for quick access.\n\n"
                "🌟 Feedback: We love hearing from you. Rate your stay to help us improve."),

            const SizedBox(height: SizeFile.height40),
          ],
        ),
      ),
    );
  }

  // 🔹 Section Header
  Widget sectionHeader(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: ColorFile.appColor,
        fontFamily: satoshiBold,
        fontSize: SizeFile.height20,
      ),
    );
  }

  // 🔹 Reusable Card Box
  Widget cardBox(String content) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: SizeFile.height10),
      padding: const EdgeInsets.all(SizeFile.height16),
      decoration: BoxDecoration(
        color: ColorFile.whiteColor,
        borderRadius: BorderRadius.circular(SizeFile.height12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 6,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        content,
        style: const TextStyle(
          color: ColorFile.onBordingColor,
          fontFamily: satoshiRegular,
          fontSize: SizeFile.height14,
        ),
      ),
    );
  }
}
