import "state/import.dart";

import 'setting.dart';
import "syukkin.dart";
import "chokin.dart";
import "calender.dart";
import "button.dart";

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
  double x = WindowSize.w! * 25;
  double y = WindowSize.h! * 25;
  IconData? oshiIcon = Icons.settings;

  late AnimationController waveController = AnimationController(
    duration: const Duration(seconds: 10), // アニメーションの間隔を3秒に設定
    vsync: this, // おきまり
  )..repeat();

  Widget build(BuildContext context) {
    int index = indexList[oshiList.indexOf(widget.oshi)];
    String colorSt = "FF" + colorList[index];
    Color Oshicolor = Color(int.parse(colorSt, radix: 16));
    print("buildWidgetでは$imageList");
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          foregroundColor: Color.fromARGB(255, 62, 58, 58),
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          elevation: 0.0,
          leadingWidth: WindowSize.w! * 25,

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
            parts()
                .iconbutton(Icons.settings, Navi().setting(context), Oshicolor)
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
    num goal = goalList[index];
    num sum = sumList[index];
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

    WindowSize().init(context);
    setState(() {
      x = WindowSize.w! * 25;
      y = WindowSize.h! * 25;
    });

    return Align(
        alignment: Alignment.center,
        child: Stack(alignment: AlignmentDirectional.center, children: [
          //firebaseから目標金額と貯金金額を持ってくる

          donuts().chart(sum, goal, x, y, Oshicolor),
          makeWave().wave(waveController, x, y, ref, Oshicolor),

          Container(
            width: 115,
            height: 115,
            alignment: AlignmentDirectional.center,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  parts().name(oshiName, Oshicolor),
                  parts().money(sum, goal),
                  for (int i = 0; i < image!.length; i++)
                    Image.network(image[i], width: 115, height: 115),
                  parts().iconbutton(Icons.payments,
                      Navi().syukkin(context, widget.oshi), Oshicolor),
                  parts().iconbutton(Icons.home,
                      Navi().button(context, widget.oshi), Oshicolor),
                  parts().iconbutton(Icons.savings,
                      Navi().chokin(context, widget.oshi), Oshicolor),
                  parts().iconbutton(Icons.date_range,
                      Navi().calender(context, widget.oshi), Oshicolor),
                  parts().iconbutton(Icons.favorite,
                      Navi().sns(context, widget.oshi), Oshicolor),
                  parts().iconbutton(
                      Icons.image,
                      ImageSet().upload(oshiList[index], user_id, ref),
                      Oshicolor),
                ],
              ),
            ),
          ),
        ]));
  }

  @override
  void dispose() {
    waveController.dispose(); // AnimationControllerは明示的にdisposeする。
    super.dispose();
  }
}
