import 'package:flutter/material.dart';
import 'package:flutter_app_animetiontest/timer_set.dart';
import 'timer_set.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          title: Text('起きる時間を設定してね'),
        ),
        body: TimerSet(),
      ),
    );
  }
}







