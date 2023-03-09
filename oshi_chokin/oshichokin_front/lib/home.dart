import 'state/import.dart';

// 設定と推し関連のクラスのインポート
import 'setting.dart';
import "oshi.dart";



class Home extends ConsumerStatefulWidget {
  @override
  _ATMState createState() => _ATMState();
}

class _ATMState extends ConsumerState<Home>
    with SingleTickerProviderStateMixin {
  // タップ状態
  bool tap = false;

  // oshiのアイコンや位置
  IconData? oshiIcon = Icons.settings;
  double x = WindowSize.w! * 25;
  double y = WindowSize.h! * 25;

  // Waveアニメーション制御用のコントローラー
  late AnimationController waveController = AnimationController(
    duration: const Duration(seconds: 10),
    vsync: this,
  )..repeat();

  @override
  Widget build(BuildContext context) {
    // 状態(State)の変更を監視して表示を更新
    final userName = ref.watch(userNameProvider).toString();
    final oshiColor = ref.watch(oshiColorProvider);
    final oshiIconName = ref.watch(oshiIconNameProvider);

    // サイズ設定の初期化
    WindowSize().init(context);
    setState(() {
      x = WindowSize.w! * 25;
      y = WindowSize.h! * 25;
    });

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          foregroundColor: Color.fromARGB(255, 62, 58, 58),
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          elevation: 0.0,
          // AppBar内左端の表示設定

          // AppBar内右端（設定）の表示設定
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
            child: tapWidget()), //タップ時の表示切り替え
      ),
    );
  }

  // oshiアイコン名から対応するアイコン設定へのマッピング
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

  Widget tapWidget() {
    // Widget を返すように修正

    // ユーザー名、目標金額、貯金金額、推しリストを取得
    final userName = ref.watch(userNameProvider).toString();
    final goal_money = ref.watch(goalMoneyProvider);
    final sum_money = ref.watch(sumMoneyProvider);
    final oshi_list = ref.watch(oshiListProvider) as List<dynamic>;
    late List taplist = [];
    late List nontaplist = [];

    if (tap) {
      for (int i = 0; i < oshi_list.length; i++)
        taplist.add(parts().oshiButton(i, ref, context));

      return Align(
          alignment: Alignment.center,
          child: Stack(alignment: AlignmentDirectional.center, children: [
            //firebaseから目標金額と貯金金額を持ってくる

            // 貯金率グラフ（ドーナツチャート）を表示
            donuts().chart(
                sum_money, goal_money, x, y, Color.fromARGB(255, 62, 58, 58)),

            // アニメーションする波を生成
            makeWave().wave(
                waveController, x, y, ref, Color.fromARGB(255, 62, 58, 58)),

            // 推しリストのボタンを水平スクロールで表示
            fild().makefild(taplist, x, y),
          ]));
    } else {
      // タップされていない場合のウィジェット表示
      nontaplist.add(parts().name(userName));
      nontaplist.add(parts().money(sum_money,goal_money));

      return Align(
          alignment: Alignment.center,
          child: Stack(alignment: AlignmentDirectional.center, children: [
            donuts().chart(
                sum_money, goal_money, x, y, Color.fromARGB(255, 62, 58, 58)),

            // アニメーションする波を生成
            makeWave().wave(
                waveController, x, y, ref, Color.fromARGB(255, 62, 58, 58)),
            
            fild().makefild(nontaplist, x, y),
          ]));
    }
  }

// dispose処理
  @override
  void dispose() {
    waveController.dispose(); // AnimationControllerは明示的にdisposeする。
    super.dispose();
  }
}
