
import 'huawei_flutter_plugins_platform_interface.dart';

class HuaweiFlutterPlugins {
  Future<String?> getPlatformVersion() {
    return HuaweiFlutterPluginsPlatform.instance.getPlatformVersion();
  }
}
