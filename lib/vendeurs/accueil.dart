// vendeurs/accueil_vendeur.dart
import 'package:flutter/material.dart';

class AccueilVendeurPage extends StatelessWidget {
  const AccueilVendeurPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'accueil vendeur',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}