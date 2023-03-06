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
    if (picked != null && picked != selectedDate)
   
        selectedDate = picked;
      
  }

  void _saveData(ref,oshi,nyuusyutu) async {
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
            .collection(nyuusyutu);
        await docRef.add(data);

        final oshiRef = db
            .collection("users")
            .doc(user_id)
            .collection("oshi")
            .doc(oshi);

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

  _form(List list,Color oshicolor,context,y) {

      return Form(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: y / 8,
              child: TextField(
                controller: _date, // 選択した日付を表示するテキストフィールド
                onTap: () => _selectDate(context), // タップした時に日付を選ぶダイアログを表示
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.calendar_today, color: oshicolor),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: oshicolor),
                    ),
                    labelText: '日付'),
              ),
            ),

            SizedBox(
              height: y / 8,
              child: TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.favorite, color: oshicolor),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: oshicolor),
                    ),
                    labelText: 'タイトル'),
              ),
            ),

            SizedBox(
              height: y / 8,
              child: TextFormField(
                controller: moneyController,
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: oshicolor),
                    ),
                    prefixIcon: Icon(Icons.attach_money, color: oshicolor),
                    labelText: '金額'),
              ),
            ),

            SizedBox(
              height: y * 4 / 8,
              child: TextFormField(
                maxLines: 10,
                controller: contentsController,
                decoration: InputDecoration(
                    prefixIcon:
                        Icon(Icons.chat_bubble_outline, color: oshicolor),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: oshicolor),
                    ),
                    labelText: '萌え語り',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: y * 4 / 8 - 10)),
              ),
            ),
          ],
        ),
      );
    }
  }
