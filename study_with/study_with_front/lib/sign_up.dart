import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:firebase_auth/firebase_auth.dart';

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
            ElevatedButton(
              child: const Text('Button'),
              onPressed: () {
                mail_pass(email, pass);
              },
            ),
          ]),
        ),
      ),
    );
  }

  void mail_pass(mail_add, pass) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: mail_add, password: pass);
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
