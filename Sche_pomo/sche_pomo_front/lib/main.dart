import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

DateTime _focusedDay = DateTime.now();



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: TableCalendar(
            firstDay: DateTime.utc(2002, 4, 1),
            lastDay: DateTime.utc(2025, 12, 31),
            focusedDay: _focusedDay),
      ),
    );
  }
}
