import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prime_travel_flutter_ui_kit/services/booking_api%20.dart';
import 'package:prime_travel_flutter_ui_kit/services/notification_service.dart';
import 'package:prime_travel_flutter_ui_kit/util/colors.dart';
import '../payment_details/select_your_payment_screen.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

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
  final _checkInController = TextEditingController();
  final _checkOutController = TextEditingController();

  bool _isProcessing = false;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  String formattedCheckIn = '';
  String formattedCheckOut = '';
  late tz.Location nyLocation;

  @override
  void initState() {
    super.initState();
    tzdata.initializeTimeZones();
    nyLocation = tz.getLocation('America/New_York');

    final now = tz.TZDateTime.now(nyLocation);
    final roundedStart = now.minute > 0
        ? tz.TZDateTime(nyLocation, now.year, now.month, now.day, now.hour + 1)
        : tz.TZDateTime(nyLocation, now.year, now.month, now.day, now.hour);

    final end = roundedStart.add(const Duration(hours: 1));
    final midnight = tz.TZDateTime(nyLocation, roundedStart.year,
        roundedStart.month, roundedStart.day + 1);

    selectedStartDate = roundedStart;
    selectedEndDate = end.isBefore(midnight) ? end : midnight;

    updateFormattedDates();
  }

  void updateFormattedDates() {
    final checkIn = selectedStartDate!;
    final checkOut = selectedEndDate!;

    final offsetHours = checkIn.timeZoneOffset.inHours;
    final offsetMinutes = checkIn.timeZoneOffset.inMinutes.remainder(60);
    final offsetSign = offsetHours >= 0 ? '+' : '-';
    final formattedOffset =
        '$offsetSign${offsetHours.abs().toString().padLeft(2, '0')}:${offsetMinutes.abs().toString().padLeft(2, '0')}';

    formattedCheckIn =
        "${checkIn.year}-${checkIn.month.toString().padLeft(2, '0')}-${checkIn.day.toString().padLeft(2, '0')}T${checkIn.hour.toString().padLeft(2, '0')}:00:00$formattedOffset";
    formattedCheckOut =
        "${checkOut.year}-${checkOut.month.toString().padLeft(2, '0')}-${checkOut.day.toString().padLeft(2, '0')}T${checkOut.hour.toString().padLeft(2, '0')}:00:00$formattedOffset";

    _checkInController.text = "${checkIn.hour.toString().padLeft(2, '0')}:00";
    _checkOutController.text = "${checkOut.hour.toString().padLeft(2, '0')}:00";

    setState(() {});
  }

  Future<void> pickCheckInHour() async {
    final now = tz.TZDateTime.now(nyLocation);
    final currentHour = now.hour;

    // Only allow hours from current hour onwards
    final hours =
        List.generate(24 - currentHour, (index) => currentHour + index);

    int? selectedHour = await showDialog<int>(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text("Select Check-In Hour"),
        children: hours
            .map(
              (h) => SimpleDialogOption(
                child: Text("${h.toString().padLeft(2, '0')}:00"),
                onPressed: () => Navigator.pop(context, h),
              ),
            )
            .toList(),
      ),
    );

    if (selectedHour != null) {
      selectedStartDate = tz.TZDateTime(
        nyLocation,
        selectedStartDate!.year,
        selectedStartDate!.month,
        selectedStartDate!.day,
        selectedHour,
      );

      // Check-Out should be at least 1 hour after Check-In
      selectedEndDate = selectedStartDate!.add(const Duration(hours: 1));

      final midnight = tz.TZDateTime(
        nyLocation,
        selectedStartDate!.year,
        selectedStartDate!.month,
        selectedStartDate!.day + 1,
      );

      if (selectedEndDate!.isAfter(midnight)) {
        selectedEndDate = midnight;
      }

      updateFormattedDates();
    }
  }

  Future<void> pickCheckOutHour() async {
    final startHour = selectedStartDate!.hour;
    final hours =
        List.generate(24 - startHour - 1, (index) => startHour + 1 + index);

    int? selectedHour = await showDialog<int>(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text("Select Check-Out Hour"),
        children: hours
            .map(
              (h) => SimpleDialogOption(
                child: Text("${h.toString().padLeft(2, '0')}:00"),
                onPressed: () => Navigator.pop(context, h),
              ),
            )
            .toList(),
      ),
    );

    if (selectedHour != null) {
      selectedEndDate = tz.TZDateTime(
        nyLocation,
        selectedStartDate!.year,
        selectedStartDate!.month,
        selectedStartDate!.day,
        selectedHour,
      );

      final midnight = tz.TZDateTime(
        nyLocation,
        selectedStartDate!.year,
        selectedStartDate!.month,
        selectedStartDate!.day + 1,
      );

      if (selectedEndDate!.isAfter(midnight)) {
        Get.snackbar("Invalid Time", "End time cannot go past midnight",
            snackPosition: SnackPosition.BOTTOM);
        selectedEndDate = midnight;
      }

      updateFormattedDates();
    }
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property Info
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.unitName,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            color: ColorFile.appColor, size: 20),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(widget.location,
                              style: const TextStyle(color: Colors.black54)),
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

            const SizedBox(height: 24),

            // Only Time Selection
            TextField(
              controller: _checkInController,
              readOnly: true,
              onTap: pickCheckInHour,
              decoration: InputDecoration(
                labelText: "Check-In Hour",
                prefixIcon: const Icon(Icons.login, color: ColorFile.appColor),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _checkOutController,
              readOnly: true,
              onTap: pickCheckOutHour,
              decoration: InputDecoration(
                labelText: "Check-Out Hour",
                prefixIcon: const Icon(Icons.logout, color: Colors.redAccent),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              ),
            ),

            const SizedBox(height: 24),

            // Price Info
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total Price:",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold)),
                        Text("\$${widget.basePrice.toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: ColorFile.appColor)),
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
                          fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Confirm Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                backgroundColor: ColorFile.appColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _isProcessing
                  ? null
                  : () async {
                      setState(() => _isProcessing = true);
                      final box = GetStorage();
                      final userEmail =
                          box.read('userEmail') ?? 'guest@example.com';

                      try {
                        Get.snackbar('Booking in progress...', 'Please wait...',
                            snackPosition: SnackPosition.BOTTOM,
                            duration: const Duration(seconds: 2));

                        final bookingApi = BookingApi();
                        final bookingResponse = await bookingApi.saveBooking(
                          unitId: int.parse(widget.unitId),
                          guestEmail: userEmail,
                          checkIn: formattedCheckIn,
                          checkOut: formattedCheckOut,
                          totalPrice: widget.basePrice,
                        );

                        final bookingId = bookingResponse['bookingId'];
                        await NotificationService().fetchNotifications();

                        if (mounted) {
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
                        }
                      } catch (e) {
                        Get.snackbar('Booking Failed', e.toString(),
                            snackPosition: SnackPosition.BOTTOM);
                      } finally {
                        if (mounted) setState(() => _isProcessing = false);
                      }
                    },
              child: _isProcessing
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : Text(
                      "Confirm & Pay \$${widget.basePrice.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
