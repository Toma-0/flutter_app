import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'config/size_config.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:cloud_firestore/cloud_firestore.dart";

import 'setting.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import "user_info.dart";

class Home extends StatefulWidget {
  @override
  _ATMState createState() => _ATMState();
}

class WaveClipper extends CustomClipper<Path> {
  // 1
  WaveClipper(this.context, this.waveControllerValue, this.offset) {
    final width = MediaQuery.of(context).size.width; // 画面の横幅
    final height = MediaQuery.of(context).size.height; // 画面の高さ

    // coordinateListに波の座標を追加
    for (var i = 0; i <= width * 10; i++) {
      final step = ((i / width) - waveControllerValue) * 8;
      coordinateList.add(
        Offset(
            i.toDouble() * 4, // X座標
            math.sin(step * 2 * math.pi - offset) * 3 +
                height * (1 - 7000 / 10000)
            // Y座標,0.2の部分を変えて高さを変更する
            ),
      );
    }
  }

  final BuildContext context;
  final double waveControllerValue; // waveController.valueの値
  final double offset; // 波のずれ
  final List<Offset> coordinateList = []; // 波の座標のリスト

  // 2
  @override
  Path getClip(size) {
    final path = Path()
      // addPolygon: coordinateListに入っている座標を直線で結ぶ。
      //             false -> 最後に始点に戻らない
      ..addPolygon(coordinateList, false)
      ..lineTo(size.width, size.height) // 画面右下へ
      ..lineTo(0, size.height) // 画面左下へ
      ..close(); // 始点に戻る
    return path;
  }

  // 3
  // 再クリップするタイミング -> animationValueが更新されていたとき
  @override
  bool shouldReclip(WaveClipper oldClipper) =>
      waveControllerValue != oldClipper.waveControllerValue;
}

class _ATMState extends State<Home> with SingleTickerProviderStateMixin {
  bool tap = false;
  String userName = "";
  int goal_money = 0;
  int sum_money = 0;

  late AnimationController waveController = AnimationController(
    duration: const Duration(seconds: 10), // アニメーションの間隔を3秒に設定
    vsync: this, // おきまり
  )..repeat();

  // AnimationControllerの宣言

  @override
  void dispose() {
    waveController.dispose(); // AnimationControllerは明示的にdisposeする。
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size().init(context);
    double x = Size.w! * 25;
    double y = Size.h! * 25;

    userInfo();

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
              print("tap");
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
          child: chokin(tap)),
    );
  }

  void userInfo() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        var user_id = user.uid;
        var data;
        var db = FirebaseFirestore.instance;

        final docRef = db.collection("users").doc(user_id);

        docRef.get().then(
          (ref) {
            setState(() {
              userName = ref.get("name");
              goal_money = ref.get("goal_money");
              sum_money = ref.get("sum_money");
            });
          },
          onError: (e) => print("Error getting document: $e"),
        );
      } else {
        userName = "test";
      }
    });
  }

  chokin(tap) {
    Size().init(context);
    double x = Size.w! * 25;
    double y = Size.h! * 25;

    if (tap) {
      if (x == Size.w! * 25) {
        setState(() {
          x = Size.w! * 23;
          y = Size.h! * 23;
        });
      } else {
        x = Size.w! * 25;
        y = Size.h! * 25;
      }
    }

    return tapWidget(x, y);
  }

  @override
  tapWidget(x, y) {
    if (tap) {
      return Align(
          alignment: Alignment.center,
          child: Stack(
            alignment: AlignmentDirectional.center, 
          children: [
            //firebaseから目標金額と貯金金額を持ってくる
  
            chart(x, y),
            wave(x, y),
            
          ]));
    } else {
      return Align(
          alignment: Alignment.center,
          child: Stack(alignment: AlignmentDirectional.center, children: [
            //firebaseから目標金額と貯金金額を持ってくる
            chart(x, y),
            
            wave(x, y),
            Container(
              width: 100,
              height: 100,
              alignment: AlignmentDirectional.center,

              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (var i = 0; i < 10; i++)
                      Container(
                        color: i.isEven ? Colors.blue : Colors.pink,
                        width: 100,
                        height: 100,
                      ),
                  ],
                ),
              ),
            ),
          ]));
    }
  }

  //並の作成
  @override
  wave(x, y) {
    return AnimatedBuilder(
      animation: waveController,
      builder: (context, child) => Stack(
        children: [
          ClipPath(
            child: Container(
              width: (Size.w! * (x - 60)) * 2,
              height: Size.h! * y!,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                shape: BoxShape.circle,
              ),
            ),
            clipper: WaveClipper(context, waveController.value, 0),
          ),
          ClipPath(
            child: Container(
              width: (Size.w! * (x - 60)) * 2,
              height: Size.h! * y!,
              decoration: BoxDecoration(
                color: Color.fromARGB(149, 255, 255, 255),
                shape: BoxShape.circle,
              ),
            ),
            clipper: WaveClipper(context, waveController.value, 0.6),
          ),
        ],
      ),
    );
  }

  //グラフの作成
  @override
  chart(x, y) {
    return Container(
      width: Size.w! * x,
      height: Size.h! * y,
      child: Stack(
        alignment: AlignmentDirectional.center,
        clipBehavior: Clip.none,
        children: [
          PieChart(
            PieChartData(
              startDegreeOffset: 270,
              centerSpaceRadius: Size.w! * (x - 60),
              centerSpaceColor: Color.fromARGB(255, 62, 58, 58),
              sections: [
                PieChartSectionData(
                  borderSide: BorderSide(width: 0),
                  color: Color.fromARGB(255, 62, 58, 58),
                  value: 7 / 10 * 100, //ここの値をfirebaseで変更
                  radius: Size.w! * 2,
                  title: '',
                ),
                PieChartSectionData(
                  borderSide: BorderSide(width: 0),
                  color: Colors.white,
                  value: 3 / 10 * 100, //ここの値をfirebaseで変更
                  radius: Size.w! * 2,
                  title: '',
                ),
              ],
              sectionsSpace: 0,
            ),
          ),
        ],
      ),
    );
  }
}
