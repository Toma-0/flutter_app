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
import 'info/oshi_images.dart';

import 'setting.dart';
import "syukkin.dart";
import "chokin.dart";

class Oshi extends ConsumerStatefulWidget {
  final String oshi;

  Oshi({Key? key, required this.oshi}) : super(key: key);

  @override
  _Oshi createState() => _Oshi();
}

class _Oshi extends ConsumerState<Oshi> with SingleTickerProviderStateMixin {
  
  late List indexList = ref.read(oshiIndexProvider);
  late List oshiList = ref.read(oshiListProvider);
  late List goalList = ref.read(oshiGoalMoneyProvider);
  late List sumList = ref.read(oshiSumMoneyProvider);
  late Map<int, Map<int, List<String>>> imageList =
      ref.read(oshiImageListProvider);

  late List colorList = ref.read(oshiColorProvider);
  late List iconList = ref.read(oshiIconNameProvider);

  bool tap = true;
  late String user_id = "test";

  // `ref.read` 関数 == Reader クラス
  double x = Size.w! * 25;
  double y = Size.h! * 25;
  IconData? oshiIcon = Icons.settings;

  late AnimationController waveController = AnimationController(
    duration: const Duration(seconds: 10), // アニメーションの間隔を3秒に設定
    vsync: this, // おきまり
  )..repeat();

  Widget build(BuildContext context) {
    print("buildWidgetでは$imageList");
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
            widget.oshi,
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
        body: GestureDetector(onTap: () {}, child: tapWidget()),
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
    int index = indexList[oshiList.indexOf(widget.oshi)];
    int? goal = goalList[index];
    int? sum = sumList[index];
    Map<int, List<String>>? imageMap = imageList[index];
    
    String colorSt = "FF" + colorList[index];
    Color Oshicolor = Color(int.parse(colorSt, radix: 16));

    List<String>? image = imageMap?[index];

    print("tapWidgetでは$imageList :listは$image でインデックスは$index");

    late int number;
    String oshiName = oshiList[index];

    if (imageMap != null) {
      number = imageMap.length;
    } else {
      number = 0;
    }

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

            donuts().chart(sum ?? 0, goal ?? 0, x, y,Oshicolor),
            makeWave().wave(waveController, x, y, ref,Oshicolor),

            Container(
              width: 115,
              height: 115,
              alignment: AlignmentDirectional.center,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                        width: 115,
                        height: 115,
                        child: Column(
                          children: [
                            Text("$oshiName専用貯金"),
                            Text("$sum 円/ $goal 円"),
                          ],
                        )),

                    for (int i = 0; i < image!.length; i++)
                      Image.network(image[i], width: 115, height: 115),
                    Container(
                        width: 115,
                        height: 115,
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SyukkinPage(oshi:widget.oshi)),
                            );
                          },
                          icon: Icon(Icons.payments, size: 115,color:Oshicolor),
                        )),

                    Container(
                        width: 115,
                        height: 115,
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChokinPage(oshi:widget.oshi)),
                            );
                          },
                          icon: Icon(Icons.savings, size: 115,color:Oshicolor),
                        )),

                    Container(
                        width: 115,
                        height: 115,
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.date_range, size: 115,color:Oshicolor),
                        )),

                    Container(
                        width: 115,
                        height: 115,
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.favorite, size: 115,color:Oshicolor),
                        )),

                    Container(
                      width: 115,
                      height: 115,
                      child: IconButton(
                          onPressed: () {
                            ImageSet().upload(oshiList[index], user_id, ref);
                          },
                          icon: Icon(Icons.image, size: 115, fill: 1.0,color:Oshicolor)),
                    )
                    //oshi_button(),
                  ],
                ),
              ),
            ),
          ]));
    }
  }

  @override
  void dispose() {
    waveController.dispose(); // AnimationControllerは明示的にdisposeする。
    super.dispose();
  }
}
