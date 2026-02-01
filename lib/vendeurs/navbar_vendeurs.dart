import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'profil.dart';

class NavBarVendeur extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const NavBarVendeur({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  _NavBarVendeurState createState() => _NavBarVendeurState();
}

class _NavBarVendeurState extends State<NavBarVendeur> {
  // Liste des pages pour la navigation
  final List<Widget> pages = [
    const DashboardVendeur(), // Remplace AccueilVendeur par DashboardVendeur
    const ProfilVendeur(),
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: widget.onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: const TextStyle(fontSize: 12),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Dashboard', 
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
    );
  }
}