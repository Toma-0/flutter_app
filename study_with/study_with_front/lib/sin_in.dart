import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'home.dart';
import "sign_up.dart";

//新しくユーザーを作成する画面

class Sign_in extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: sign_in(),
    );
  }
}

class sign_in extends StatefulWidget {
  @override
  State<sign_in> createState() => _sign_in();
}

class _sign_in extends State<sign_in> {
  String email = "";
  String pass = "";

  void mail_pass(mail_ad, pass) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: mail_ad,
        password: pass,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('そのパスワードは脆弱性があるため利用できません');
      } else if (e.code == 'email-already-in-use') {
        print('そのメールアドレスはすでに利用されているようです。');
      } else {
        print("アカウント作成に重大なエラーが起こりました。作成者に連絡してください。");
      }
    } catch (e) {
      print(e);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(children: [
            TextField(onChanged: (text) {
              setState(() {
                email = text;
              });
            }),
            TextField(
                onChanged: (text) {
                  setState(() {
                    pass = text;
                  });
                },
                obscureText: true),
            // Flutter1.22以降のみ
            ElevatedButton(
              child: const Text('Button'),
              onPressed: () {
                mail_pass(email, pass);
              },
            ),
            ElevatedButton(
              child: const Text('Button'),
              onPressed: () {
                MaterialPageRoute(
                  builder: (context) => Sign_up(),
                );
              },
            ),
          ]),
        ),
      ),
    );
  }
}
