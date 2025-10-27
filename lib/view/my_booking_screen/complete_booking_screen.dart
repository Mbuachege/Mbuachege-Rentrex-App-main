import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prime_travel_flutter_ui_kit/services/booking_api%20.dart';
import 'package:prime_travel_flutter_ui_kit/services/notification_service.dart';
import 'package:prime_travel_flutter_ui_kit/util/colors.dart';
import '../payment_details/select_your_payment_screen.dart';

class BookingPage extends StatefulWidget {
  final String unitName;
  final int guests;
  final double basePrice;
  final String location;
  final String unitId;

  const BookingPage({
    Key? key,
    required this.unitId,
    required this.unitName,
    required this.location,
    required this.guests,
    required this.basePrice,
  }) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  late DateTime checkIn;
  late DateTime checkOut;

  @override
  void initState() {
    super.initState();
    checkIn = DateTime.now();
    checkOut = checkIn.add(const Duration(hours: 1)); // Only 1 hour stay
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking Summary"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            // ===== Property Card =====
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.unitName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            color: ColorFile.appColor, size: 20),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            widget.location,
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.people,
                            color: ColorFile.appColor, size: 20),
                        const SizedBox(width: 6),
                        Text("${widget.guests} Guest(s)",
                            style: const TextStyle(color: Colors.black54)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ===== Check-in and Check-out Section =====
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _modernTimeBox(
                  title: "Check-In",
                  icon: Icons.login,
                  date: checkIn,
                  color1: ColorFile.appColor,
                  color2: ColorFile.appColor,
                ),
                _modernTimeBox(
                  title: "Check-Out",
                  icon: Icons.logout,
                  date: checkOut,
                  color1: const Color.fromARGB(255, 254, 2, 2),
                  color2: Colors.orange.shade300,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ===== Price and Disclaimer =====
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total Price:",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "\$${widget.basePrice.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: ColorFile.appColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 6),
                    const Text(
                      "⚠️ All bookings must be paid within 5 minutes after confirming, otherwise your reservation will be cancelled automatically.",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.redAccent,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // ===== Confirm & Pay Button =====
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                backgroundColor: ColorFile.appColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                final box = GetStorage();
                final userEmail = box.read('userEmail') ?? 'guest@example.com';

                final bookingData = {
                  'unitId': int.parse(widget.unitId),
                  'guestEmail': userEmail,
                  'checkIn': checkIn.toIso8601String(),
                  'checkOut': checkOut.toIso8601String(),
                  'totalPrice': widget.basePrice,
                };

                try {
                  final bookingApi = BookingApi();
                  final bookingResponse = await bookingApi.saveBooking(
                    unitId: bookingData['unitId'] as int,
                    guestEmail: bookingData['guestEmail'] as String,
                    checkIn: checkIn,
                    checkOut: checkOut,
                    totalPrice: widget.basePrice,
                  );

                  final bookingId = bookingResponse['bookingId'];
                  await NotificationService().fetchNotifications();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectYourPaymentScreen(
                        amount: widget.basePrice,
                        discount: 0,
                        tax: 0,
                        email: userEmail,
                        bookingId: bookingId,
                      ),
                    ),
                  );
                } catch (e) {
                  Get.snackbar(
                    'Booking Failed',
                    e.toString(),
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
              child: Text(
                "Confirm & Pay \$${widget.basePrice.toStringAsFixed(2)}",
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _modernTimeBox({
    required String title,
    required IconData icon,
    required DateTime date,
    required Color color1,
    required Color color2,
  }) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          colors: [color1, color2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: color2.withOpacity(0.4),
            blurRadius: 6,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 26),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}  |  ${date.toLocal().toString().split(' ')[0]}",
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
