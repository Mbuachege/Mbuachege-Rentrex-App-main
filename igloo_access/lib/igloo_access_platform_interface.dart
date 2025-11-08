import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'igloo_access_method_channel.dart';

abstract class IglooAccessPlatform extends PlatformInterface {
  /// Constructs a IglooAccessPlatform.
  IglooAccessPlatform() : super(token: _token);

  static final Object _token = Object();

  static IglooAccessPlatform _instance = MethodChannelIglooAccess();

  /// The default instance of [IglooAccessPlatform] to use.
  ///
  /// Defaults to [MethodChannelIglooAccess].
  static IglooAccessPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [IglooAccessPlatform] when
  /// they register themselves.
  static set instance(IglooAccessPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
