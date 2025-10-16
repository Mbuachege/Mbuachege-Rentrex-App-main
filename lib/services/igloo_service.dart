import 'package:flutter/services.dart';

class IglooService {
  static const _channel = MethodChannel('igloo_plugin_channel');

  /// Unlock device
  static Future<String> unlock(String device, String key) async {
    try {
      final result = await _channel.invokeMethod('unlock', {
        'device': device,
        'key': key,
      });
      return result;
    } on PlatformException catch (e) {
      throw Exception("Unlock failed: ${e.message}");
    }
  }

  /// Lock device
  static Future<String> lock(String device, String key) async {
    try {
      final result = await _channel.invokeMethod('lock', {
        'device': device,
        'key': key,
      });
      return result;
    } on PlatformException catch (e) {
      throw Exception("Lock failed: ${e.message}");
    }
  }

  /// Sync device
  static Future<String> sync(
      String device, String key, String getToken, String storeToken) async {
    try {
      final result = await _channel.invokeMethod('sync', {
        'device': device,
        'key': key,
        'getToken': getToken,
        'storeToken': storeToken,
      });
      return result;
    } on PlatformException catch (e) {
      throw Exception("Sync failed: ${e.message}");
    }
  }
}
