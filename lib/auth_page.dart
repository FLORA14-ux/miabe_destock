import 'package:flutter/material.dart';
import 'package:miabe_destock/mainNavigation.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isClient = true;
  final Color primaryColor = const Color(0xFF7C3AED);
  final Color backgroundColor = const Color(0xFFF5F3FF);
  final Color cardColor = Colors.white;

  // Contrôleurs pour CONNEXION
  final TextEditingController _loginPhoneController = TextEditingController();
  final TextEditingController _loginPasswordController = TextEditingController();

  // Contrôleurs pour INSCRIPTION
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _villeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // États pour les mots de passe
  bool _obscureLoginPassword = true;
  bool _obscureRegisterPassword = true;
  bool _obscureConfirmPassword = true;

  // État de chargement
  bool _isLoading = false;

  @override
  void dispose() {
    _loginPhoneController.dispose();
    _loginPasswordController.dispose();
    _nomController.dispose();
    _emailController.dispose();
    _telephoneController.dispose();
    _villeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              
              // Logo et Titre avec animation
              Hero(
                tag: 'logo',
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.shopping_bag, size: 60, color: primaryColor),
                ),
              ),
              const SizedBox(height: 20),
              
              Text(
                "MIABE DESTOCK",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              
              Text(
                "Achetez. Vendez. Simplifiez.",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
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
                      color: primaryColor.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 2,
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
                        indicatorWeight: 3,
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        tabs: const [
                          Tab(text: "Connexion"),
                          Tab(text: "Inscription"),
                        ],
                      ),
                      SizedBox(
                        height: 550,
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
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "En continuant, vous acceptez nos Conditions d'utilisation et Politique de confidentialité",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
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
          const Text("Je suis :", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          _buildRoleSelector(),
          const SizedBox(height: 24),
          
          // Téléphone
          _buildTextField(
            controller: _loginPhoneController,
            label: "Téléphone",
            icon: Icons.phone_outlined,
            hint: "+228 90 12 34 56",
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          
          // Mot de passe
          _buildTextField(
            controller: _loginPasswordController,
            label: "Mot de passe",
            icon: Icons.lock_outline,
            hint: "••••••••",
            isPassword: true,
            obscureText: _obscureLoginPassword,
            onTogglePassword: () {
              setState(() => _obscureLoginPassword = !_obscureLoginPassword);
            },
          ),
          
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // TODO: Navigation vers récupération mot de passe
              },
              child: Text(
                "Mot de passe oublié ?",
                style: TextStyle(color: primaryColor, fontSize: 13),
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          _buildMainButton(
            "Se connecter",
            _isLoading ? null : _handleLogin,
          ),
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
            const Text("Je suis :", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            _buildRoleSelector(),
            const SizedBox(height: 20),
            
            // Nom complet
            _buildTextField(
              controller: _nomController,
              label: "Nom complet",
              icon: Icons.person_outline,
              hint: "Kofi Mensah",
            ),
            const SizedBox(height: 16),
            
            // Email
            _buildTextField(
              controller: _emailController,
              label: "Adresse email",
              icon: Icons.email_outlined,
              hint: "kofi.mensah@email.com",
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            
            // Téléphone
            _buildTextField(
              controller: _telephoneController,
              label: "Téléphone",
              icon: Icons.phone_outlined,
              hint: "+228 90 12 34 56",
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            
            // Ville
            _buildTextField(
              controller: _villeController,
              label: "Ville",
              icon: Icons.location_city_outlined,
              hint: "Lomé",
            ),
            const SizedBox(height: 16),
            
            // Mot de passe
            _buildTextField(
              controller: _passwordController,
              label: "Mot de passe",
              icon: Icons.lock_outline,
              hint: "••••••••",
              isPassword: true,
              obscureText: _obscureRegisterPassword,
              onTogglePassword: () {
                setState(() => _obscureRegisterPassword = !_obscureRegisterPassword);
              },
            ),
            const SizedBox(height: 16),
            
            // Confirmer mot de passe
            _buildTextField(
              controller: _confirmPasswordController,
              label: "Confirmer le mot de passe",
              icon: Icons.lock_outline,
              hint: "••••••••",
              isPassword: true,
              obscureText: _obscureConfirmPassword,
              onTogglePassword: () {
                setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
              },
            ),
            const SizedBox(height: 24),
            
            _buildMainButton(
              "S'inscrire",
              _isLoading ? null : _handleRegister,
            ),
          ],
        ),
      ),
    );
  }

  // --- LOGIQUE DE CONNEXION ---
  void _handleLogin() {
    // Validation
    if (_loginPhoneController.text.isEmpty) {
      _showErrorSnackBar("Veuillez entrer votre numéro de téléphone");
      return;
    }
    
    if (_loginPasswordController.text.isEmpty) {
      _showErrorSnackBar("Veuillez entrer votre mot de passe");
      return;
    }
    
    if (_loginPasswordController.text.length < 6) {
      _showErrorSnackBar("Le mot de passe doit contenir au moins 6 caractères");
      return;
    }
    
    setState(() => _isLoading = true);
    
    // Simuler un appel API
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isLoading = false);
        
        // Navigation
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainNavigation(isVendeur: !isClient),
          ),
        );
      }
    });
  }

  // --- LOGIQUE D'INSCRIPTION ---
  void _handleRegister() {
    // Validation complète
    if (_nomController.text.isEmpty) {
      _showErrorSnackBar("Veuillez entrer votre nom complet");
      return;
    }
    
    if (_emailController.text.isEmpty) {
      _showErrorSnackBar("Veuillez entrer votre email");
      return;
    }
    
    if (!_emailController.text.contains('@')) {
      _showErrorSnackBar("Veuillez entrer une adresse email valide");
      return;
    }
    
    if (_telephoneController.text.isEmpty) {
      _showErrorSnackBar("Veuillez entrer votre numéro de téléphone");
      return;
    }
    
    if (_villeController.text.isEmpty) {
      _showErrorSnackBar("Veuillez entrer votre ville");
      return;
    }
    
    if (_passwordController.text.isEmpty) {
      _showErrorSnackBar("Veuillez entrer un mot de passe");
      return;
    }
    
    if (_passwordController.text.length < 6) {
      _showErrorSnackBar("Le mot de passe doit contenir au moins 6 caractères");
      return;
    }
    
    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorSnackBar("Les mots de passe ne correspondent pas");
      return;
    }
    
    setState(() => _isLoading = true);
    
    // Simuler un appel API
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isLoading = false);
        
        // Afficher message de succès
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Inscription réussie !"),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        
        // Navigation
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainNavigation(isVendeur: !isClient),
          ),
        );
      }
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // --- WIDGETS RÉUTILISABLES ---

  Widget _buildRoleSelector() {
    return Row(
      children: [
        _roleCard(
          "Client",
          Icons.shopping_bag_outlined,
          isClient,
          () => setState(() => isClient = true),
        ),
        const SizedBox(width: 12),
        _roleCard(
          "Vendeur",
          Icons.storefront_outlined,
          !isClient,
          () => setState(() => isClient = false),
        ),
      ],
    );
  }

  Widget _roleCard(String label, IconData icon, bool selected, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(
              color: selected ? primaryColor : Colors.grey[300]!,
              width: selected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
            color: selected ? primaryColor.withOpacity(0.1) : Colors.white,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: selected ? primaryColor : Colors.grey,
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: selected ? primaryColor : Colors.grey,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onTogglePassword,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword && obscureText,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey[600], size: 20),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                    onPressed: onTogglePassword,
                  )
                : null,
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            filled: true,
            fillColor: Colors.grey[50],
          ),
        ),
      ],
    );
  }

  Widget _buildMainButton(String text, VoidCallback? onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          disabledBackgroundColor: primaryColor.withOpacity(0.6),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}