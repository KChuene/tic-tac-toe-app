import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tic_tac_toe/screens/game.dart';
import 'package:tic_tac_toe/screens/landing.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Tic Tac Toe",
      initialRoute: LandingScreen.route,
      routes: {
        LandingScreen.route: (_) => const LandingScreen(),
        GameScreen.route: (_) => const GameScreen()
      },
    );
  }
}

