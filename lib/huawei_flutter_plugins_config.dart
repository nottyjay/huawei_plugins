enum AudioFormatEnum {
  pcm16k16bit,
  pcm8k16bit,
  ulaw16k8bit,
  ulaw8k8bit,
  alaw16k8bit,
  alaw8k8bit,
  mp3,
  aac,
  wav,
  amr,
  amrwb,
  auto,
  // 可以根据实际情况添加更多音频格式
}

enum PropertyEnum {
  chinese_16k_general,
  chinese_16k_travel,
  sichuan_16k_common,
  cantonese_16k_common,
  shanghai_16k_common,
  chinese_8k_common,
  chinese_16k_common,
  english_16k_common,
  english_8k_common,
}

/**
 * 华为一句话识HTTP版本配置
 */
class SisModelConfig {
  String audioFormat;
  String property;
  String? addPunc;
  String? digitNorm;
  String? vocabularyId;
  String? needWordInfo;

  SisModelConfig({
    required AudioFormatEnum audioFormatEnum,
    required PropertyEnum propertyEnum,
    this.addPunc,
    this.digitNorm,
    this.vocabularyId,
    this.needWordInfo,
  }) : audioFormat = audioFormatEnum.name,
       property = propertyEnum.name;

  Map<String, dynamic> toJson() {
    return {
      'audioFormat': audioFormat,
      'property': property,
      'addPunc': addPunc,
      'digitNorm': digitNorm,
      'vocabularyId': vocabularyId,
      'needWordInfo': needWordInfo,
    };
  }
}

class Result {
  final double score;
  final String text;
  Result({required this.score, required this.text});
  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      score: (json['score'] as num).toDouble(),
      text: json['text'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {'score': score, 'text': text};
  }
}

class RecognizeShortAudioResponse {
  final int httpStatusCode; // 200 成功时的字段
  final Result? result;
  final String? traceId; // 400 失败时的字段
  final String? errorCode;
  final String? errorMsg;
  RecognizeShortAudioResponse._({
    required this.httpStatusCode,
    this.result,
    this.traceId,
    this.errorCode,
    this.errorMsg,
  });
  factory RecognizeShortAudioResponse.fromJson(Map<String, dynamic> json) {
    final statusCode = json['httpStatusCode'] as int;
    if (statusCode == 200) {
      return RecognizeShortAudioResponse._(
        httpStatusCode: statusCode,
        result: Result.fromJson(json['result'] as Map<String, dynamic>),
        traceId: json['traceId'] as String,
      );
    } else if (statusCode == 400) {
      return RecognizeShortAudioResponse._(
        httpStatusCode: statusCode,
        errorCode: json['error_code'] as String,
        errorMsg: json['error_msg'] as String,
      );
    } else {
      throw FormatException('Unsupported status code: $statusCode');
    }
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{'httpStatusCode': httpStatusCode};
    if (httpStatusCode == 200) {
      map['result'] = result!.toJson();
      map['traceId'] = traceId;
    } else if (httpStatusCode == 400) {
      map['error_code'] = errorCode;
      map['error_msg'] = errorMsg;
    }
    return map;
  }
}
