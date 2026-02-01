
import 'package:flutter/material.dart';
import 'vendeurs/dashboard.dart';
import 'vendeurs/profil.dart';
import 'vendeurs/navbar_vendeurs.dart';
import 'acheteurs/navbar_acheteurs.dart';
import 'acheteurs/accueil.dart';
import 'acheteurs/profil.dart';

class MainNavigation extends StatefulWidget {
  final bool isVendeur;

  const MainNavigation({Key? key, required this.isVendeur}) : super(key: key);

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _acheteurPages = [
    const AccueilPage(),
    const ProfilAcheteur(), 
  ];

  final List<Widget> _vendeurPages = [
    const DashboardVendeur(), 
    const ProfilVendeur(), 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.isVendeur
          ? _vendeurPages[_currentIndex]
          : _acheteurPages[_currentIndex],
      bottomNavigationBar: widget.isVendeur
          ? NavBarVendeur(  // ← VENDEUR : NavBarVendeur (sans 's')
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            )
          : NavbarAcheteurs(  // ← ACHETEUR : NavbarAcheteurs (avec 's')
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
    );
  }
}