import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidInitSettings);

    await flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  Future<void> fetchNotifications() async {
    try {
      final box = GetStorage();
      final email = box.read('userEmail');

      if (email == null || email.isEmpty) return;

      final url = Uri.parse(
          "http://appvacation.digikatech.africa/api/notifications?email=$email");

      final response = await http.get(url, headers: {"accept": "*/*"});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Save locally to show inside screens
        box.write("notifications", data);

        // Show popup for new ones
        for (var notif in data) {
          _showLocalNotification(notif["title"], notif["message"]);
        }
      }
    } catch (_) {}
  }

  Future<void> _showLocalNotification(String? title, String? body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'your_channel_id',
      'App Notifications',
      channelDescription: 'Notification channel for app messages',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails generalNotificationDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000, // unique ID
      title ?? "New Notification",
      body ?? "",
      generalNotificationDetails,
    );
  }
}
