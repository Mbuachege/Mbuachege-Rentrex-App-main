
import 'igloo_access_platform_interface.dart';

class IglooAccess {
  Future<String?> getPlatformVersion() {
    return IglooAccessPlatform.instance.getPlatformVersion();
  }
}
