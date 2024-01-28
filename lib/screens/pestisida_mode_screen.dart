import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_aja/widgets/mode_button.dart';
import 'package:test_aja/widgets/container_title.dart';

class PestisidaMode extends StatefulWidget {
  const PestisidaMode({super.key});

  @override
  State<PestisidaMode> createState() => _PestisidaModeState();
}

class _PestisidaModeState extends State<PestisidaMode> {
  // ignore: deprecated_member_use
  final DatabaseReference _database = FirebaseDatabase.instance.reference();
  bool isPenyiramanMode = false;
  bool manualControlPestisida = false;

  @override
  void initState() {
    super.initState();
    _loadSavedMode();
  }

  void _loadSavedMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isPenyiramanMode = prefs.getBool('penyiramanMode') ?? false;
      manualControlPestisida = prefs.getBool('manualControlPestisida') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const TitleScreen(
          titleContainer: 'Pestisida Mode',
        ),
        body: ButtonWidget(
          onTap1: () {
            setState(() {
              isPenyiramanMode = !isPenyiramanMode;
              // Set manual control to off when switching modes
              manualControlPestisida = false;
              _updateFirebase();
              _saveModeToLocal();
            });
          },
          onTap2: () {
            setState(() {
              manualControlPestisida = !manualControlPestisida;
              _updateFirebase();
              _saveModeToLocal();
            });
          },
          modeText: isPenyiramanMode ? 'Penyiraman' : 'Pestisida',
          manualText: manualControlPestisida ? 'ON' : 'OFF',
          colorManualButton:
              manualControlPestisida ? Colors.green : Colors.black38,
          colorModeButton: isPenyiramanMode
              ? const Color(0xFF607D8B)
              : const Color(0xFF5F84B1),
          mode: !isPenyiramanMode,
        ));
  }

  void _updateFirebase() {
    _database.update({
      'penyiramanMode': isPenyiramanMode,
      'manualModePestisida': !isPenyiramanMode,
      'manualControlPestisida': manualControlPestisida ? 'on' : 'off',
    });
  }

  void _saveModeToLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('penyiramanMode', isPenyiramanMode);
    prefs.setBool('manualControlPestisida', manualControlPestisida);
  }
}
