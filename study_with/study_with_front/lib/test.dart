import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'dart:math' as math;

// main関数、MyApp、MyHomePageはデフォルトから変更がないため省略
class Time extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: time(),
    );
  }
}

class time extends StatefulWidget {
  @override
  State<time> createState() => _time();
}

class _time extends State<time> {
  var random = math.Random();
  FlutterTts flutterTts = FlutterTts();
  List text = ["うん", "ほう", "ふむ", "なるほど", "へぇ"];

  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  String lastError = '';
  String lastStatus = '';
  String tmp ="";
 @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    print("off");
    _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
     if(tmp!= _lastWords){
        _speak();
      }
  }
/*
  void errorListener(SpeechRecognitionError error) {
    setState(() {
      lastError = '${error.errorMsg} - ${error.permanent}';
    });
  }
*/
  void statusListener(String status) {
    setState(() {
      lastStatus = '$status';
    });
  }

  // 読み上げ用

  tmpText() {
    int index = random.nextInt(text.length);
    return text[index];
  }

  Future<void> _speak() async {
    await flutterTts.setLanguage("ja-JP"); // 言語
    await flutterTts.setSpeechRate(0.9); // 速度
    await flutterTts.setVolume(0.5); // 音量
    await flutterTts.setPitch(1.5); // ピッチ
    await flutterTts.speak(tmpText()); //読み上げ
  }

  // 停止用
  Future<void> _stop() async {
    await flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          " ",
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              tmpText(),
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton:
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        FloatingActionButton(
            onPressed: _speechToText.isNotListening ? _startListening : _stopListening,
        tooltip: 'Listen',
        child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
        ),
      ]),
    );
  }
}
