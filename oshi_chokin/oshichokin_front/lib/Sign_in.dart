import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'dart:async';

// ...
void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Sign_in());
}

class Sign_in extends StatelessWidget {
  const Sign_in({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'OshiChokin',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Container());
  }
}