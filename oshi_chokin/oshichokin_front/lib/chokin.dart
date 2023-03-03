import 'package:flutter/material.dart';
import 'dentak.dart';
import 'button.dart';

class ChokinPage extends StatefulWidget {
  @override
  State<ChokinPage> createState() => _ChokinPage();
}

class _ChokinPage extends State<ChokinPage> {
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
            ),
            child: Container(
              child: Text(
                '<',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            onPressed: () {
              // 1つ前に戻る
              Navigator.pop(context);
            },
          ),
          title: Text("次のページ"),
        ),
        body: makeForm(),
      ),
    );
  }

  makeForm() {
    return Container();
  }
}
