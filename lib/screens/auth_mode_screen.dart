import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_aja/widgets/mode_button.dart';
import 'package:test_aja/widgets/container_title.dart';

class AuthMode extends StatefulWidget {
  const AuthMode({super.key});

  @override
  State<AuthMode> createState() => _AuthModeState();
}

class _AuthModeState extends State<AuthMode> {
  // ignore: deprecated_member_use
  final DatabaseReference _database = FirebaseDatabase.instance.reference();
  bool isAutoMode = false;
  bool manualControlOn = false;

  @override
  void initState() {
    super.initState();
    _loadSavedMode();
  }

  void _loadSavedMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isAutoMode = prefs.getBool('autoMode') ?? false;
      manualControlOn = prefs.getBool('manualControlOn') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const TitleScreen(
          titleContainer: 'Automatic Mode',
        ),
        body: ButtonWidget(
          onTap1: () {
            setState(() {
              isAutoMode = !isAutoMode;
              // Set manual control to off when switching modes
              manualControlOn = false;
              _updateFirebase();
              _saveModeToLocal();
            });
          },
          onTap2: () {
            setState(() {
              manualControlOn = !manualControlOn;
              _updateFirebase();
              _saveModeToLocal();
            });
          },
          modeText: isAutoMode ? 'Automatic' : 'Manual',
          manualText: manualControlOn ? 'ON' : 'OFF',
          colorManualButton: manualControlOn ? Colors.green : Colors.black38,
          colorModeButton:
              isAutoMode ? const Color(0xFF607D8B) : const Color(0xFF5F84B1),
          mode: !isAutoMode,
        ));
  }

  void _updateFirebase() {
    _database.update({
      'autoMode': isAutoMode,
      'manualMode': !isAutoMode,
      'manualControl': manualControlOn ? 'on' : 'off',
    });
  }

  void _saveModeToLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('autoMode', isAutoMode);
    prefs.setBool('manualControlOn', manualControlOn);
  }
}
