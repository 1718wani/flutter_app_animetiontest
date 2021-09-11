import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:share/share.dart';

class Clock extends StatefulWidget {
  final DateTime ?passedTime;
  const Clock(
      {Key ?key, this.passedTime}) :super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ClockState();
  }
}


class _ClockState extends State<Clock> {
  String _time = '';
  final Alarm _alarm = new Alarm();
  bool _cancelIsVisible = true;
  bool _stopIsVisible = false;
  bool isAlarmStop = false;
  var formatterFor = DateFormat('HH:mm');

  @override
  void initState() {
    Timer.periodic(
      Duration(seconds: 1),
      _onTimer,
    );
    Timer.periodic(
      Duration(seconds: 10),
      switchScreen,
    );
    super.initState();
  }

  void _onTimer(Timer timer) {
    var now = DateTime.now();
    var formatter = DateFormat('HH:mm');
    var formattedTime = formatter.format(now);
    setState(() => _time = formattedTime);
  }

  // 今の時刻が設定した時間になったら、スクリーンを変えていく。
  void switchScreen(Timer timer){
    // 時刻が一致したら、visbleを変えていく
    if (DateTime.now().minute == widget.passedTime!.minute && isAlarmStop == false){
      setState(() {
        _cancelIsVisible = false;
        _stopIsVisible = true;
      });
      _alarm.start();
    }
    // 時刻が一致したら、Alarmがなる
  }


  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        "明日${formatterFor.format(widget.passedTime!)}に起きてください",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            decoration: TextDecoration.none,
          )
      ),
      Text(
        _time,
          style: TextStyle(
              color: Colors.white,
              fontSize: 70,
              decoration: TextDecoration.none,
          )
      ),
      Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Visibility(child:FloatingActionButton(
          child: Text('Cancel'),
          onPressed: ()  {
            Navigator.of(context).pop();
          },
        ),
          visible: _cancelIsVisible,
        ),
        Visibility(
          child: FloatingActionButton(
            child: Text('Stop'),
            onPressed: ()  {
              _alarm.stop();
              isAlarmStop = true;
              showDialog(
                  context: context,
                  builder: (_) => CupertinoAlertDialog(
                    title: Text("おはようございます！"),
                    content: Text("今朝起きた時刻をShareしますか？"),
                    actions: [
                      CupertinoDialogAction(
                          child: Text('Cancel'),
                          isDestructiveAction: true,
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          }),
                      CupertinoDialogAction(
                        child: Text('Share'),
                          onPressed: ()  {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            String sendMsg = "今日は${_time}におきたよ！";
                            String url = Uri.encodeFull("twitter://post?message=" + sendMsg);
                            launch(url);
                            // Navigator.of(context).pop();
                          },
                      )
                    ],
                  ));
            },
          ),
          visible: _stopIsVisible,
        ),
      ],
    )]);
  }
}

class Alarm {
  late Timer _timer;

  /// アラームをスタートする
  void start() {
    FlutterRingtonePlayer.playAlarm(volume: 0.01);
    if (Platform.isIOS) {
      _timer = Timer.periodic(
        Duration(seconds: 2),
            (Timer timer) => {FlutterRingtonePlayer.playAlarm()},
      );
    }
  }

  /// アラームをストップする
  void stop() {
    if (Platform.isAndroid) {
      FlutterRingtonePlayer.stop();
    } else if (Platform.isIOS) {
      if (_timer != null && _timer.isActive) _timer.cancel();
    }
  }
}