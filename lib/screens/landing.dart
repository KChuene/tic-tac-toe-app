import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tic_tac_toe/constants/color.dart';
import 'package:tic_tac_toe/screens/game.dart';

class LandingScreen extends StatefulWidget {
  static const String route = "/";

  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreen();
}

class _LandingScreen extends State<LandingScreen> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/tttoe_main.png"),
            Text(
              "Tic Tac Toe",
              style: GameScreen.customFontStyle
            )
          ],
        ),
      ),
    );
  }

  void _startTimer() {
    int timeleft = 3;
    timer = Timer.periodic(const Duration(seconds: 1), (_) { 
      if(timeleft > 0) {
        timeleft--;
      }
      else {
        _stopTimer();
        Navigator.of(context).pushNamed(GameScreen.route);
      }
    });
  }

  void _stopTimer() {
    timer?.cancel();
  }
}