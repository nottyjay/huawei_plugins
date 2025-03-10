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
  auto
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
  english_8k_common
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
  }): audioFormat = audioFormatEnum.name,
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