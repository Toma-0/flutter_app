import 'package:flutter/material.dart';
import "../state/state.dart";
import 'package:firebase_auth/firebase_auth.dart';
import "package:cloud_firestore/cloud_firestore.dart";

class form {
  final titleController = TextEditingController();
  final moneyController = TextEditingController();
  final contentsController = TextEditingController();
  final _date = TextEditingController();
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2021),
        lastDate: DateTime(2222));
    if (picked != null && picked != selectedDate) selectedDate = picked;
  }

  void nyukin(ref, oshi) async {
    final title = titleController.text;
    final money = int.parse(moneyController.text);
    final contents = contentsController.text;
    final today = DateTime.now();
    final dateOnly = DateTime(today.year, today.month, today.day);

    Map<String, dynamic> data = {
      "created_at": dateOnly,
      "title": title,
      "money": money,
      "contents": contents
    };

    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        var db = FirebaseFirestore.instance;
        var user_id = user.uid;

        final docRef = db
            .collection("users")
            .doc(user_id)
            .collection("oshi")
            .doc(oshi)
            .collection("nyukin");
        await docRef.add(data);

        final oshiRef =
            db.collection("users").doc(user_id).collection("oshi").doc(oshi);

        oshiRef
            .update({'sum_money': FieldValue.increment(money)})
            .then((_) => print('Update success!'))
            .catchError((error) => print('Failed to update: $error'));

        final userRef = db.collection("users").doc(user_id);
        late List oshiList = ref.read(oshiListProvider);
        late List indexList = ref.read(oshiIndexProvider);
        int index = indexList[oshiList.indexOf(oshi)];
        List sumOshiList = ref.read(oshiSumMoneyProvider);

        sumOshiList[index] = sumOshiList[index] + money;
        ref.read(oshiSumMoneyProvider.notifier).update((state) => sumOshiList);

        int sum = ref.read(sumMoneyProvider);
        sum = sum + money;
        ref.read(sumMoneyProvider.notifier).update((state) => sum);

        userRef
            .update({'sum_money': FieldValue.increment(money)})
            .then((_) => print('Update success!'))
            .catchError((error) => print('Failed to update: $error'));
      } else {
        print("user:$user");
      }
    });
  }

  void syukkin(ref, oshi, nyuusyutu) async {
    final title = titleController.text;
    final money = int.parse(moneyController.text);
    final contents = contentsController.text;
    final today = DateTime.now();
    final dateOnly = DateTime(today.year, today.month, today.day);

    Map<String, dynamic> data = {
      "created_at": dateOnly,
      "title": title,
      "money": -money,
      "contents": contents
    };

    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        var db = FirebaseFirestore.instance;
        var user_id = user.uid;

        final docRef = db
            .collection("users")
            .doc(user_id)
            .collection("oshi")
            .doc(oshi)
            .collection("syukkin");
        await docRef.add(data);

        final oshiRef =
            db.collection("users").doc(user_id).collection("oshi").doc(oshi);

        oshiRef
            .update({'sum_money': FieldValue.increment(-money)})
            .then((_) => print('Update success!'))
            .catchError((error) => print('Failed to update: $error'));

        final userRef = db.collection("users").doc(user_id);
        late List oshiList = ref.read(oshiListProvider);
        late List indexList = ref.read(oshiIndexProvider);
        int index = indexList[oshiList.indexOf(oshi)];
        List sumOshiList = ref.read(oshiSumMoneyProvider);

        sumOshiList[index] = sumOshiList[index] - money;
        ref.read(oshiSumMoneyProvider.notifier).update((state) => sumOshiList);

        int sum = ref.read(sumMoneyProvider);
        sum = sum - money;
        ref.read(sumMoneyProvider.notifier).update((state) => sum);

        userRef
            .update({'sum_money': FieldValue.increment(-money)})
            .then((_) => print('Update success!'))
            .catchError((error) => print('Failed to update: $error'));
      } else {
        print("user:$user");
      }
    });
  }

  formList(
    List list,
  ) {
    return Form(
      child: Column(
        children: <Widget>[
          for (int i = 0; i < list.length; i++) list[i],
        ],
      ),
    );
  }

  _form(i, y, oshicolor, controller, icon, text) {
    return SizedBox(
      height: y,
      child: TextFormField(
        maxLines: i,
        controller: controller,
        decoration: InputDecoration(
            prefixIcon: Icon(icon, color: oshicolor),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: oshicolor),
            ),
            labelText: text,
            contentPadding: EdgeInsets.symmetric(vertical: y * 4 / 8 - 10)),
      ),
    );
  }
}
