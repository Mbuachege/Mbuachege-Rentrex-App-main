import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class IglooBridge {
  static const MethodChannel _ch = MethodChannel('com.yourapp/igloo');

  static Future<bool> ensurePermissions() async {
    if (await Permission.bluetoothScan.isGranted &&
        await Permission.bluetoothConnect.isGranted) return true;

    final statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse, // for older android versions
    ].request();
    return statuses.values.every((s) => s.isGranted);
  }

  static Future<void> init() async {
    await _ch.invokeMethod('init');
  }

  static Future<Map<String, dynamic>> unlock(
      String bluetoothName, String key) async {
    final res = await _ch.invokeMapMethod<String, dynamic>('unlock', {
      'bluetoothDeviceName': bluetoothName,
      'key': key,
    });
    return res ?? {};
  }

  static Future<Map<String, dynamic>> lock(
      String bluetoothName, String key) async {
    final res = await _ch.invokeMapMethod<String, dynamic>('lock', {
      'bluetoothDeviceName': bluetoothName,
      'key': key,
    });
    return res ?? {};
  }

  static Future<Map<String, dynamic>> sync(
    String bluetoothName,
    String key,
    String getDevicesToken,
    String storeLogsToken,
  ) async {
    final res = await _ch.invokeMapMethod<String, dynamic>('sync', {
      'bluetoothDeviceName': bluetoothName,
      'key': key,
      'getDevicesToken': getDevicesToken,
      'storeLogsToken': storeLogsToken,
    });
    return res ?? {};
  }
}
