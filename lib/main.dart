import 'package:flutter/material.dart';
import 'auth_page.dart';
import 'screen/splash_screen.dart';

import 'services/api_service.dart'; // ajuste le chemin si nécessaire

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MIABE DESTOCK',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // On combine le ColorScheme et les couleurs personnalisées
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C3AED),
          primary: const Color(0xFF7C3AED),
        ),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      // Le SplashScreen est bien le point d'entrée idéal
      home: const SplashScreen(),
    );
  }
}
