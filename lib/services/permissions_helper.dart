import 'package:permission_handler/permission_handler.dart';

class PermissionsHelper {
  static Future<bool> requestBluetooth() async {
    // For Android 12 and above
    final bluetoothScan = await Permission.bluetoothScan.request();
    final bluetoothConnect = await Permission.bluetoothConnect.request();

    // Return true only if all required permissions are granted
    return bluetoothScan.isGranted && bluetoothConnect.isGranted;
  }
}
