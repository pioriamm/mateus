import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mateus/pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.mouse},
      ),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF16464B),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFf4f4f4),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xFF103239)),
        appBarTheme: const AppBarTheme(color: Colors.white),
      ),
      home: const Home(),
    );
  }
}
