import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'home.dart';
import "sin_in.dart";

import 'config/size_config.dart';
import 'config/color_config.dart';

//アプリの大まかな構成。
//今回はロゴのみ
class Sign_up extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: sign_up(),
    );
  }
}

class sign_up extends StatefulWidget {
  @override
  State<sign_up> createState() => _sign_up();
}

class _sign_up extends State<sign_up> {
  String email = "";
  String pass = "";
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color:Color.fromARGB(255, 118, 161, 184),
            width: Size.w! * 1,),
          ),
          width: Size.w! * 70,
          child:Padding(padding: EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.mail),
                  labelText: "メールアドレス",
                ),
                onChanged: (text) {
                  setState(() {
                    email = text;
                  });
                }),
            TextField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.key),
                  labelText: "パスワード",
                ),
                style: TextStyle(color: colors().sub),
                onChanged: (text) {
                  setState(() {
                    pass = text;
                  });
                },
                obscureText: true),
            Padding(padding: EdgeInsets.only(top: Size.h! * 7)),
            OutlinedButton(
              child: const Text("ログイン"),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 118, 161, 184)),
              ),
              onPressed: () {
                mail_pass(email, pass);
              },
            ),
            TextButton(
              child: const Text('アカウントをお持ちの方はこちらから'),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 62, 58, 58)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Sign_in(),
                  ),
                );
              },
            ),
          ]),
          ),
        ),
      ),
    );
  }

  void mail_pass(mail_add, pass) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: mail_add, password: pass);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        print('メールアドレスが無効です');
      } else if (e.code == 'user-not-found') {
        print('そのメールアドレスは利用されていないようです。');
      } else if (e.code == 'wrong-password') {
        print('パスワードが間違っているようです。');
      } else {
        print("何か重大なエラーが起きています。制作者に連絡してください。");
      }
    }
  }
}
