import "package:cloud_firestore/cloud_firestore.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:oshichokin_front/home.dart';

class OshiInformation {
  void oshiInfo(list, Wref) {
    List colorList = Wref.read(oshiColorProvider);
    List iconList = Wref.read(oshiIconNameProvider);
    List goalList = Wref.read(oshiGoalMoneyProvider);
    List sumList = Wref.read(oshiSumMoneyProvider);

    for (int i = 0; i < list.length; i++) {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user != null) {
          var user_id = user.uid;
          var data;
          var db = FirebaseFirestore.instance;

          final docRef = db
              .collection("users")
              .doc(user_id)
              .collection("oshi")
              .doc(list[i]);

          docRef.get().then(
            (ref) {
              String color = "FF" + ref.get("color");
              String icon = ref.get("icon");
              int goal = ref.get("goal_money");
              int sum = ref.get("sum_money");

              colorList.add(color);
              iconList.add(icon);
              goalList.add(goal);
              sumList.add(sum);

              Wref.read(oshiColorProvider.notifier)
                  .update((state) => colorList);
              Wref.read(oshiIconNameProvider.notifier)
                  .update((state) => iconList);
              Wref.read(oshiGoalMoneyProvider.notifier)
                  .update((state) => goalList);
              Wref.read(oshiSumMoneyProvider.notifier)
                  .update((state) =>sumList);
            },
            onError: (e) => print("Error getting document: $e"),
          );
        } else {}
      });
    }
  }
}
