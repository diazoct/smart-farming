// ignore_for_file: avoid_print

import 'package:firebase_database/firebase_database.dart' show FirebaseDatabase;
import 'package:flutter/material.dart';
import 'package:flutter_pagination/flutter_pagination.dart';
import 'package:flutter_pagination/widgets/button_styles.dart';
import 'package:semicircle_indicator/semicircle_indicator.dart';
import 'package:test_aja/screens/auth_mode_screen.dart';
import 'package:test_aja/widgets/home_custom.dart';
import 'package:test_aja/screens/timer_mode_screen.dart';
import 'package:test_aja/screens/pestisida_mode_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // ignore: deprecated_member_use
  final databaseReference = FirebaseDatabase.instance.reference();

  double temperature = 0.0;
  double humidity = 0.0;
  int soilMoisture = 0;
  int currentPage = 1;
  bool isAutomaticMode = false;
  bool isTimerMode = false;
  bool isPestisidaMode = true;

  @override
  void initState() {
    super.initState();

    // Mendengarkan perubahan data di Firebase Database
    _listenToFirebase('Suhu', (value) {
      print("Suhu: $value");
      setState(() {
        temperature = (value as num?)?.toDouble() ?? 0.0;
      });
    });

    _listenToFirebase('Kelembapan', (value) {
      print("Kelembapan: $value");
      setState(() {
        humidity = (value as num?)?.toDouble() ?? 0.0;
      });
    });

    _listenToFirebase('SoilMoisture', (value) {
      print("Soil Moisture: $value");
      setState(() {
        soilMoisture = value as int? ?? 0;
      });
    });

    _listenToFirebase('autoMode', (value) {
      print("Mode Automatic: $value");
      setState(() {
        isAutomaticMode = (value as bool?) ?? false;
      });
    });

    _listenToFirebase('timer/timerMode', (value) {
      print("Mode Timer: $value");
      setState(() {
        isTimerMode = (value as bool?) ?? false;
      });
    });

    _listenToFirebase('manualModePestisida', (value) {
      print("Mode Pestisida: $value");
      setState(() {
        isPestisidaMode = (value as bool?) ?? true;
      });
    });
  }

  void _listenToFirebase(String child, void Function(dynamic) onData) {
    databaseReference.child(child).onValue.listen((event) {
      onData(event.snapshot.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          const SizedBox(height: 15),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                // Soil Moisture Indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SemicircularIndicator(
                      radius: 100,
                      progress: soilMoisture / 100,
                      strokeWidth: 15,
                      strokeCap: StrokeCap.round,
                      backgroundColor: Colors.white,
                      bottomPadding: 0,
                      child: Text(
                        '${soilMoisture.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const SizedBox(
                  child: Text(
                    'Kelembapan Tanah',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Temperature and Humidity Indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Temperature Indicator
                    Column(
                      children: [
                        SemicircularIndicator(
                          radius: 60,
                          progress: temperature / 100,
                          backgroundColor: Colors.white,
                          strokeCap: StrokeCap.round,
                          strokeWidth: 10,
                          bottomPadding: 0,
                          child: Text(
                            '${temperature.toStringAsFixed(0)}°C',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const SizedBox(
                          child: Text(
                            'Suhu Udara',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Humidity Indicator
                    Column(
                      children: [
                        SemicircularIndicator(
                          radius: 60,
                          progress: humidity / 100,
                          strokeWidth: 10,
                          strokeCap: StrokeCap.round,
                          backgroundColor: Colors.white,
                          bottomPadding: 0,
                          child: Text(
                            '${humidity.toStringAsFixed(0)}%',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const SizedBox(
                          child: Text(
                            'Kelembapan Udara',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 20.0),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFCFDF7),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0),
                    ),
                  ),
                  child: buildFileContent(currentPage),
                ),
                Positioned(
                  bottom: 50,
                  child: Pagination(
                    paginateButtonStyles: PaginateButtonStyles(
                      backgroundColor: const Color(0xFF5F84B1),
                    ),
                    prevButtonStyles: PaginateSkipButton(
                      buttonBackgroundColor: const Color(0xFF5F84B1),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20)),
                    ),
                    nextButtonStyles: PaginateSkipButton(
                      buttonBackgroundColor: const Color(0xFF5F84B1),
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                    ),
                    onPageChange: (number) {
                      setState(() {
                        currentPage = number;
                      });
                    },
                    useGroup: false,
                    totalPage: 3,
                    show: 2,
                    currentPage: currentPage,
                    // End pagination properties
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFileContent(int pageNumber) {
    if (isAutomaticMode) {
      // Jika mode otomatis bernilai true, tidak menampilkan widget PestisidaMode dan TimerMode
      return const AuthMode();
    } else if (isPestisidaMode) {
      return const PestisidaMode();
    } else if (isTimerMode) {
      return const TimerMode();
    } else {
      // Jika mode otomatis bernilai false, menampilkan widget sesuai dengan nomor halaman
      switch (pageNumber) {
        case 1:
          return const PestisidaMode();
        case 2:
          return const AuthMode();
        case 3:
          return const TimerMode();
        default:
          return Container();
      }
    }
  }
}
