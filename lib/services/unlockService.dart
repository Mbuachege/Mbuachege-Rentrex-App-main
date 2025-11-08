import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prime_travel_flutter_ui_kit/services/secure_store.dart';

class UnlockService {
  final String baseUrl = "http://appvacation.digikatech.africa/api/bookings";

  /// Unlock using pin/code (hourly endpoint)
  Future<String> unlockWithCode({
    required String lockId,
    required int bookingId,
    required int variance,
    required String startDate,
    required String endDate,
    required String propertyName,
    required String unitName,
    required String guestName,
    required String address,
    required String guestEmail,
  }) async {
    try {
      final token = await SecureStore.getToken();

      final url = Uri.parse("$baseUrl/$lockId/pin/hourly");

      final payload = {
        "variance": variance,
        "startDate": startDate,
        "endDate": endDate,
        "propertyName": propertyName,
        "unitName": unitName,
        "guestName": guestName,
        "address": address,
        "guestEmail": guestEmail,
        "bookingId": bookingId,
      };
      print("UnlockService payload: ${jsonEncode(payload)}");
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        // API responds with a plain string (pin code)
        return response.body.replaceAll('"', ''); // clean quotes if JSON string
      } else {
        final err = jsonDecode(response.body);
        throw Exception(err["message"] ?? "Failed to unlock with code");
      }
    } catch (e) {
      throw Exception("Error unlocking with code: $e");
    }
  }

  /// Unlock via Bluetooth (still placeholder until real API confirmed)
  /// Request a Bluetooth Guest Key (ekey)
  Future<String> getBluetoothGuestKey({
    required String lockId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final token = await SecureStore.getToken();

      final url = Uri.parse("$baseUrl/$lockId/ekeys");

      final payload = {
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        "permissions": ["UNLOCK"]
      };

      final response = await http.post(
        url,
        headers: {
          "accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["bluetoothGuestKey"];
      } else {
        throw Exception(
          "Failed to fetch Bluetooth Guest Key: ${response.statusCode} - ${response.body}",
        );
      }
    } catch (e) {
      throw Exception("Error requesting Bluetooth Guest Key: $e");
    }
  }
}
