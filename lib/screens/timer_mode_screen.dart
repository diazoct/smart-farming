// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:circle_button/circle_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_aja/timer_model.dart';
import 'package:test_aja/widgets/container_title.dart';

class TimerMode extends StatefulWidget {
  const TimerMode({super.key});

  @override
  State<TimerMode> createState() => _TimerModeState();
}

class _TimerModeState extends State<TimerMode> {
  final DatabaseReference databaseReference =
      // ignore: deprecated_member_use
      FirebaseDatabase.instance.reference();

  String _formatDuration(int seconds) {
    int minutes = (seconds / 60).floor();
    int remainingSeconds = seconds % 60;
    return '$minutes min : $remainingSeconds sec';
  }

  Future<void> _showTimePickerSheet(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      int duration = pickedTime.hour * 60 + pickedTime.minute;
      context
          .read<TimerModel>()
          .setCountdownTime(duration * 60); // Konversi jam dan menit ke detik
      context.read<TimerModel>().startTimer();
      _saveModeToLocal();
      _showSuccessMessage(context);
    }
  }

  void _saveModeToLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('timerMode', context.read<TimerModel>().timerEnabled);
    prefs.setInt('countdownTime', context.read<TimerModel>().countdownTime);
  }

  void _showSuccessMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text('Sukses mengatur timer'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TitleScreen(
        titleContainer: 'Timer Mode',
      ),
      body: Consumer<TimerModel>(
        builder: (context, timerModel, _) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _formatDuration(timerModel.countdownTime),
                    style: const TextStyle(
                      color: Color(0xFF5F84B1),
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      CircleButton(
                        onTap: () {
                          context.read<TimerModel>().toggleTimer();
                          _saveModeToLocal();
                        },
                        borderColor: Colors.transparent,
                        backgroundColor: timerModel.timerEnabled
                            ? Colors.green
                            : const Color(0xFF5F84B1),
                        width: 125,
                        height: 125,
                        child: Text(
                          timerModel.timerEnabled ? "ON" : "OFF",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      CircleButton(
                        onTap: timerModel.timerEnabled
                            ? () => _showTimePickerSheet(context)
                            : () => {},
                        borderColor: Colors.transparent,
                        backgroundColor: Colors.black38,
                        width: 125,
                        height: 125,
                        child: const Text(
                          "Timer",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
