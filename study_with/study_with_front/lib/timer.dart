import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:just_audio/just_audio.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_recognition_error.dart';

import 'home.dart';

import 'config/size_config.dart';
import 'config/color_config.dart';

//アプリの大まかな構成。
//今回はロゴのみ

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
  String now_clock = "";
  String now_study = "";
  Image tmp = Image.asset("img/study_0.png");

  var now = DateTime.now();

  int tmp_hour = 12;

  int day = 0;
  int month = 0;

  int day_hour = 0;
  int day_minute = 0;
  int day_second = 0;

  int hour = 0;
  int minute = 0;
  int second = 0;

  int tmp_second = 0;
  bool study = true;

  final player = AudioPlayer();
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  String lastError = '';
  String lastStatus = '';

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

  void bgm_study() async {
    final duration = await player.setAsset('bgm/PC-Keyboard03-01(Mid).mp3');
    player.setSpeed(0.8);
    player.setVolume(0.2);
    player.play();
  }

  void bgm_Stop() async {
    player.stop();
  }

  study_time() {
    Timer.periodic(
        const Duration(seconds: 7) //10minuteに変更必須
        , (time) {
      if (study) {
        setState(() {
          second++;
          if (second >= 60) {
            minute++;
            second = 0;
            if (minute >= 60) {
              hour++;
              minute = 0;
            }
          }
        });
      }
    });
  }

  now_time() {
    Timer.periodic(
        const Duration(seconds: 1) //10minuteに変更必須
        , (timer) {
      setState(() {
        now = DateTime.now();
        month = now.month;
        day = now.day;
        day_hour = now.hour;
        day_minute = now.minute;
        day_second = now.second;
        now_clock = month.toString().padLeft(2, "0") +
            "月" +
            day.toString().padLeft(2, "0") +
            "日　" +
            day_hour.toString().padLeft(2, "0") +
            ":" +
            day_minute.toString().padLeft(2, "0") +
            ":" +
            day_second.toString().padLeft(2, "0");
        if (study) {
          if (tmp_second != day_second) {
            second++;
            if (second >= 60) {
              minute++;
              second = 0;
              if (minute >= 60) {
                hour++;
                minute = 0;
              }
            }
          }
        }
        tmp_second = day_second;
      });
    });
  }

  clock_now() {
    now_time();
    return now_clock;
  }

  study_now() {
    now_time();
    now_study = "作業時間[" +
        hour.toString().padLeft(2, "0") +
        ":" +
        minute.toString().padLeft(2, "0") +
        ":" +
        second.toString().padLeft(2, "0") +
        "]";
    return now_study;
  }

  img() {
    var random = math.Random();
    if (study) {
      setState(() {
        tmp = Image.asset("img/study_0.png");
      });
    } else {
      int index = random.nextInt(3);
      setState(() {
        tmp = Image.asset('img/kyukei_0.png');
      });
    }
    return tmp;
  }

  Widget build(BuildContext context) {
    if (study) {
      bgm_study();
    } else if (!study) {
      bgm_Stop();
    }

    Size().init(context);
    return Scaffold(
      body: Stack(children: [
        Column(
          children: [
            Row(
              children: [
                Padding(
                    padding:
                        EdgeInsets.only(top: Size.h! * 2, left: Size.w! * 4)),
                Text(
                  clock_now(),
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 62, 58, 58),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                    padding:
                        EdgeInsets.only(top: Size.h! * 2, left: Size.w! * 4)),
                Text(
                  study_now(), //firebaseで後ほど
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 62, 58, 58),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        Container(
          child: Center(
            child: Container(
                child: GestureDetector(
              onTap: () {
                print("Tap");
                study = !study;
              },
              onLongPress: () {
                print("press");
                bgm_Stop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(),
                  ),
                );
              },
              child: img(),
            )),
          ),
        ),
      ]),
    );
  }
}