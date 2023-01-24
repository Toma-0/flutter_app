import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'sin_in.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight])
      .then((_) {
    runApp(const MyApp());
  });
}

//アプリの大まかな構成。
//今回はロゴのみ
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Logo(),
    );
  }
}

class Logo extends StatefulWidget {
  @override
  State<Logo> createState() => _Logo();
}

class _Logo extends State<Logo> {
  Timer? timer;

  @override
  void state_User() {
    //ユーザー状態と画面の遷移
    FirebaseAuth.instance.idTokenChanges().listen((User? user) {
      //ユーザーがいるかどうかを問う
      if (user == null) {
        //ユーザーがいない時どこのページに行くか
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Sign_in(),
          ),
        );
      } else {
        //ユーザーがいる時どこのページに行くか
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Home(),
          ),
        );
      }
    });
  }

  void loadtime() {
    print("OK");
    timer = Timer(const Duration(seconds: 2), () {
      state_User(); //２秒後にユーザーの読み込みを行う。
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  Widget build(BuildContext context) {
    double fw = MediaQuery.of(context).size.width;
    double fh = MediaQuery.of(context).size.height;
    loadtime();
    return Scaffold(
      body: Center(child: Text("とりま")),
    );
  }
}
