import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_sound_record/flutter_sound_record.dart';
import 'package:huawei_flutter_plugins/huawei_flutter_plugins.dart';

import 'package:huawei_flutter_plugins/huawei_flutter_plugins_config.dart';import 'package:path_provider/path_provider.dart';
import 'dart:io';

class RecordPage extends StatefulWidget {
  const RecordPage({super.key});

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  FlutterSoundRecord? _audioRecorder;
  final _huawei_flutter_plugins = HuaweiFlutterPlugins();
  bool _isRecording = false;
  String? _recordPath;
  String ak = "CHG4XMMOMPGZXAFVWYTS", sk="oratGOI3iRgZn4ECW7akPEaIW4S9c04k1P3IhQku";

  _RecordPageState() {
    _huawei_flutter_plugins.initConfig(ak, sk);
  }

  Future<void> _startRecording() async {
    final dir = await getTemporaryDirectory();
    _recordPath = '${dir.path}/recorded_audio.aac';
    _audioRecorder = FlutterSoundRecord();

    // 请求录音权限
    final hasPermission = await _audioRecorder!.hasPermission();
    if (!hasPermission) {
      return;
    }

    // 开始录音
    await _audioRecorder!.start(
          path: _recordPath!,
          encoder: AudioEncoder.AAC,
          bitRate: 128000,
          samplingRate: 44100,
        );
    setState(() {
      _isRecording = true;
    });
  }

  Future<void> _stopRecording() async {
    try{
      final path = await _audioRecorder!.stop();
      _audioRecorder!.dispose();
      setState(() {
        _isRecording = false;
      });
      if (path != null) {
        print('录音文件保存在: $path');
        _huawei_flutter_plugins.recognizeShortAudio(File(path), new SisModelConfig(audioFormatEnum: AudioFormatEnum.aac, propertyEnum: PropertyEnum.chinese_16k_general));
      }
    }catch(e) {
      debugPrint('停止录音失败: $e');
      _audioRecorder = null;
      setState(() {
        _isRecording = false;
      });
      rethrow;
    }
  }

  @override
  void dispose() {
    _audioRecorder!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('录音示例'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _isRecording ? _stopRecording : _startRecording,
              child: Text(_isRecording ? '停止录音' : '开始录音'),
            ),
            if (_isRecording)
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('正在录音...', style: TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }
}