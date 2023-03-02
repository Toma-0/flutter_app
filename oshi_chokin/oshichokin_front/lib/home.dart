import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'config/size_config.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:cloud_firestore/cloud_firestore.dart";

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'setting.dart';
import "oshi.dart";

import 'parts/donutsChart.dart';
import 'parts/waveAnime.dart';
import 'info/user_info.dart';
import 'info/oshi_info.dart';

final userNameProvider = StateProvider((ref) => 'Hello World');

final goalMoneyProvider = StateProvider((ref) => 0);

final sumMoneyProvider = StateProvider((ref) => 0);

final oshiListProvider = StateProvider((ref) => []);

final oshiColorProvider = StateProvider((ref) => []);

final oshiIconNameProvider = StateProvider((ref) => []);

final oshiGoalMoneyProvider = StateProvider((ref) => []);

final oshiSumMoneyProvider = StateProvider((ref) => []);

final oshiImageListProvider = StateProvider((ref) => []);

//The following RangeError was thrown building Home(dirty, dependencies: [MediaQuery,
//UncontrolledProviderScope], state: _ATMState#39565(ticker active)):
//RangeError (index): Invalid value: Valid value range is empty: 0

class Home extends ConsumerStatefulWidget {
  @override
  _ATMState createState() => _ATMState();
}

class _ATMState extends ConsumerState<Home>
    with SingleTickerProviderStateMixin {
  bool tap = false;

  // `ref.read` 関数 == Reader クラス
  IconData? oshiIcon = Icons.settings;
  double x = Size.w! * 25;
  double y = Size.h! * 25;

  late AnimationController waveController = AnimationController(
    duration: const Duration(seconds: 10), // アニメーションの間隔を3秒に設定
    vsync: this, // おきまり
  )..repeat();

  // AnimationControllerの宣言

  @override
  Widget build(BuildContext context) {
    final userName = ref.watch(userNameProvider).toString();
    final oshiColor = ref.watch(oshiColorProvider).toString();
    final oshiIconName = ref.watch(oshiIconNameProvider).toString();

    UserInformation().userInfo(ref);

    Size().init(context);
    setState(() {
      x = Size.w! * 25;
      y = Size.h! * 25;
    });

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          foregroundColor: Color.fromARGB(255, 62, 58, 58),
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          elevation: 0.0,
          leadingWidth: Size.w! * 25,

          //ユーザー名

          leading: Text(
            //firebaseから持ってくる
            userName,
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
      ),
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
    final userName = ref.watch(userNameProvider).toString();
    final goal_money = ref.watch(goalMoneyProvider);
    final sum_money = ref.watch(sumMoneyProvider);
    final oshi_list = ref.watch(oshiListProvider) as List<dynamic>;

    if (tap) {
      return Align(
          alignment: Alignment.center,
          child: Stack(alignment: AlignmentDirectional.center, children: [
            //firebaseから目標金額と貯金金額を持ってくる

            donuts().chart(sum_money, goal_money, x, y),
            makeWave().wave(waveController, x, y, ref),

            Container(
              width: 115,
              height: 115,
              alignment: AlignmentDirectional.center,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (var i = 0; i < oshi_list.length; i++) oshi_button(i),
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
            donuts().chart(sum_money, goal_money, x, y),
            makeWave().wave(waveController, x, y, ref),
          ]));
    }
  }

  //推しごとのボタンの作成
  oshi_button(i) {
    final oshi_list = ref.watch(oshiListProvider) as List<dynamic>;
    OshiInformation().oshiInfo(oshi_list, ref);

    final oshiColor = ref.read(oshiColorProvider);
    final iconName = ref.read(oshiIconNameProvider);

    String color = "FF" + oshiColor[i];
    
    IconSetting(iconName[i]);
    return Stack(children: [
      IconButton(
        iconSize: 100,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Oshi(i:i)),
          );
        },
        icon: Icon(
          oshiIcon,
          color: Color(int.parse(color, radix: 16)),
        ),
      ),
      Text(oshi_list[i])
    ]);
  }

  @override
  void dispose() {
    waveController.dispose(); // AnimationControllerは明示的にdisposeする。
    super.dispose();
  }
}
