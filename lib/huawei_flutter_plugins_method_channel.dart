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

  Future<void> initConfig(String ak, String sk) async {
    await methodChannel.invokeMethod('initConfig', {
      'ak': ak,
      'sk': sk,
    });
  }

  Future<RecognizeShortAudioResponse?> recognizeShortAudio(File audioFile, SisModelConfig config) async {
    final result = await methodChannel.invokeMethod<String>('recognizeShortAudio', {
      'audioFile': audioFile.path,
      'config': jsonEncode(config.toJson()),
    });
    // {\"result\":{\"score\":0.6445258,\"text\":\"1234姑\"},\"traceId\":\"047b44f1-4a80-4be7-bab0-af1ec5570b33\",\"httpStatusCode\":200}
    return RecognizeShortAudioResponse.fromJson(jsonDecode(result!));
  }
}
