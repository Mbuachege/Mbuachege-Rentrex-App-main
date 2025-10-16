import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:prime_travel_flutter_ui_kit/services/secure_store.dart';
import 'package:prime_travel_flutter_ui_kit/view/my_booking_screen/UnlockAccessScreen%20.dart';
import 'package:prime_travel_flutter_ui_kit/view/payment_details/select_your_payment_screen.dart';
import '../../util/colors.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BookingDetailsPage extends StatelessWidget {
  final Map<String, dynamic> booking;
  const BookingDetailsPage({Key? key, required this.booking}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final status = (booking["status"] ?? "").toString().toLowerCase();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [ColorFile.appColor, ColorFile.appColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        title: const Text(
          "Booking Details",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _headerCard(),
              const SizedBox(height: 20),
              _detailsCard(),
              const SizedBox(height: 30),
              Column(children: _buildActionButtons(context, status, booking)),
            ],
          ),
        ),
      ),
    );
  }

  /// ============ HEADER ===============
  Widget _headerCard() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              booking["propertyName"] ?? "Property",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              booking["address"] ?? "",
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _statusChip(booking["status"] ?? "Unknown"),
                Text(
                  "\$${booking["totalPrice"] ?? "0"}",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// ============ BOOKING DETAILS ===============
  Widget _detailsCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _detailRow(Icons.confirmation_number, "Booking ID",
                booking["id"]?.toString() ?? "-"),
            _detailRow(Icons.meeting_room, "Unit", booking["unitName"] ?? "-"),
            _detailRow(
              Icons.calendar_today,
              "Check-In",
              _formatDate(booking["checkIn"]),
            ),
            _detailRow(
              Icons.calendar_month,
              "Check-Out",
              _formatDate(booking["checkOut"]),
            ),
            _detailRow(Icons.payment, "Payment", booking["payment"] ?? "-"),
          ],
        ),
      ),
    );
  }

  /// ============ ACTION BUTTONS ===============
  List<Widget> _buildActionButtons(
      BuildContext context, String status, Map<String, dynamic> booking) {
    switch (status) {
      case "paid":
        return [
          _actionButton(
            context,
            icon: Icons.vpn_key,
            color: Colors.orange,
            text: "View Unlock Code",
            onConfirm: () => _regenerateCode(context, booking["id"].toString()),
            dialogTitle: "Unlock Code",
            dialogMessage: "Continue to unlock code?",
          ),
          const SizedBox(height: 12),
          _actionButton(
            context,
            icon: Icons.cancel,
            color: Colors.redAccent,
            text: "Cancel / Refund",
            onConfirm: () => _cancelBooking(context, booking["id"]),
            dialogTitle: "Cancel Booking",
            dialogMessage: "Cancel and request a refund?",
          ),
        ];

      case "pending":
        return [
          _actionButton(
            context,
            icon: Icons.payment,
            color: Colors.green,
            text: "Complete Payment",
            onConfirm: () => _navigateToPayment(context, booking),
            dialogTitle: "Complete Payment",
            dialogMessage: "Proceed to payment page?",
          ),
          const SizedBox(height: 12),
          _actionButton(
            context,
            icon: Icons.cancel,
            color: Colors.redAccent,
            text: "Cancel Booking",
            onConfirm: () => _cancelBooking(context, booking["id"]),
            dialogTitle: "Cancel Booking",
            dialogMessage: "Are you sure you want to cancel?",
          ),
        ];

      case "completed":
      case "cancelled":
        return [
          _actionButton(
            context,
            icon: Icons.reviews,
            color: Colors.blueAccent,
            text: "Rate & Review",
            onConfirm: () => _showRatingDialog(context),
            dialogTitle: "Rate Your Stay",
            dialogMessage: "Would you like to leave a review?",
          ),
        ];
      default:
        return [];
    }
  }

  /// ============ CANCEL BOOKING ===============
  void _cancelBooking(BuildContext context, int bookingId) async {
    final token = await SecureStore.getToken();
    String reason = await _showReasonDialog(context);

    final url = Uri.parse(
        "http://appvacation.digikatech.africa/api/bookings/cancel-booking"
        "?bookingId=$bookingId&reason=${Uri.encodeComponent(reason)}");

    final headers = {
      "Authorization": "Bearer $token",
      "accept": "application/json",
    };

    try {
      final response = await http.post(url, headers: headers);
      final result = jsonDecode(response.body);

      if (response.statusCode == 200 && result["code"] == 1) {
        // ignore: use_build_context_synchronously
        _showSuccessDialog(context, "Booking cancelled successfully!");
      } else {
        _showErrorDialog(context, result["message"] ?? "Cancellation failed.");
      }
    } catch (e) {
      _showErrorDialog(context, "Error: $e");
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "-";
    final date = DateTime.tryParse(dateStr);
    if (date == null) return "-";
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }

  /// ============ RATING DIALOG ===============
  /// Submit Rating API
  Future<void> _submitRating(
      BuildContext context, double rating, String comment) async {
    final token = await SecureStore.getToken();
    if (!context.mounted) return;

    final url = Uri.parse(
        "http://appvacation.digikatech.africa/api/properties/save_ratings");
    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
      "accept": "*/*",
    };

    final body = jsonEncode({
      "bookingId": booking["id"] ?? 0,
      "guestId": booking["guestId"] ?? 0,
      "unitId": booking["unitId"] ?? 0,
      "stars": rating.round(),
      "comment": comment.isNotEmpty ? comment : "",
    });
    print("tttt $body");
    try {
      final response = await http.post(url, headers: headers, body: body);
      final result = jsonDecode(response.body);

      if (response.statusCode == 200 && result["code"] == 1) {
        _showSuccessDialog(context, "Thanks for rating! ⭐ $rating");
      } else {
        _showErrorDialog(
            context, result["message"] ?? "Failed to submit rating");
      }
    } catch (e) {
      _showErrorDialog(context, "Error: $e");
    }
  }

  /// ============ HELPERS ===============
  Widget _detailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        Icon(icon, color: ColorFile.appColor),
        const SizedBox(width: 12),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            Text(value,
                style: const TextStyle(fontSize: 14, color: Colors.black87)),
          ]),
        )
      ]),
    );
  }

  Widget _statusChip(String status) {
    Color chipColor;
    switch (status.toLowerCase()) {
      case "paid":
        chipColor = Colors.green;
        break;
      case "pending":
        chipColor = Colors.orange;
        break;
      case "completed":
        chipColor = Colors.blue;
        break;
      case "cancelled":
        chipColor = Colors.red;
        break;
      default:
        chipColor = Colors.black54;
    }
    return Chip(
        label: Text(status, style: const TextStyle(color: Colors.white)),
        backgroundColor: chipColor);
  }

  Widget _actionButton(BuildContext context,
      {required IconData icon,
      required Color color,
      required String text,
      required VoidCallback onConfirm,
      required String dialogTitle,
      required String dialogMessage}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 14)),
        icon: Icon(icon, color: Colors.white),
        label: Text(text,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15)),
        onPressed: () =>
            _showConfirmDialog(context, dialogTitle, dialogMessage, onConfirm),
      ),
    );
  }

  void _navigateToPayment(BuildContext context, Map<String, dynamic> booking) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectYourPaymentScreen(
          amount: booking["totalPrice"],
          discount: 0,
          tax: 0,
          email: booking["guestEmail"],
          bookingId: booking["id"],
        ),
      ),
    );
  }

  Future<String> _showReasonDialog(BuildContext context) async {
    TextEditingController reasonController = TextEditingController();
    String reason = "";
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("Cancel Booking"),
        content: TextField(
          controller: reasonController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: "Enter reason (optional)",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("Skip")),
          ElevatedButton(
              onPressed: () {
                reason = reasonController.text.trim();
                Navigator.of(ctx).pop();
              },
              style:
                  ElevatedButton.styleFrom(backgroundColor: ColorFile.appColor),
              child:
                  const Text("Submit", style: TextStyle(color: Colors.white))),
        ],
      ),
    );
    return reason;
  }

  void _showRatingDialog(BuildContext context) {
    double rating = 0.0;
    TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Rate Your Stay",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                RatingBar.builder(
                  initialRating: 0,
                  minRating: 1,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) =>
                      const Icon(Icons.star, color: Colors.amber),
                  onRatingUpdate: (value) => rating = value,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: commentController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Leave a comment...",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () async {
                        Navigator.pop(dialogContext); // close dialog first
                        await _submitRating(
                          context,
                          rating,
                          commentController.text.isNotEmpty
                              ? commentController.text
                              : "",
                        );
                      },
                      child: const Text("Submit"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showConfirmDialog(BuildContext context, String title, String message,
      VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("No", style: TextStyle(color: Colors.grey))),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                onConfirm();
              },
              style:
                  ElevatedButton.styleFrom(backgroundColor: ColorFile.appColor),
              child: const Text("Yes", style: TextStyle(color: Colors.white))),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Icon(Icons.check_circle, color: Colors.green, size: 60),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () =>
                  Navigator.pop(dialogContext), // ✅ use dialogContext
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "OK",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Icon(Icons.error, color: Colors.red, size: 60),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () =>
                  Navigator.pop(dialogContext), // ✅ use dialogContext
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("OK", style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }

  void _regenerateCode(BuildContext context, String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const UnlockAccessScreen(),
      ),
    );
  }
}
