import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pay/pay.dart';
import 'package:prime_travel_flutter_ui_kit/services/notification_service.dart';
import 'package:prime_travel_flutter_ui_kit/services/secure_store.dart';
import 'package:prime_travel_flutter_ui_kit/view/payment_details/congratulation_screen.dart';
import '../../util/asset_image_paths.dart';
import '../../util/colors.dart';
import '../../util/size_config.dart';
import '../../util/string_config.dart';
import '../../util/font_family.dart';

class SelectYourPaymentScreen extends StatefulWidget {
  final double amount;
  final double discount;
  final double tax;
  final String email;
  final int bookingId;

  const SelectYourPaymentScreen({
    Key? key,
    required this.amount,
    required this.discount,
    required this.tax,
    required this.email,
    required this.bookingId,
  }) : super(key: key);

  @override
  State<SelectYourPaymentScreen> createState() =>
      _SelectYourPaymentScreenState();
}

class _SelectYourPaymentScreenState extends State<SelectYourPaymentScreen> {
  double get totalAmount => widget.amount - widget.discount + widget.tax;

  // Example: send token to backend for decryption & charging
  Future<bool> _sendToServer(String encryptedToken) async {
    const String apiUrl =
        "http://appvacation.digikatech.africa/api/payments/pay";
    final box = GetStorage();
    final email = box.read('userEmail');
    final jwtToken = await SecureStore.getToken();

    try {
      debugPrint("📡 Sending payment request...");
      debugPrint("➡ URL: $apiUrl");
      debugPrint("➡ Email: $email");
      debugPrint("➡ Booking ID: ${widget.bookingId}");
      debugPrint(
          "➡ JWT Token: ${jwtToken?.substring(0, 10)}..."); // print only first few chars for security

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $jwtToken",
        },
        body: jsonEncode({
          "amount": totalAmount,
          "currency": "usd",
          "paymentMethodToken": encryptedToken,
          "bookingId": widget.bookingId,
          "email": widget.email,
        }),
      );

      debugPrint("📥 Response Status: ${response.statusCode}");
      debugPrint("📥 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        debugPrint("✅ Payment Success!");
        return true;
      } else {
        debugPrint("❌ Payment Failed: ${response.statusCode}");
        return false;
      }
    } catch (e, stack) {
      debugPrint("🚨 Network error: $e");
      debugPrint("Stack Trace: $stack");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorFile.whiteColor,
      appBar: AppBar(
        backgroundColor: ColorFile.whiteColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          StringConfig.selectYourPayment,
          style: TextStyle(
            decorationColor: ColorFile.onBordingColor,
            color: ColorFile.onBordingColor,
            fontFamily: satoshiMedium,
            fontWeight: FontWeight.w500,
            fontSize: SizeFile.height22,
          ),
        ),
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Padding(
            padding: const EdgeInsets.only(
              left: SizeFile.height1,
              top: SizeFile.height20,
              bottom: SizeFile.height20,
            ),
            child: Image.asset(
              AssetImagePaths.backArrow2,
              height: SizeFile.height25,
              width: SizeFile.height45,
              color: ColorFile.onBordingColor,
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: SizeFile.height20),
        children: [
          const SizedBox(height: SizeFile.height10),

          // 1️⃣ Credit Card Preview
          Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              width: double.infinity,
              height: 180,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xFF4A148C), Color(0xFF6A1B9A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("BANK CARD",
                          style:
                              TextStyle(color: Colors.white70, fontSize: 14)),
                      Icon(Icons.credit_card, color: Colors.white70, size: 28),
                    ],
                  ),
                  Text(
                    "\$${totalAmount.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  Text(widget.email,
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 16)),
                  const Align(
                    alignment: Alignment.bottomRight,
                    child: Text("**** **** **** 1234",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 2️⃣ Label above Google Pay Button
          const Text(
            "Tap the button below to pay securely with Google Pay:",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),

          // 3️⃣ Google Pay Button inside Card
          Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                width: double.infinity,
                height: 70,
                child: FutureBuilder<PaymentConfiguration>(
                  future: PaymentConfiguration.fromAsset('gpay.json'),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return GooglePayButton(
                      paymentConfiguration: snapshot.data!,
                      paymentItems: [
                        PaymentItem(
                          label: "Total",
                          amount: totalAmount.toStringAsFixed(2),
                          status: PaymentItemStatus.final_price,
                        ),
                      ],
                      type: GooglePayButtonType.pay,
                      onPaymentResult: (result) async {
                        final token = result['paymentMethodData']
                            ?['tokenizationData']?['token'];
                        if (token != null) {
                          final tokenMap = jsonDecode(token);
                          final tokenId = tokenMap['id'];
                          final success = await _sendToServer(tokenId);
                          if (success) {
                            await NotificationService().fetchNotifications();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CongratulationScreen(
                                        unitName: "Payment Successful"),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text("Payment failed, please try again."),
                              ),
                            );
                          }
                        }
                      },
                      onError: (err) => debugPrint("Google Pay Error: $err"),
                      loadingIndicator:
                          const Center(child: CircularProgressIndicator()),
                    );
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 4️⃣ Summary Section (Amount, Discount, Tax, Total)
          Container(
            padding: const EdgeInsets.all(SizeFile.height16),
            decoration: BoxDecoration(
              color: ColorFile.whiteColor,
              borderRadius: BorderRadius.circular(SizeFile.height8),
              boxShadow: const [
                BoxShadow(
                  spreadRadius: 1,
                  color: ColorFile.border,
                  blurRadius: 1,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildSummaryRow("Amount", widget.amount),
                const SizedBox(height: SizeFile.height8),
                _buildSummaryRow("Discount", widget.discount),
                const SizedBox(height: SizeFile.height8),
                _buildSummaryRow("Tax", widget.tax),
                Divider(
                    color: ColorFile.appColor.withOpacity(0.15),
                    height: SizeFile.height16),
                _buildSummaryRow(
                  "Total",
                  totalAmount,
                  isTotal: true,
                  color: ColorFile.appColor,
                ),
              ],
            ),
          ),

          const SizedBox(height: SizeFile.height16),
        ],
      ),
    );
  }

  // Summary Row
  Widget _buildSummaryRow(
    String label,
    double value, {
    bool isTotal = false,
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: isTotal ? satoshiBold : satoshiRegular,
            fontSize: isTotal ? SizeFile.height16 : SizeFile.height14,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
            color: color ?? ColorFile.onBording2Color,
          ),
        ),
        Text(
          "\$${value.toStringAsFixed(2)}",
          style: TextStyle(
            fontFamily: isTotal ? satoshiBold : satoshiRegular,
            fontSize: isTotal ? SizeFile.height16 : SizeFile.height14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: color ?? ColorFile.onBordingColor,
          ),
        ),
      ],
    );
  }
}
