import 'dart:async';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Happy New Year 2024',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HappyNewYear(),
    );
  }
}

class HappyNewYear extends StatefulWidget {
  const HappyNewYear({super.key});

  @override
  State<HappyNewYear> createState() => _HappyNewYearState();
}

class _HappyNewYearState extends State<HappyNewYear> {
  late Timer _timer;
  late DateTime _dateTime;
  late Duration _difference;
  late ConfettiController _controllerCenter;
  late ConfettiController _controllerCenterRight;
  late ConfettiController _controllerCenterLeft;
  bool _isNewYearCelebrated = false;

  @override
  void initState() {
    super.initState();
    _dateTime = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day + 1, 0, 0, 0);
        
    _difference = _dateTime.difference(DateTime.now());

    _startCountdown();

    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerCenterRight =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerCenterLeft =
        ConfettiController(duration: const Duration(seconds: 10));

    while (!DateTime.now().isAfter(_dateTime)) {
      if (DateTime.now().isAfter(_dateTime)) {
        print("1");
        _controllerCenterRight.play();
        _controllerCenterLeft.play();
        _controllerCenter.play();
      }
    }
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _difference = _dateTime.difference(DateTime.now());

        // Geri sayım tamamlandıysa Timer'ı durdurun
        if (_difference.inSeconds <= 0) {
          _timer.cancel();
          _checkAndCelebrateNewYear();
        }
      });
    });
  }

  void _checkAndCelebrateNewYear() {
    if (!_isNewYearCelebrated && DateTime.now().isAfter(_dateTime)) {
      // Yeni yıl olayı gerçekleşti
      print("2024 oldu! Hoş geldin yeni yıl");

      // Animasyonları çalıştırmak için post-frame callback kullanın
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controllerCenterRight.play();
        _controllerCenterLeft.play();
        _controllerCenter.play();
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();

    _controllerCenter.dispose();
    _controllerCenterRight.dispose();
    _controllerCenterLeft.dispose();
    super.dispose();
  }

  /// A custom Path to paint stars.
  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/img/bg.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "31 December 2023",
                style: GoogleFonts.rubikGlitch(fontSize: 35),
              ),
              Text(
                _formatDuration(_difference),
                style: GoogleFonts.rubikGlitch(fontSize: 35),
              ),
              //CENTER -- Blast
              Align(
                alignment: Alignment.center,
                child: ConfettiWidget(
                  confettiController: _controllerCenter,
                  blastDirectionality: BlastDirectionality
                      .explosive, // don't specify a direction, blast randomly
                  shouldLoop:
                      true, // start again as soon as the animation is finished
                  colors: const [
                    Colors.green,
                    Colors.blue,
                    Colors.pink,
                    Colors.orange,
                    Colors.purple
                  ], // manually specify the colors to be used
                  createParticlePath: drawStar, // define a custom shape/path.
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ConfettiWidget(
                  confettiController: _controllerCenterRight,
                  blastDirection: pi, // radial value - LEFT
                  particleDrag: 0.05, // apply drag to the confetti
                  emissionFrequency: 0.05, // how often it should emit
                  numberOfParticles: 20, // number of particles to emit
                  gravity: 0.05, // gravity - or fall speed
                  shouldLoop: false,
                  colors: const [
                    Colors.green,
                    Colors.blue,
                    Colors.pink
                  ], // manually specify the colors to be used
                  strokeWidth: 1,
                  strokeColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    // Duration'ı sadece saniye cinsinden tam sayıya çevirin
    int seconds = duration.inSeconds;

    // Saat, dakika ve saniyeyi ayarlayın
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    seconds = seconds % 60;

    // String olarak formatlayın
    return '$hours:$minutes:$seconds';
  }

  Text _display(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white, fontSize: 20),
    );
  }
}
