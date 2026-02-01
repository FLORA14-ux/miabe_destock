import 'package:flutter/material.dart';
import 'package:miabe_destock/mainNavigation.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isClient = true; // Gère la sélection Client/Commerçant
  final Color primaryColor = const Color(0xFF7C3AED); // Violet MIABE DESTOCK
  final Color backgroundColor = const Color(0xFFF5F3FF); // Violet très clair
  final Color cardColor = Colors.white;

  // Contrôleurs pour les champs d'inscription
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _villeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // N'oublie pas de disposer les contrôleurs
    _nomController.dispose();
    _emailController.dispose();
    _telephoneController.dispose();
    _villeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            // Logo et Titre
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              child: Icon(Icons.shopping_bag, size: 50, color: primaryColor),
            ),
            const SizedBox(height: 20),
            Text(
              "MIABE DESTOCK",
              style: TextStyle(
                fontSize: 28, 
                fontWeight: FontWeight.bold, 
                color: primaryColor,
              ),
            ),
            Text(
              "Achetez. Vendez. Simplifiez.",
              style: TextStyle(color: primaryColor.withOpacity(0.7)),
            ),
            const SizedBox(height: 30),

            // Carte Blanche
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: DefaultTabController(
                length: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TabBar(
                      labelColor: primaryColor,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: primaryColor,
                      tabs: const [
                        Tab(text: "Connexion"),
                        Tab(text: "Inscription"),
                      ],
                    ),
                    SizedBox(
                      height: 600, // Augmenté pour plus de champs
                      child: TabBarView(
                        children: [
                          _buildLoginForm(),
                          _buildRegisterForm(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "En continuant, vous acceptez nos\nConditions d'utilisation et Politique de confidentialité",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black12, fontSize: 12),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- FORMULAIRE DE CONNEXION ---
  Widget _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Je suis :", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _buildRoleSelector(),
          const SizedBox(height: 20),
          _buildTextFieldLogin("Téléphone", Icons.phone_outlined, "+228 90 12 34 56"),
          const SizedBox(height: 15),
          _buildTextFieldLogin("Mot de passe", Icons.lock_outline, "••••••••", isPassword: true),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {}, 
              child: Text(
                "Mot de passe oublié ?",
                style: TextStyle(color: primaryColor),
              ),
            ),
          ),
          const SizedBox(height: 30), 
          _buildMainButton("Se connecter", () {
            if (isClient) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainNavigation(isVendeur: false),
                ),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainNavigation(isVendeur: true),
                ),
              );
            }
          }),
          
        ],
      ),
    );
  }

  // --- FORMULAIRE D'INSCRIPTION ---
  Widget _buildRegisterForm() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Je suis :", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildRoleSelector(),
            const SizedBox(height: 20),
            
            // Nom complet
            _buildTextFieldRegister(
              controller: _nomController,
              label: "Nom complet",
              icon: Icons.person_outline,
              hint: "Koffi Mensah",
            ),
            const SizedBox(height: 15),
            
            // Email
            _buildTextFieldRegister(
              controller: _emailController,
              label: "Adresse email",
              icon: Icons.email_outlined,
              hint: "koffi.mensah@email.com",
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 15),
            
            // Téléphone
            _buildTextFieldRegister(
              controller: _telephoneController,
              label: "Téléphone",
              icon: Icons.phone_outlined,
              hint: "+228 90 12 34 56",
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 15),
            
            // Ville
            _buildTextFieldRegister(
              controller: _villeController,
              label: "Ville",
              icon: Icons.location_city_outlined,
              hint: "Lomé",
            ),
            const SizedBox(height: 15),
            
            // Mot de passe
            _buildTextFieldRegister(
              controller: _passwordController,
              label: "Mot de passe",
              icon: Icons.lock_outline,
              hint: "••••••••",
              isPassword: true,
            ),
            const SizedBox(height: 30),
            
            // Bouton d'inscription
            _buildMainButton("S'inscrire", () {
              // Validation basique
              if (_nomController.text.isEmpty ||
                  _emailController.text.isEmpty ||
                  _telephoneController.text.isEmpty ||
                  _villeController.text.isEmpty ||
                  _passwordController.text.isEmpty) {
                _showErrorDialog("Veuillez remplir tous les champs");
                return;
              }
              
              if (!_emailController.text.contains('@')) {
                _showErrorDialog("Veuillez entrer une adresse email valide");
                return;
              }
              
              // Si tout est bon, naviguer
              if (isClient) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainNavigation(isVendeur: false),
                  ),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainNavigation(isVendeur: true),
                  ),
                );
              }
            }),
          ],
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Erreur"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK", style: TextStyle(color: primaryColor)),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS RÉUTILISABLES ---

  Widget _buildRoleSelector() {
    return Row(
      children: [
        _roleCard("Client", Icons.shopping_bag_outlined, isClient, () => setState(() => isClient = true)),
        const SizedBox(width: 10),
        _roleCard("Vendeur", Icons.storefront_outlined, !isClient, () => setState(() => isClient = false)),
      ],
    );
  }

  Widget _roleCard(String label, IconData icon, bool selected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            border: Border.all(color: selected ? primaryColor : Colors.grey[300]!),
            borderRadius: BorderRadius.circular(15),
            color: selected ? primaryColor.withOpacity(0.1) : Colors.white,
          ),
          child: Column(
            children: [
              Icon(icon, color: selected ? primaryColor : Colors.grey),
              Text(
                label, 
                style: TextStyle(
                  color: selected ? primaryColor : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldLogin(String label, IconData icon, String hint, {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          obscureText: isPassword,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey[600]),
            suffixIcon: isPassword ? Icon(Icons.visibility_outlined, color: Colors.grey[600]) : null,
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primaryColor),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildTextFieldRegister({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey[600]),
            suffixIcon: isPassword ? Icon(Icons.visibility_outlined, color: Colors.grey[600]) : null,
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primaryColor),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildMainButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }
}