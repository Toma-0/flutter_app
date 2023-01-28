import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'home.dart';
import "sign_up.dart";
import 'config/size_config.dart';

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
  bool view = false;
  

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
    
    Size().init(context);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Color.fromARGB(255, 118, 161, 184),
                width: Size.w! * 1,
              ),
            ),
            width: Size.w! * 70,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextField(
                    autofocus: true,
                    decoration:  InputDecoration(
                      icon: Icon(Icons.mail),
                      labelText: "メールアドレス",
                    ),
                    onChanged: (text) {
                      setState(() {
                        email = text;
                      });
                    }),
                TextField(
                  decoration:  InputDecoration(
                    icon: Icon(Icons.key),
                    labelText: "パスワード",
                    
                    suffixIcon: IconButton(
                      icon: Icon(
                          view ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                         view = !view;
                        });
                      },
                    ),
                    
                  ),
                  
                  style: TextStyle(color: Color.fromARGB(255, 62, 58, 58)),
                  onChanged: (text) {
                    setState(() {
                      pass = text;
                    });
                  },
                  obscureText: view
                ),
                Padding(padding: EdgeInsets.only(top: Size.h! * 7)),
                OutlinedButton(
                  child:  Text("新規作成"),
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
                        builder: (context) => Sign_up(),
                      ),
                    );
                  },
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
