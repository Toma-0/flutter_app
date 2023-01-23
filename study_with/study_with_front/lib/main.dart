import 'package:flutter/material.dart';
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'sign_up.dart';
import 'home.dart';

void main() async {
  runApp(const MyApp());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
            builder: (context) => Sign_up(),
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
  void dispose(){
    super.dispose();
    timer?.cancel();
  }

  Widget build(BuildContext context) {
    loadtime();
    return Scaffold(
      body: Center(child: Text("とりま")),
    );
  }
}
