import Flutter
import UIKit
import SIS

struct EncodableSASRResult: Encodable {
    let text: String
    let score: Float
    
    init(from result: SASRResult) {
        self.text = result.text
        self.score = result.score
    }
}

struct SASRResponseWrapper: Encodable {
    let traceId: String
    let result: EncodableSASRResult
    let httpStatusCode = 200
    
    init(response: SASRResponse) {
        self.traceId = response.traceId
        self.result = EncodableSASRResult(from: response.result)
    }
}

struct SASRErrorResponseWrapper: Encodable {
    let errorCode: String
    let errorMsg: String
    let httpStatusCode = 400
    
    init(response: SASRErrorResponse) {
        self.errorCode = response.errorCode
        self.errorMsg = response.errorMsg
    }
}

class HTTPClientDelegate: HTTPDelegate {
    
    private var result: FlutterResult?
    
    func setResult(_ result: FlutterResult?) {
        self.result = result
    }
    
    func onMessage(response: SASRResponse) {
        let wrapper = SASRResponseWrapper(response: response)
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(wrapper),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            self.result?(jsonString)
        }
    }
    
    func onError(response: SASRErrorResponse) {
        let wrapper = SASRErrorResponseWrapper(response: response)
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(wrapper),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            self.result?(jsonString)
        }
    }
    
}

public class HuaweiFlutterPluginsPlugin: NSObject, FlutterPlugin {
    
    private var delegate =  HTTPClientDelegate()
  private var client: SASRClient?
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "huawei_flutter_plugins", binaryMessenger: registrar.messenger())
    let instance = HuaweiFlutterPluginsPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
      return
    case "initConfig":
        if let arguments = call.arguments as? [String: Any],
           let ak = arguments["ak"] as? String,
           let sk = arguments["sk"] as? String,
           let projectId = arguments["projectId"] as? String,
           let region = arguments["region"] as? String {
            let authInfo = AuthInfo(ak: ak, sk: sk, region: region, projectId: projectId)
            self.client = SASRClient(auth: authInfo)
            self.client!.delegate = self.delegate
            result(nil)
        } else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing required parameters: ak or sk", details: nil))
        }
        return
    case "recognizeShortAudio":
        if let arguments = call.arguments as? [String: Any],
       let audioPath = arguments["audioFile"] as? String,
       let configJson = arguments["config"] as? String,
       let jsonData = configJson.data(using: .utf8),
       let jsonObject = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any] {
        
        // 创建配置对象
        var config = SASRConfig()
        
        if let audioFormat = jsonObject["audioFormat"] as? String {
            config.audioFormat = audioFormat
        }
        if let property = jsonObject["property"] as? String {
            config.property = property
        }
        if let addPunc = jsonObject["addPunc"] as? String, addPunc != "null" {
            config.addPunc = addPunc
        }
        if let digitNorm = jsonObject["digitNorm"] as? String, digitNorm != "null" {
            config.digitNorm = digitNorm
        }
        if let vocabularyId = jsonObject["vocabularyId"] as? String, vocabularyId != "null" {
            config.vocabularyId = vocabularyId
        }

        // 读取音频文件并转换为 Base64
        do {
            let audioData = try Data(contentsOf: URL(fileURLWithPath: audioPath))
            let base64Audio = audioData.base64EncodedData()
            let strData = String(decoding: base64Audio, as: UTF8.self)
            self.delegate.setResult(result)
            
            let sasrRequest = SASRRequest(config: config, data: strData)
            self.client!.transcribe(request: sasrRequest)

        } catch {
            result(FlutterError(code: "FILE_ERROR", message: "Failed to read audio file", details: nil))
            return
        }
      }else{
        result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing required parameters: audioFile or config", details: nil))
        return
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
