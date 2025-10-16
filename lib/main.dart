import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

// Controllers
import 'package:prime_travel_flutter_ui_kit/controller/home_controller%20copy.dart';
import 'package:prime_travel_flutter_ui_kit/controller/storage_controller.dart';
import 'package:prime_travel_flutter_ui_kit/services/app_lifecycle_manager.dart';

// Services
import 'package:prime_travel_flutter_ui_kit/services/auth_api.dart';
import 'package:prime_travel_flutter_ui_kit/services/firebase_service.dart';
import 'package:prime_travel_flutter_ui_kit/services/notification_service.dart';
import 'package:prime_travel_flutter_ui_kit/services/reminder_service%20.dart';

// Utilities
import 'package:prime_travel_flutter_ui_kit/firebase_options.dart';
import 'package:prime_travel_flutter_ui_kit/localization/app_translation.dart';
import 'package:prime_travel_flutter_ui_kit/util/app_routes.dart';
import 'package:prime_travel_flutter_ui_kit/util/colors.dart';
import 'package:prime_travel_flutter_ui_kit/util/string_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();

  final lifecycleManager = AppLifecycleManager();
  lifecycleManager.startObserving();

  Get.put(HomeControllerCopy(), permanent: true);

  final baseUrl = 'http://appvacation.digikatech.africa';
  Get.put<AuthApi>(AuthApi(baseUrl), permanent: true);
  Get.put<FirebaseServices>(FirebaseServices(baseUrl), permanent: true);

  final notificationService = NotificationService();
  await notificationService.init();

  String? languageCode = await StorageController.instance.getLanguage();
  String? countryCode = await StorageController.instance.getCountryCode();

  final box = GetStorage();
  final lastRoute = box.read('last_route') ?? AppRoutes.splashScreen;

  runApp(MyApp(
    languageCode: languageCode,
    countryCode: countryCode,
    initialRoute: lastRoute,
  ));
}

class MyApp extends StatefulWidget {
  final String? languageCode;
  final String? countryCode;
  final String initialRoute;

  const MyApp({
    Key? key,
    this.languageCode,
    this.countryCode,
    required this.initialRoute,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ReminderService reminderService;

  @override
  void initState() {
    super.initState();
    reminderService = ReminderService();
    reminderService.start(); // Starts periodic call every 3 minutes
  }

  @override
  void dispose() {
    reminderService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: StringConfig.appName,
      theme: ThemeData(primaryColor: ColorFile.appColor),
      translationsKeys: AppTranslation.translationsKeys,
      locale: Locale(widget.languageCode ?? "en", widget.countryCode ?? "US"),
      initialRoute: AppRoutes.splashScreen,
      routes: AppRoutes.routes,
    );
  }
}
