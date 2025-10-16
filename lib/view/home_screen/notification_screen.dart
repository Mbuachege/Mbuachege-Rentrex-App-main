import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:prime_travel_flutter_ui_kit/util/colors.dart';
import 'package:prime_travel_flutter_ui_kit/view/login_screem/login_screen.dart';
import '../../util/font_family.dart';
import '../../util/size_config.dart';
import '../../util/string_config.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<dynamic> notifications = [];
  bool isLoading = true;
  bool hasError = false;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _checkLoginBeforeFetching();
  }

  /// ✅ Initialize local notifications
  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidInitSettings);

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload == "open_notifications") {
          // Navigate to the notifications page
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const NotificationScreen()),
          );
        }
      },
    );
  }

  /// ✅ Check if user is logged in before fetching notifications
  void _checkLoginBeforeFetching() {
    final box = GetStorage();
    final isLoggedIn = box.read('isLoggedIn') ?? false;

    if (!isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showLoginDialog();
      });
    } else {
      fetchNotifications();
    }
  }

  /// ✅ Fetch notifications from API
  Future<void> fetchNotifications() async {
    try {
      final box = GetStorage();
      final email = box.read('userEmail');

      if (email == null || email.isEmpty) {
        setState(() {
          hasError = true;
          isLoading = false;
        });
        return;
      }

      final url = Uri.parse(
          "http://appvacation.digikatech.africa/api/notifications?email=$email");

      final response = await http.get(url, headers: {"accept": "*/*"});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          notifications = data;
          isLoading = false;
        });

        // 🔔 Show popup for every notification in the list
        for (var notif in data) {
          _showLocalNotification(notif["title"], notif["message"]);
        }
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

  /// ✅ Show system popup notification
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
      0,
      title ?? "New Notification",
      body ?? "",
      generalNotificationDetails,
      payload: "open_notifications", // ✅ attach payload
    );
  }

  /// 🔑 Show login dialog if not logged in
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
                "Please log in to view your notifications.",
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
                              fetchNotifications();
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
                        hasError = true; // user cancelled login
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
        backgroundColor: ColorFile.whiteColor,
        elevation: 0,
        title: const Text(
          StringConfig.notifications,
          style: TextStyle(
            decorationColor: ColorFile.onBordingColor,
            color: ColorFile.onBordingColor,
            fontFamily: satoshiBold,
            fontWeight: FontWeight.w500,
            fontSize: SizeFile.height22,
          ),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back, color: ColorFile.onBordingColor),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
              ? const Center(
                  child: Text("Login required or failed to load notifications"))
              : notifications.isEmpty
                  ? const Center(child: Text("No notifications found"))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: SizeFile.height20,
                          vertical: SizeFile.height10),
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final notif = notifications[index];
                        return Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.notifications,
                                  size: 42,
                                  color: ColorFile.onBordingColor,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        notif["title"] ?? "",
                                        style: const TextStyle(
                                          color: ColorFile.onBordingColor,
                                          fontFamily: satoshiMedium,
                                          fontWeight: FontWeight.w500,
                                          fontSize: SizeFile.height16,
                                        ),
                                      ),
                                      Text(
                                        notif["message"] ?? "",
                                        style: const TextStyle(
                                          color: ColorFile.onBordingColor,
                                          fontFamily: satoshiRegular,
                                          fontWeight: FontWeight.w400,
                                          fontSize: SizeFile.height12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Divider(color: ColorFile.border),
                          ],
                        );
                      },
                    ),
    );
  }
}
