package com.alphay.huawei.huawei_flutter_plugins;

import androidx.annotation.NonNull;

import com.huaweicloud.sdk.core.auth.BasicCredentials;
import com.huaweicloud.sdk.core.http.HttpConfig;
import com.huaweicloud.sdk.sis.v1.SisClient;
import com.huaweicloud.sdk.sis.v1.region.SisRegion;

import org.json.JSONException;
import org.json.JSONObject;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** HuaweiFlutterPluginsPlugin */
public class HuaweiFlutterPluginsPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  private SisClient client = null;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "huawei_flutter_plugins");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if(call.method.equals("initConfig")) {
      String configJson = call.argument("config");
      try {
        JSONObject jsonObject = new JSONObject(configJson);
        String ak = jsonObject.getString("ak");
        String sk = jsonObject.getString("sk");
        BasicCredentials basicCredentials = new BasicCredentials().withAk(ak).withSk(sk);
        this.client = SisClient.newBuilder().withHttpConfig(HttpConfig.getDefaultHttpConfig())
                .withCredential(basicCredentials)
                .withRegion(SisRegion.valueOf("cn-north-4"))
                .build();
      } catch (JSONException e) {
        throw new RuntimeException(e);
      }
    } else if(call.method.equals("recognizeShortAudio")) {
      String path = call.argument("audioFile");
      String configJson = call.argument("config");
        try {
            JSONObject jsonObject = new JSONObject(configJson);
        } catch (JSONException e) {
            throw new RuntimeException(e);
        }
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
