import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:prime_travel_flutter_ui_kit/services/secure_store.dart';

class BookingApi {
  final String baseUrl = 'http://appvacation.digikatech.africa/api/bookings';

  Future<Map<String, dynamic>> saveBooking({
    required int unitId,
    required String guestEmail,
    required DateTime checkIn,
    required DateTime checkOut,
    required double totalPrice,
    String status = 'pending',
    String payment = 'unpaid',
    String review = '',
  }) async {
    final url = Uri.parse('$baseUrl/save');

    // Get the stored token
    final token = await SecureStore.getToken();
    print(
        "🔑 Token preview: ${token?.substring(0, 10)}..."); // just the first 10 chars
    print("Token length: ${token?.length}");

    if (token == null) {
      print("❌ Error: User is not authenticated.");
      throw Exception('User is not authenticated.');
    }

    final body = jsonEncode({
      "id": 0,
      "unitId": unitId,
      "guestEmail": guestEmail,
      "checkIn": checkIn.toIso8601String(),
      "checkOut": checkOut.toIso8601String(),
      "totalPrice": totalPrice,
      "status": status,
      "payment": payment,
      "review": review,
    });

    // Log request body and headers
    print("➡️ Booking API Request URL: $url");
    print("➡️ Booking API Request Headers: ${{
      'Accept': '*/*',
      'Content-Type': 'application/json-patch+json',
      'Authorization': 'Bearer $token',
    }}");
    print("➡️ Booking API Request Body: $body");

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': '*/*',
          'Content-Type': 'application/json-patch+json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      // Log the response
      print("⬅️ Booking API Response Status: ${response.statusCode}");
      print("⬅️ Booking API Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        // Log error with details
        print("❌ Failed to save booking");
        print("   Status: ${response.statusCode}");
        print("   Body: ${response.body}");
        throw HttpException(
            'Failed to save booking (HTTP ${response.statusCode}): ${response.body}');
      }
    } catch (e, st) {
      // Catch any other exception
      print("💥 Exception caught in BookingApi.saveBooking: $e");
      print("Stacktrace: $st");
      rethrow;
    }
  }
}
