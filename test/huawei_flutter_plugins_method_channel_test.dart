import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:huawei_flutter_plugins/huawei_flutter_plugins_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelHuaweiFlutterPlugins platform = MethodChannelHuaweiFlutterPlugins();
  const MethodChannel channel = MethodChannel('huawei_flutter_plugins');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
