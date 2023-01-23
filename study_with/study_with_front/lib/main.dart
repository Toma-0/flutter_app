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
  //処理部分を作成する。今回作成する処理は3点である。
  //ユーザーの現在のログイン状態を確認する
  //数秒停止する
  //ユーザーが向かうべきページに移行する。

  @override
  void state_User() {//ユーザー状態と画面の遷移
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

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(),
    );
  }
}
