// lib/main.dart

import 'package:flutter/material.dart';
import 'screens/splashscreen.dart';

void main() {
  runApp(const FinnexusApp());
}

class FinnexusApp extends StatelessWidget {
  const FinnexusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finnexus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1B5E20),
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashScreen(),
    );
  }
}
