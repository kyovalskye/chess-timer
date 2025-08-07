import 'package:chess_timer_aseli_njir/settings.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const SplashScreen());
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _queenController;
  late AnimationController _kingController;
  late Animation<double> _queenAnimation;
  late Animation<double> _kingAnimation;

  @override
  void initState() {
    super.initState();

    // Controller untuk Queen
    _queenController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    // Controller untuk King
    _kingController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    // Animasi rotasi untuk Queen (0 ke 180 derajat)
    _queenAnimation = Tween<double>(begin: 0, end: math.pi).animate(
      CurvedAnimation(parent: _queenController, curve: Curves.easeInOut),
    );

    // Animasi rotasi untuk King (0 ke 180 derajat)
    _kingAnimation = Tween<double>(begin: 0, end: math.pi).animate(
      CurvedAnimation(parent: _kingController, curve: Curves.easeInOut),
    );

    // Urutan animasi
    _startAnimationSequence();
  }

  void _startAnimationSequence() async {
    await _queenController.forward();

    await Future.delayed(const Duration(milliseconds: 50));
    await _kingController.forward();

    await Future.delayed(const Duration(milliseconds: 50));
    _queenAnimation = Tween<double>(begin: math.pi, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _queenController, curve: Curves.easeInOut),
    );
    _queenController.reset();
    await _queenController.forward();

    await Future.delayed(const Duration(milliseconds: 500));
    _kingAnimation = Tween<double>(begin: math.pi, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _kingController, curve: Curves.easeInOut),
    );
    _kingController.reset();
    await _kingController.forward();

    await Future.delayed(const Duration(milliseconds: 200));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SettingsPage()),
      );
    }
  }

  @override
  void dispose() {
    _queenController.dispose();
    _kingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 139, 139, 139),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _kingAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _kingAnimation.value,
                    child: Image.asset(
                      'assets/images/king.png',
                      height: 150,
                      width: 150,
                    ),
                  );
                },
              ),
              const SizedBox(width: 20), // Jarak antara king dan queen
              AnimatedBuilder(
                animation: _queenAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _queenAnimation.value,
                    child: Image.asset(
                      'assets/images/queen.png',
                      height: 150,
                      width: 150,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
