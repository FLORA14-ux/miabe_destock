import 'package:flutter/material.dart';
import 'accueil.dart';
import 'profil.dart';

class NavbarAcheteurs extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const NavbarAcheteurs({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  _NavbarAcheteursState createState() => _NavbarAcheteursState();
}

class _NavbarAcheteursState extends State<NavbarAcheteurs> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: widget.onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF7C3AED), // Votre couleur violette
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: const TextStyle(fontSize: 12),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Accueil',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
    );
  }
}