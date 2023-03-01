import "package:cloud_firestore/cloud_firestore.dart";
import 'package:firebase_auth/firebase_auth.dart';


import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UserInformation {
  static String? userName;
  static int? goal_money;
  static int? sum_money;
  static List<dynamic>? oshi_list;
  
  void userInfo() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        var user_id = user.uid;
        var data;
        var db = FirebaseFirestore.instance;

        final docRef = db.collection("users").doc(user_id);

        docRef.get().then(
          (ref) {
            userName = ref.get("name");
            goal_money = ref.get("goal_money");
            sum_money = ref.get("sum_money");
            oshi_list = ref.get("oshi_name") as List<dynamic>;
          },
          onError: (e) => print("Error getting document: $e"),
        );
      } else {
        userName = "test";
      }
    });
  }
}
