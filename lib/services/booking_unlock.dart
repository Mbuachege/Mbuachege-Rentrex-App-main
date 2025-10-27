import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prime_travel_flutter_ui_kit/model/booking_model.dart';
import 'package:prime_travel_flutter_ui_kit/services/secure_store.dart';
import 'package:get_storage/get_storage.dart';

class BookingUnlockApi {
  final String baseUrl = 'http://appvacation.digikatech.africa/api/bookings';

  Future<List<Booking>> getBookingsByGuest() async {
    final box = GetStorage();
    final email = box.read('userEmail');
    final token = await SecureStore.getToken();

    if (email == null || token == null) {
      throw Exception("User not authenticated");
    }

    final url = Uri.parse('$baseUrl/ByGuest$email');

    final response = await http.get(
      url,
      headers: {
        "accept": "application/json",
        "Authorization": "Bearer $token", // include token
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      print("bookingssss: ${data.toString()}");
      return data.map((json) => Booking.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load bookings: ${response.statusCode}");
    }
  }
}
