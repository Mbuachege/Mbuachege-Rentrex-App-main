import 'dart:async';
import 'package:get/instance_manager.dart';
import 'package:http/http.dart' as http;
import 'package:prime_travel_flutter_ui_kit/controller/home_controller%20copy.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';

class ReminderService {
  final String hubUrl = "http://appvacation.digikatech.africa/reminderHub";
  final String endpointUrl =
      "http://appvacation.digikatech.africa/api/bookings/run";
  final homeController = Get.put(HomeControllerCopy());
  late HubConnection _connection;
  Timer? _timer;

  Future<void> start() async {
    try {
      // 1️⃣ Build connection
      _connection = HubConnectionBuilder().withUrl(hubUrl).build();
      homeController.initializeSignalR();
      // 2️⃣ Setup listener
      _connection.on("ReceiveMessage", (message) {
        print("📢 Server says: ${message?.first}");
      });

      // 3️⃣ Start connection
      await _connection.start();
      print("✅ Connected to SignalRg Hub");

      // 4️⃣ Start timer to call the API every 3 minutes
      _timer = Timer.periodic(
        const Duration(minutes: 3),
        (_) => _triggerReminderCheck(),
      );

      // Optional: trigger it immediately on app start
      await _triggerReminderCheck();
    } catch (e) {
      print("❌ Failed to connect or start reminder service: $e");
    }
  }

  Future<void> _triggerReminderCheck() async {
    try {
      final response = await http.get(Uri.parse(endpointUrl));
      print("🔁 Reminder job triggered: ${response.statusCode}");
    } catch (e) {
      print("⚠️ Failed to trigger job: $e");
    }
  }

  Future<void> stop() async {
    _timer?.cancel();
    await _connection.stop();
    print("🛑 Disconnected from Hub");
  }
}
