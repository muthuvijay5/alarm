import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

List<DateTime> alarms = [];
List<Widget> alarmTexts = [];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController dateString = TextEditingController();

  void playSound() async {
    final sound = AudioPlayer();
    await sound.play(AssetSource('note1.wav'));
  }

  void checkAlarmTime(DateTime alarmTime) {
    DateTime currentTime = DateTime.now();
    if (currentTime.day == alarmTime.day &&
        currentTime.year == alarmTime.year &&
        currentTime.month == alarmTime.month &&
        currentTime.hour == alarmTime.hour &&
        currentTime.minute == alarmTime.minute) {
      playSound();
    }
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        for (DateTime alarmTime in alarms) {
          checkAlarmTime(alarmTime);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            children: alarmTexts +
                [
                  TimeField(dateString),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
                    child: ElevatedButton(
                        onPressed: () {
                          String timeString = dateString.text;
                          List<String> timeList = timeString.split("-");
                          List<int> timeIntList =
                              timeList.map(int.parse).toList();
                          alarmTexts.add(Padding(
                            padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
                            child: Text(dateString.text),
                          ));
                          DateTime dateTime = DateTime(
                              timeIntList[0],
                              timeIntList[1],
                              timeIntList[2],
                              timeIntList[3],
                              timeIntList[4],
                              0,
                              0,
                              0);
                          alarms.add(dateTime);
                          dateString.text = "";
                        },
                        child: Text("Set Alarm")),
                  ),
                ],
          ),
        ),
      ),
    );
  }
}

class TimeField extends StatefulWidget {
  TextEditingController controller;
  TimeField(this.controller, {super.key});

  @override
  State<TimeField> createState() => _TimeFieldState();
}

class _TimeFieldState extends State<TimeField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
      child: TextField(
        controller: widget.controller,
        decoration: const InputDecoration(
          hintText: "YYYY-MM-DD-HH-MM",
          labelText: "Alarm time",
          border: null,
        ),
      ),
    );
  }
}
