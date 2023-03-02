import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'config/size_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'setting.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'home.dart';
import 'sign_in.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ProviderScope(
        child: MaterialApp(
      home:MyApp(),
    )),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> with SingleTickerProviderStateMixin {
  @override
  void dispose() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        print("sign_in");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Sign_in(),
          ),
        );
      } else {
        print("home");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Home(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size().init(context);
    double x = Size.w! * 25;
    double y = Size.h! * 25;
    dispose();

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
    );
  }
}
