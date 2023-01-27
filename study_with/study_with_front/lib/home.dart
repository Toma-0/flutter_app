import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'home.dart';
import "sin_in.dart";

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
Image tmp = Image.asset("img/shinya_1.png");

  Widget build(BuildContext context) {
    time() {
      var now = DateTime.now();
      int hour = now.hour;
      return hour;
    }


    time_img() {
      Timer.periodic(
          const Duration(seconds: 1) //10minuteに変更必須
          , (timer) {
      int hour = time();
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
      });
    }

    return Scaffold(
      body: Center(child:Container(
        child: tmp,
      )),
    );
  }
}
