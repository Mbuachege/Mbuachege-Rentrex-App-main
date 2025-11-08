import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'igloo_access_platform_interface.dart';

/// An implementation of [IglooAccessPlatform] that uses method channels.
class MethodChannelIglooAccess extends IglooAccessPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('igloo_access');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
