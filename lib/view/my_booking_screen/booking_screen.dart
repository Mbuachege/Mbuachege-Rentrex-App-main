import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:prime_travel_flutter_ui_kit/View/my_booking_screen/my_booking_screen.dart';
import 'package:prime_travel_flutter_ui_kit/services/notification_service.dart';
import 'package:prime_travel_flutter_ui_kit/services/secure_store.dart';
import 'package:prime_travel_flutter_ui_kit/util/colors.dart';
import 'package:prime_travel_flutter_ui_kit/view/login_screem/login_screen.dart';
import '../../util/font_family.dart';
import '../../util/size_config.dart';

class BookingScreen extends StatefulWidget {
  BookingScreen({Key? key, this.isAppbar = true}) : super(key: key);
  bool isAppbar;
  @override
  State<BookingScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<BookingScreen> {
  bool isLoading = true;
  bool hasError = false;
  List<dynamic> bookings = [];

  @override
  void initState() {
    super.initState();
    _checkLoginBeforeFetching();
    fetchBookings();
    NotificationService().fetchNotifications();
  }

  void _checkLoginBeforeFetching() async {
    final box = GetStorage();
    final isLoggedIn = box.read('isLoggedIn') ?? false;

    if (!isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showLoginDialog();
      });
    } else {
      fetchBookings();
    }
  }

  Future<void> fetchBookings() async {
    try {
      final box = GetStorage();
      final email = box.read('userEmail');
      final token = await SecureStore.getToken();

      if (email == null || email.isEmpty || token == null || token.isEmpty) {
        setState(() {
          hasError = true;
          isLoading = false;
        });
        return;
      }

      final url = Uri.parse(
          "http://appvacation.digikatech.africa/api/bookings/ByGuest$email");

      final response = await http.get(
        url,
        headers: {
          "accept": "*/*",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          bookings = json.decode(response.body);
          print("bookings: ${response.body}");
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

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
                "Please log in to view your bookings.",
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
                              fetchBookings();
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
                        isLoading = false;
                        hasError = true;
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
      appBar: AppBar(
        automaticallyImplyLeading: true, // shows the back arrow
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
          "My Bookings",
          style: TextStyle(
            color: Colors.white,
            fontFamily: satoshiBold,
            fontWeight: FontWeight.w600,
            fontSize: SizeFile.height20,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
              ? const Center(
                  child: Text(
                    "Login required or failed to load bookings.",
                    style: TextStyle(fontSize: 16, color: Colors.redAccent),
                  ),
                )
              : bookings.isEmpty
                  ? const Center(
                      child: Text("No bookings found.",
                          style: TextStyle(
                              fontSize: 16, fontFamily: satoshiMedium)),
                    )
                  : RefreshIndicator(
                      onRefresh: fetchBookings, // reloads data
                      child: ListView.builder(
                        padding: const EdgeInsets.all(SizeFile.height16),
                        itemCount: bookings.length,
                        itemBuilder: (context, index) {
                          final booking = bookings[index];
                          return bookingCard(booking);
                        },
                      ),
                    ),
    );
  }

  Widget bookingCard(dynamic booking) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.only(bottom: SizeFile.height16),
      elevation: 6,
      shadowColor: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.all(SizeFile.height16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              booking["propertyName"] ?? "Unknown Property",
              style: const TextStyle(
                color: ColorFile.appColor,
                fontFamily: satoshiBold,
                fontSize: SizeFile.height18,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              booking["unitName"] ?? "Unit not specified",
              style: const TextStyle(
                color: Colors.black54,
                fontFamily: satoshiMedium,
                fontSize: SizeFile.height15,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoTile(
                    Icons.login, "Check-In", _formatDate(booking["checkIn"])),
                _infoTile(Icons.logout, "Check-Out",
                    _formatDate(booking["checkOut"])),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "💰 Total: \$${booking["totalPrice"] ?? 'N/A'}",
              style: const TextStyle(
                color: Colors.black87,
                fontFamily: satoshiBold,
                fontSize: SizeFile.height16,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  avatar: Icon(
                    _getStatusIcon(booking["status"]),
                    color: Colors.white,
                    size: 18,
                  ),
                  label: Text(
                    booking["status"] ?? "Pending",
                    style: const TextStyle(
                        color: Colors.white, fontFamily: satoshiMedium),
                  ),
                  backgroundColor: _getStatusColor(booking["status"]),
                ),
                Text(
                  "Payment: ${booking["payment"]}",
                  style: _infoTextStyle(),
                ),
              ],
            ),
            if ((booking["status"]?.toLowerCase() ?? "") == "pending") ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.redAccent),
                ),
                child: const Text(
                  "⚠️ Disclaimer: Payment must be completed within 5 minutes from the booking time, "
                  "otherwise your booking may be canceled. Please ensure you complete the payment promptly.",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 13,
                    fontFamily: satoshiMedium,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorFile.appColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BookingDetailsPage(booking: booking),
                    ),
                  );
                },
                icon: const Icon(Icons.info_outline, color: Colors.white),
                label: const Text(
                  "View Details",
                  style:
                      TextStyle(color: Colors.white, fontFamily: satoshiMedium),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: ColorFile.appColor, size: 18),
            const SizedBox(width: 4),
            Text(label,
                style: const TextStyle(
                    fontSize: 13,
                    fontFamily: satoshiMedium,
                    color: Colors.black54)),
          ],
        ),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                fontSize: 14, fontFamily: satoshiBold, color: Colors.black87)),
      ],
    );
  }

  TextStyle _infoTextStyle() {
    return const TextStyle(
      color: ColorFile.orContinue,
      fontFamily: satoshiRegular,
      fontSize: SizeFile.height14,
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "N/A";
    final cleanStr = dateStr.replaceAll('T-', '-');
    final date = DateTime.tryParse(cleanStr);
    if (date == null) return "N/A";
    return DateFormat('d MMM, h:mm a').format(date.toLocal());
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case "paid":
        return Colors.green;
      case "pending":
        return Colors.amber; // yellow
      case "completed":
      case "closed":
        return Colors.blue; // or Colors.grey if you prefer
      default:
        return Colors.orange; // fallback
    }
  }

  IconData _getStatusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case "paid":
        return Icons.check_circle;
      case "pending":
        return Icons.hourglass_bottom;
      case "completed":
      case "closed":
        return Icons.done_all;
      default:
        return Icons.info;
    }
  }
}
