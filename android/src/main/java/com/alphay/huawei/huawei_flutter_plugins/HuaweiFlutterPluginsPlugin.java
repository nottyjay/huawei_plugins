package com.alphay.huawei.huawei_flutter_plugins;

import android.os.Build;

import androidx.annotation.NonNull;

import com.google.gson.Gson;
import com.huaweicloud.sdk.core.auth.BasicCredentials;
import com.huaweicloud.sdk.core.http.HttpConfig;
import com.huaweicloud.sdk.sis.v1.SisClient;
import com.huaweicloud.sdk.sis.v1.model.Config;
import com.huaweicloud.sdk.sis.v1.model.PostShortAudioReq;
import com.huaweicloud.sdk.sis.v1.model.RecognizeShortAudioRequest;
import com.huaweicloud.sdk.sis.v1.model.RecognizeShortAudioResponse;
import com.huaweicloud.sdk.sis.v1.region.SisRegion;

import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.Base64;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** HuaweiFlutterPluginsPlugin */
public class HuaweiFlutterPluginsPlugin implements FlutterPlugin, MethodCallHandler {
  private static final Logger log = LoggerFactory.getLogger(HuaweiFlutterPluginsPlugin.class);
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
        String ak = call.argument("ak");
        String sk = call.argument("sk");
        new Thread(() -> {
          BasicCredentials basicCredentials = new BasicCredentials().withAk(ak).withSk(sk);
          this.client = SisClient.newBuilder().withHttpConfig(HttpConfig.getDefaultHttpConfig())
                  .withCredential(basicCredentials)
                  .withRegion(SisRegion.valueOf("cn-north-4"))
                  .build();
          result.success(null);
        }).start();
        
    } else if(call.method.equals("recognizeShortAudio")) {
      String path = call.argument("audioFile");
      String configJson = call.argument("config");
      new Thread(() -> {
        try {
          JSONObject jsonObject = new JSONObject(configJson);
          Config configBody = new Config();
          configBody.setAudioFormat(Config.AudioFormatEnum.fromValue(jsonObject.getString("audioFormat")));
          configBody.setProperty(Config.PropertyEnum.fromValue(jsonObject.getString("property")));
          if(!"null".equals(jsonObject.getString("addPunc"))) {
            configBody.setAddPunc(Config.AddPuncEnum.fromValue(jsonObject.getString("addPunc")));
          }
          if(!"null".equals(jsonObject.getString("digitNorm"))) {
            configBody.setDigitNorm(Config.DigitNormEnum.fromValue(jsonObject.getString("digitNorm")));
          }
          if(!"null".equals(jsonObject.getString("vocabularyId"))) {
            configBody.setVocabularyId(jsonObject.getString("vocabularyId"));
          }
          if(!"null".equals(jsonObject.getString("needWordInfo"))) {
            configBody.setNeedWordInfo(Config.NeedWordInfoEnum.fromValue(jsonObject.getString("needWordInfo")));
          }
          RecognizeShortAudioRequest request = new RecognizeShortAudioRequest();
          PostShortAudioReq body = new PostShortAudioReq();

          // 加载文件并转换为 Base64 字符串
          File file = new File(path);
          byte[] fileContent = Files.readAllBytes(file.toPath());
          String base64Audio = Base64.getEncoder().encodeToString(fileContent);
          body.withData(base64Audio);
          body.withConfig(configBody);
          request.withBody(body);

          RecognizeShortAudioResponse response = client.recognizeShortAudio(request);
          log.debug(response.toString());
          result.success(new Gson().toJson(response));
        } catch (JSONException | IOException e) {
          result.error("ERROR", e.getMessage(), null);
        }
      }).start();
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
