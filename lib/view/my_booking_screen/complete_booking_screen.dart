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
  final DateTime checkIn;
  final DateTime checkOut;
  final double basePrice; // Price for default stay
  final String location; // Location of the unit
  final String unitId; // Unit ID

  const BookingPage({
    Key? key,
    required this.unitId,
    required this.unitName,
    required this.location,
    required this.guests,
    required this.checkIn,
    required this.checkOut,
    required this.basePrice,
  }) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  int extraDays = 0;

  DateTime get finalCheckOut => widget.checkOut.add(Duration(days: extraDays));

  double get totalPrice => widget.basePrice + (extraDays * 50);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking Summary"),
        backgroundColor: const Color.fromARGB(255, 247, 248, 247),
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ===== Booking Summary Card =====
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300, width: 1),
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
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.person, color: ColorFile.appColor),
                        const SizedBox(width: 8),
                        Text("${widget.guests} Guests"),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: ColorFile.appColor,
                        ),
                        const SizedBox(width: 8),
                        Text(widget.location),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: ColorFile.appColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Check-In: ${widget.checkIn.toLocal().toString().split(' ')[0]}",
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: ColorFile.appColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Check-Out: ${finalCheckOut.toLocal().toString().split(' ')[0]}",
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Divider(color: Colors.grey.shade300),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total Price:",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "\$${totalPrice.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: ColorFile.appColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ===== Optional Extra Days Section =====
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      "Add Extra Days (Optional)",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            if (extraDays > 0) {
                              setState(() {
                                extraDays--;
                              });
                            }
                          },
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "$extraDays",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          icon: const Icon(
                            Icons.add_circle_outline,
                            color: ColorFile.appColor,
                          ),
                          onPressed: () {
                            setState(() {
                              extraDays++;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Each extra day adds \$50 to your total.",
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Your check-out date will update automatically.",
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ===== Confirm & Pay Button =====
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: ColorFile.appColor,
              ),
              onPressed: () async {
                final box = GetStorage();
                final userEmail = box.read('userEmail') ?? 'guest@example.com';

                // Prepare the booking data
                final bookingData = {
                  'unitId': int.parse(widget.unitId),
                  'guestEmail': userEmail,
                  'checkIn': widget.checkIn.toIso8601String(),
                  'checkOut': finalCheckOut.toIso8601String(),
                  'totalPrice': totalPrice,
                };

                // Log the booking data to console
                print("Booking Data to send: $bookingData");

                try {
                  // Call the booking API with token
                  final bookingApi = BookingApi();
                  final bookingResponse = await bookingApi.saveBooking(
                    unitId: bookingData['unitId'] as int,
                    guestEmail: bookingData['guestEmail'] as String,
                    checkIn: widget.checkIn,
                    checkOut: finalCheckOut,
                    totalPrice: totalPrice,
                  );

                  final bookingId = bookingResponse['bookingId'];
                  await NotificationService().fetchNotifications();
                  // Navigate to Payment Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectYourPaymentScreen(
                        amount: totalPrice,
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
                "Confirm & Pay \$${totalPrice.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
