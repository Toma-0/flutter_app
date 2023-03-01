import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'config/size_config.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'setting.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'info/user_info.dart';

import 'parts/donutsChart.dart';
import 'parts/waveAnime.dart';
import 'info/user_info.dart';
import 'info/oshi_info.dart';

class Home extends StatefulWidget {
  @override
  _ATMState createState() => _ATMState();
}

class _ATMState extends State<Home> with SingleTickerProviderStateMixin {
  bool tap = false;
  String? userName = "テスト";

  int? goal_money = 0;
  int? sum_money = 0;

  List<dynamic>? oshi_list = [];
  late IconData? oshiIcon = Icons.settings;
  double x = Size.w! * 25;
  double y = Size.h! * 25;

  String color = "000000";
  String icon = "Home";

  late AnimationController waveController = AnimationController(
    duration: const Duration(seconds: 10), // アニメーションの間隔を3秒に設定
    vsync: this, // おきまり
  )..repeat();

  // AnimationControllerの宣言

  @override
  Widget build(BuildContext context) {
    UserInformation().userInfo();
    Size().init(context);
    setState(() {
      x = Size.w! * 25;
      y = Size.h! * 25;
      userName = UserInformation.userName;
      goal_money = UserInformation.goal_money;
      sum_money = UserInformation.sum_money;
      oshi_list = UserInformation.oshi_list;
    });

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        foregroundColor: Color.fromARGB(255, 62, 58, 58),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        elevation: 0.0,
        leadingWidth: Size.w! * 25,

        //ユーザー名

        leading: Text(
          //firebaseから持ってくる
          userName ?? '',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
          ),
        ),

        //設定
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingPage()),
              );
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: GestureDetector(
          onTap: () {
            print(tap);
            setState(() {
              tap = !tap;
            });
          },
          child: tapWidget()),
    );
  }

  //user情報の取得、更新

  IconSetting(iconName) {
    Map<String, IconData> iconList = {
      "Home": Icons.home,
      "Build": Icons.build,
      "fire": Icons.local_fire_department,
    };

    setState(() {
      oshiIcon = iconList[iconName];
    });
  }

  //タップすると表示するものを変化するウィジェットを作成
  @override
  tapWidget() {
    if (tap) {
      return Align(
          alignment: Alignment.center,
          child: Stack(alignment: AlignmentDirectional.center, children: [
            //firebaseから目標金額と貯金金額を持ってくる

            donuts().chart(sum_money ?? 1, goal_money ?? 1, x, y),
            makeWave().wave(waveController, x, y),

            Container(
              width: 100,
              height: 100,
              alignment: AlignmentDirectional.center,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (var i = 0; i < oshi_list!.length; i++)
                      oshi_button(oshi_list![i]),
                  ],
                ),
              ),
            ),
          ]));
    } else {
      return Align(
          alignment: Alignment.center,
          child: Stack(alignment: AlignmentDirectional.center, children: [
            //firebaseから目標金額と貯金金額を持ってくる
            donuts().chart(sum_money ?? 1, goal_money ?? 1, x, y),
            makeWave().wave(waveController, x, y),
          ]));
    }
  }

  //推しごとのボタンの作成
  oshi_button(oshi_name) {
    OshiInformation().oshiInfo(oshi_name);
    setState(() {
      color = OshiInformation.color ?? "000000";
      icon = OshiInformation.icon ?? "Home";

      print(oshi_name+""+color + ":" + icon);
    });

    return Stack(children: [
      IconButton(
        iconSize: 100,
        onPressed: () {},
        icon: Icon(
          oshiIcon,
          color: Color(int.parse(color, radix: 16)),
        ),
      ),
      Text(oshi_name)
    ]);
  }

  @override
  void dispose() {
    waveController.dispose(); // AnimationControllerは明示的にdisposeする。
    super.dispose();
  }
}
