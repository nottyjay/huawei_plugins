
import 'dart:io';

import 'huawei_flutter_plugins_config.dart';
import 'huawei_flutter_plugins_platform_interface.dart';

class HuaweiFlutterPlugins {

  Future<String?> getPlatformVersion() {
    return HuaweiFlutterPluginsPlatform.instance.getPlatformVersion();
  }

  Future<void> initConfig(String ak, String sk, String projectId, String region) {
    return HuaweiFlutterPluginsPlatform.instance.initConfig(ak, sk, projectId, region);
  }

  Future<RecognizeShortAudioResponse?> recognizeShortAudio(File audioFile, SisModelConfig config) {
    return HuaweiFlutterPluginsPlatform.instance.recognizeShortAudio(audioFile, config);
  }
}
