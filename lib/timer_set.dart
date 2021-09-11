import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_animetiontest/clock.dart';
import 'package:intl/intl.dart';
import 'package:flutter_picker/flutter_picker.dart';



class TimerSet extends StatefulWidget { // 状態を持ちたいので StatefulWidget を継承
  @override
  _TimerSet createState() => _TimerSet();
}

class _TimerSet extends State<TimerSet> {
  late Timer _timer; // この辺が状態
  late DateTime _time;

  @override
  void initState() { // 初期化処理
    _time = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) { // setState() の度に実行される
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            DateFormat.Hm().format(_time),
            style: Theme.of(context).textTheme.headline2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                onPressed: () { // Startボタンタップ時の処理
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Clock(
                    passedTime: _time,
                  )));
                },
                child: Text("Set"),
              ),
              FloatingActionButton(
                child: Text('edit'),
                onPressed: () async {
                  Picker(
                    adapter: DateTimePickerAdapter(type: PickerDateTimeType.kHM, value: _time, customColumnType: [3, 4]),
                    title: Text("Select Time"),
                    onConfirm: (Picker picker, List value) {
                      setState(() => {_time = DateTime.utc(0, 0, 0, value[0], value[1],0)});
                    },
                  ).showModal(context);
                },
              ),
            ],
          )
        ]);
  }
}
