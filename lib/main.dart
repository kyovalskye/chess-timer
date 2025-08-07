import 'package:chess_timer_aseli_njir/splash_screen.dart';
import 'package:flutter/material.dart';

void main (){
  runApp(const ChessTimer());
}

class ChessTimer extends StatelessWidget {
  const ChessTimer({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}