import "package:cloud_firestore/cloud_firestore.dart";
import 'package:firebase_auth/firebase_auth.dart';

class firebase_data {
  String name = "";
  int goal_money = 0;


  void userInfo() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        var user_id = user.uid;
        var data;
        var db = FirebaseFirestore.instance;

        final docRef = db.collection("users").doc(user_id);

        docRef.get().then(
          (ref) {
            name = ref.get("name");
            goal_money = ref.get("goal_money");
          },
          onError: (e) => print("Error getting document: $e"),
        );
      } else {
        name = "test";
      }
    });
  }

}
