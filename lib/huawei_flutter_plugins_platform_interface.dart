import 'dart:io';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'huawei_flutter_plugins_config.dart';
import 'huawei_flutter_plugins_method_channel.dart';

abstract class HuaweiFlutterPluginsPlatform extends PlatformInterface {
  /// Constructs a HuaweiFlutterPluginsPlatform.
  HuaweiFlutterPluginsPlatform() : super(token: _token);

  static final Object _token = Object();

  static HuaweiFlutterPluginsPlatform _instance = MethodChannelHuaweiFlutterPlugins();

  /// The default instance of [HuaweiFlutterPluginsPlatform] to use.
  ///
  /// Defaults to [MethodChannelHuaweiFlutterPlugins].
  static HuaweiFlutterPluginsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [HuaweiFlutterPluginsPlatform] when
  /// they register themselves.
  static set instance(HuaweiFlutterPluginsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> initConfig(String ak, String sk) {
    throw UnimplementedError('initConfig() has not been implemented.');
  }

  Future<void> recognizeShortAudio(File audioFile, SisModelConfig config) {
    throw UnimplementedError('recognizeShortAudio() has not been implemented.');
  }
}
