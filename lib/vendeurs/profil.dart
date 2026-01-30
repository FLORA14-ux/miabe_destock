// vendeurs/profil_vendeur.dart
import 'package:flutter/material.dart';

class ProfilVendeurPage extends StatelessWidget {
  const ProfilVendeurPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'profil vendeur',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}