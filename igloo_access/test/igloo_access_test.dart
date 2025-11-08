import 'package:flutter_test/flutter_test.dart';
import 'package:igloo_access/igloo_access.dart';
import 'package:igloo_access/igloo_access_platform_interface.dart';
import 'package:igloo_access/igloo_access_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockIglooAccessPlatform
    with MockPlatformInterfaceMixin
    implements IglooAccessPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final IglooAccessPlatform initialPlatform = IglooAccessPlatform.instance;

  test('$MethodChannelIglooAccess is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelIglooAccess>());
  });

  test('getPlatformVersion', () async {
    IglooAccess iglooAccessPlugin = IglooAccess();
    MockIglooAccessPlatform fakePlatform = MockIglooAccessPlatform();
    IglooAccessPlatform.instance = fakePlatform;

    expect(await iglooAccessPlugin.getPlatformVersion(), '42');
  });
}
