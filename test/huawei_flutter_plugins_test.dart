import 'package:flutter_test/flutter_test.dart';
import 'package:huawei_flutter_plugins/huawei_flutter_plugins.dart';
import 'package:huawei_flutter_plugins/huawei_flutter_plugins_platform_interface.dart';
import 'package:huawei_flutter_plugins/huawei_flutter_plugins_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockHuaweiFlutterPluginsPlatform
    with MockPlatformInterfaceMixin
    implements HuaweiFlutterPluginsPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final HuaweiFlutterPluginsPlatform initialPlatform = HuaweiFlutterPluginsPlatform.instance;

  test('$MethodChannelHuaweiFlutterPlugins is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelHuaweiFlutterPlugins>());
  });

  test('getPlatformVersion', () async {
    HuaweiFlutterPlugins huaweiFlutterPluginsPlugin = HuaweiFlutterPlugins();
    MockHuaweiFlutterPluginsPlatform fakePlatform = MockHuaweiFlutterPluginsPlatform();
    HuaweiFlutterPluginsPlatform.instance = fakePlatform;

    expect(await huaweiFlutterPluginsPlugin.getPlatformVersion(), '42');
  });
}
