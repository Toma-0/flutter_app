import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'home.dart';
import "sin_in.dart";
import "timer.dart";

import 'config/size_config.dart';
import 'config/color_config.dart';

//アプリの大まかな構成。
//今回はロゴのみ
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: home(),
    );
  }
}

class home extends StatefulWidget {
  @override
  State<home> createState() => _home();
}

class _home extends State<home> {
  Image tmp = Image.asset("img/sinya_1.png");
  String now_clock = "";

  var now = DateTime.now();

  int tmp_hour = 12;

  int hour = 0;
  int minute = 0;
  int day = 0;
  int month = 0;
  int second = 0;

  now_time() {
    Timer.periodic(
        const Duration(seconds: 1) //10minuteに変更必須
        , (timer) {
      setState(() {
        now = DateTime.now();
        month = now.month;
        day = now.day;
        hour = now.hour;
        minute = now.minute;
        second = now.second;
        now_clock = month.toString().padLeft(2, "0") +
            "月" +
            day.toString().padLeft(2, "0") +
            "日　" +
            hour.toString().padLeft(2, "0") +
            ":" +
            minute.toString().padLeft(2, "0") +
            ":" +
            second.toString().padLeft(2, "0");
      });
    });
  }

  void timer() {
    change_img() {
      //時間ごとにどの画像を使用するかの決定
      var random = math.Random();
      if (0 <= hour && hour <= 5) {
        int index = random.nextInt(3);
        setState(() {
          tmp = Image.asset('img/sinya_$index.png');
        });
      } else if (6 <= hour && hour <= 11) {
        int index = random.nextInt(7);
        setState(() {
          tmp = Image.asset('img/asa_$index.png');
        });
      } else if (12 <= hour && hour <= 14) {
        int index = random.nextInt(7);
        setState(() {
          tmp = Image.asset('img/hiru_$index.png');
        });
      } else if (15 <= hour && hour <= 18) {
        int index = random.nextInt(8);
        setState(() {
          tmp = Image.asset('img/yuu_$index.png');
        });
      } else if (19 <= hour && hour <= 23) {
        int index = random.nextInt(7);
        setState(() {
          tmp = Image.asset('img/yoru_$index.png');
        });
      }
    }

    if (tmp_hour != hour) {
      change_img(); //画像の変更
      tmp_hour = hour;
    }
  }

  img() {
    now_time();
    timer();
    return tmp;
  }

  clock_now() {
    now_time();
    return now_clock;
  }

  Widget build(BuildContext context) {
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
                  "ユーザー名", //firebaseで後ほど
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Time(),
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
