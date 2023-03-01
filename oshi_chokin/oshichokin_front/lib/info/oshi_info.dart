import "package:cloud_firestore/cloud_firestore.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OshiInformation {
  static String? color;
  static String? icon;
  static int? goal;
  static int? sum;

  void oshiInfo(oshi_name) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        var user_id = user.uid;
        var data;
        var db = FirebaseFirestore.instance;

        final docRef = db
            .collection("users")
            .doc(user_id)
            .collection("oshi")
            .doc(oshi_name);

        docRef.get().then(
          (ref) {
            color = "FF" + ref.get("color");
            icon = ref.get("icon");
            goal = ref.get("goal_money");
            sum = ref.get("sum_money");
          },
          onError: (e) => print("Error getting document: $e"),
        );
      } else {}
    });
  }
}
