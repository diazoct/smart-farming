import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class TimerModel extends ChangeNotifier {
  bool _timerEnabled = false;
  int _countdownTime = 0;
  Timer? _timer;

  bool get timerEnabled => _timerEnabled;
  int get countdownTime => _countdownTime;

  void toggleTimer() {
    _timerEnabled = !_timerEnabled;
    if (_timerEnabled) {
      startTimer();
      updateFirebase();
    } else {
      resetTimer();
    }
    notifyListeners();
  }

  void setCountdownTime(int duration) {
    _countdownTime = duration;
    notifyListeners();
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdownTime > 0) {
        _countdownTime--;
        updateFirebase(); // Perbarui nilai countdown pada Firebase
        notifyListeners();
      } else {
        _timer?.cancel();
      }
    });
  }

  void resetTimer() {
    _countdownTime = 0;
    _timer?.cancel();
    updateFirebase(); // Reset nilai countdown pada Firebase
    notifyListeners();
  }

  void disposeTimer() {
    _timer?.cancel();
  }

  void updateFirebase() {
    // ignore: deprecated_member_use
    FirebaseDatabase.instance.reference().child('timer').update({
      'timerMode': _timerEnabled,
      'duration': _timerEnabled ? _countdownTime : 0,
    });
  }
}
