import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:huawei_flutter_plugins/huawei_flutter_plugins_config.dart';

import 'huawei_flutter_plugins_platform_interface.dart';

/// An implementation of [HuaweiFlutterPluginsPlatform] that uses method channels.
class MethodChannelHuaweiFlutterPlugins extends HuaweiFlutterPluginsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('huawei_flutter_plugins');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  Future<void> recognizeShortAudio(File audioFile, SisModelConfig config) async {
    await methodChannel.invokeMethod('recognizeShortAudio', {
      'audioFile': audioFile.path,
      'config': jsonEncode(config.toJson()),
    });

  }
}
