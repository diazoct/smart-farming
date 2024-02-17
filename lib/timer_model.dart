// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class TimerModel extends ChangeNotifier {
  bool _timerEnabled = false;
  int _countdownTime = -1; // Default value set to -1

  Timer? _timer;

  bool get timerEnabled => _timerEnabled;
  int get countdownTime => _countdownTime;

  TimerModel() {
    // Mendengarkan perubahan pada nilai 'Kelembapan'
    FirebaseDatabase.instance
        .reference()
        .child('SoilMoisture')
        .onValue
        .listen((event) {
      final kelembapantanah = event.snapshot.value as int?;

      // Mengubah nilai duration jika Kelembapan >= 50
      if (kelembapantanah != null && kelembapantanah >= 50) {
        setCountdownTime(-1);
      }
    });
  }

  void toggleTimer() {
    _timerEnabled = !_timerEnabled;
    if (!_timerEnabled) {
      resetTimer();
    }
    updateFirebase();
    notifyListeners();
  }

  void setCountdownTime(int duration) {
    _countdownTime = duration;
    if (_countdownTime > 0 && _timerEnabled) {
      startTimer();
    }
    updateFirebase();
    notifyListeners();
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdownTime > 0) {
        _countdownTime--;
        updateFirebase();
        notifyListeners();
      } else {
        _timer?.cancel();
      }
    });
  }

  void resetTimer() {
    _countdownTime = -1; // Reset to -1 when the timer is not enabled
    _timer?.cancel();
    updateFirebase();
    notifyListeners();
  }

  void disposeTimer() {
    _timer?.cancel();
  }

  void updateFirebase() {
    FirebaseDatabase.instance.reference().child('timer').update({
      'timerMode': _timerEnabled,
      'duration': _timerEnabled ? _countdownTime : -1,
    });
  }
}
