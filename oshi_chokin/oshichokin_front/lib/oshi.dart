import 'package:flutter/material.dart';
import 'package:oshichokin_front/home.dart';
import 'config/size_config.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'parts/donutsChart.dart';
import 'parts/waveAnime.dart';
import 'info/user_info.dart';
import 'info/oshi_info.dart';

import 'setting.dart';

class Oshi extends ConsumerStatefulWidget {
  final int i;
  // コンストラクタ
  const Oshi({Key? key, required this.i}) : super(key: key);

  @override
  _Oshi createState() => _Oshi();
}

class _Oshi extends ConsumerState<Oshi> with SingleTickerProviderStateMixin {
  late int index;
  bool tap = false;

  // `ref.read` 関数 == Reader クラス
  double x = Size.w! * 25;
  double y = Size.h! * 25;
  IconData? oshiIcon = Icons.settings;
  void initState() {
    super.initState();
    index = widget.i;
  }

  late AnimationController waveController = AnimationController(
    duration: const Duration(seconds: 10), // アニメーションの間隔を3秒に設定
    vsync: this, // おきまり
  )..repeat();

  Widget build(BuildContext context) {
    List oshiList = ref.read(oshiListProvider);

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
            oshiList[index],
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
    List goalList = ref.read(oshiGoalMoneyProvider);
    List sumList = ref.read(oshiSumMoneyProvider);

    int goal = goalList[index];
    int sum = sumList[index];
    final oshi_list = ref.watch(oshiListProvider) as List<dynamic>;

    Size().init(context);
    setState(() {
      x = Size.w! * 25;
      y = Size.h! * 25;
    });

    if (tap) {
      return Align(
          alignment: Alignment.center,
          child: Stack(alignment: AlignmentDirectional.center, children: [
            //firebaseから目標金額と貯金金額を持ってくる

            donuts().chart(sum, goal, x, y),
            makeWave().wave(waveController, x, y, ref),

            Container(
              width: 115,
              height: 115,
              alignment: AlignmentDirectional.center,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    oshi_button(),
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
            donuts().chart(sum, goal, x, y),
            makeWave().wave(waveController, x, y, ref),
          ]));
    }
  }

  //推しごとのボタンの作成
  oshi_button() {
    List colorList = ref.read(oshiColorProvider);
    List iconList = ref.read(oshiIconNameProvider);
    String color = "FF" + colorList[index];
    String icon = iconList[index];
    List oshiList = ref.read(oshiListProvider);

    IconSetting(icon);
    return Stack(children: [
      IconButton(
        iconSize: 100,
        onPressed: () {},
        icon: Icon(
          oshiIcon,
          color: Color(int.parse(color, radix: 16)),
        ),
      ),
      Text(oshiList[index])
    ]);
  }

  @override
  void dispose() {
    waveController.dispose(); // AnimationControllerは明示的にdisposeする。
    super.dispose();
  }
}
