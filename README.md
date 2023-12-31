
![CI/CD](https://github.com/dominicarrojado/hashtag-interactive-valentines-day-card-app/workflows/CI/CD/badge.svg) [![codecov](https://codecov.io/github/dominicarrojado/hashtag-interactive-valentines-day-card-app/branch/develop/graph/badge.svg?token=V5QRH2QTM4)](https://codecov.io/github/dominicarrojado/hashtag-interactive-valentines-day-card-app)

New Years application with [Flutter](https://flutter.dev/) + [Dart](https://www.dart.dev/).

## Description text
This application has a countdown logic. It works exactly for December 31st.

When you run this application on your device on December 31st, the countdown starts and confetti explodes at 00:00 on January 1st.

I explain a basic logic below, come with me!

## Quick Start

1. Install [Flutter](https://flutter.dev/).
2. Clone the app:

```bash
git clone https://github.com/Enderjua/happynewyear2024.git
```

3. Install dependencies:

```bash
cd happynewyear
flutter pub get
```

4. Run the development server:

```bash
flutter run -d web --web-port 3000
```

5. Open [http://localhost:3000](http://localhost:3000) to view it in the browser.

## Running with Mobile

```bash
flutter run -d emulator_id
```

## Running Tests (Debug)

```bash
flutter run --debug
```

## A few explanations about the application

1. Countdown
```dart
   import 'dart:async';
   ...
   late Timer _timer;
   late DateTime _dateTime;
   late Duration _difference;
   @override
   void initState() {
    super.initState();
    _dateTime = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day + 1, 0, 0, 0);
        
    _difference = _dateTime.difference(DateTime.now());

    _startCountdown();
   ...
   }

   void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _difference = _dateTime.difference(DateTime.now());

        // Geri sayım tamamlandıysa Timer'ı durdurun
        if (_difference.inSeconds <= 0) {
          _timer.cancel();
          ...
        }
      });
    });
   }
   ...
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
   Text(
                _formatDuration(_difference),...
   )
```

This is literally the entire countdown. First, we define the variables required for the countdown. To use these, we need to import the "dart:async" package. Afterwards, we set the values ​​in initState and create a function for the countdown. We communicate that every time a second passes in SetState, 1 second should be subtracted from our current difference. By the way, "difference" is a function created to show the difference between two time periods. The purpose of the String function below is to eliminate split seconds.

2. Conffeti
```dart
import 'dart:math';
import 'package:confetti/confetti.dart';
...
late ConfettiController _controllerCenter;
late ConfettiController _controllerCenterRight;
late ConfettiController _controllerCenterLeft;
bool _isNewYearCelebrated = false;
...
  void initState() {
    super.initState();
   ...
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerCenterRight =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerCenterLeft =
        ConfettiController(duration: const Duration(seconds: 10));

    while (!DateTime.now().isAfter(_dateTime)) {
      if (DateTime.now().isAfter(_dateTime)) {
       // print("1");
        _controllerCenterRight.play();
        _controllerCenterLeft.play();
        _controllerCenter.play();
      }
    }
  }

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

....

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

```
I know there's a lot of technical stuff going on here, but it doesn't matter. I don't know either. There is no need to know.
First, we import the necessary packages. We also need the "dart:math" package to use physics.
Then we define the variables we need. We need a center, a right and a left variable. Nobody cares about the left, you can delete it.
Below, we state that confetti should explode when there is no distance between the time zones, that is, at 00:00 on JANUARY 1, 2024. This is included in while.
Below is a mathematical breakdown that introduces the shapes of confetti, no need. Aligns are Flutter codes that indicate the colors of the confetti and where they will fall or fly. That's enough explaining, Merry Christmas to Christians!

To years full of software.

## VSCode Extensions

- [Flutter](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)
- [Dart](https://marketplace.visualstudio.com/items?itemName=Dart-Code.dart-code)
