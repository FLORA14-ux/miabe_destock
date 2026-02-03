// lib/vendeurs/ajouter_article.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart'; // À décommenter quand prêt

class AjouterArticle extends StatefulWidget {
  const AjouterArticle({Key? key}) : super(key: key);

  @override
  State<AjouterArticle> createState() => _AjouterArticleState();
}

class _AjouterArticleState extends State<AjouterArticle> {
  final _formKey = GlobalKey<FormState>();
  final Color primaryColor = const Color(0xFF7C3AED);
  
  // Controllers
  final TextEditingController _titreController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _prixController = TextEditingController();
  final TextEditingController _localisationController = TextEditingController();
  
  // États
  String? _categorieSelectionnee;
  String? _etatSelectionne;
  List<String> _images = []; // URLs ou paths des images
  bool _isLoading = false;
  
  // Listes
  final List<Map<String, dynamic>> _categories = [
    {'value': 'ELECTRONIQUE_INFORMATIQUE', 'label': 'Électronique & Informatique', 'icon': Icons.computer},
    {'value': 'ELECTROMENAGER', 'label': 'Électroménager', 'icon': Icons.kitchen},
    {'value': 'VEHICULE', 'label': 'Véhicules', 'icon': Icons.directions_car},
    {'value': 'MEUBLE_DECORATION', 'label': 'Meubles & Décorations', 'icon': Icons.chair},
    {'value': 'ACCESSOIRE', 'label': 'Accessoires', 'icon': Icons.shopping_bag},
  ];
  
  final List<Map<String, String>> _etats = [
    {'value': 'neuf', 'label': 'Neuf'},
    {'value': 'très bon', 'label': 'Très bon état'},
    {'value': 'bon', 'label': 'Bon état'},
    {'value': 'acceptable', 'label': 'État acceptable'},
  ];

  Future<void> _ajouterImage() async {
    // TODO: Implémenter image_picker
    // final ImagePicker picker = ImagePicker();
    // final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    // Pour l'instant, ajouter une image de test
    setState(() {
      if (_images.length < 5) {
        _images.add('https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600&fit=crop');
      }
    });
  }

  void _supprimerImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Future<void> _publierAnnonce() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    if (_categorieSelectionnee == null) {
      _showError('Veuillez sélectionner une catégorie');
      return;
    }
    
    if (_etatSelectionne == null) {
      _showError('Veuillez sélectionner l\'état du produit');
      return;
    }
    
    if (_images.isEmpty) {
      _showError('Veuillez ajouter au moins une photo');
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      // Simuler appel API
      await Future.delayed(const Duration(seconds: 2));
      
      // TODO: Vrai appel API
      // await apiService.creerArticle({...});
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('Annonce publiée avec succès !'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        
        Navigator.pop(context, true); // Retourner true pour rafraîchir la liste
      }
    } catch (e) {
      _showError('Erreur lors de la publication: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          'Créer une annonce',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Photos
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Photos (max 5)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ajoutez des photos claires de votre produit',
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                    const SizedBox(height: 16),
                    
                    // Grille de photos
                    SizedBox(
                      height: 100,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          // Bouton ajouter
                          GestureDetector(
                            onTap: _images.length < 5 ? _ajouterImage : null,
                            child: Container(
                              width: 100,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _images.length < 5 ? primaryColor : Colors.grey[300]!,
                                  style: BorderStyle.solid,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.upload,
                                    color: _images.length < 5 ? primaryColor : Colors.grey,
                                    size: 32,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Ajouter',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _images.length < 5 ? primaryColor : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          // Images ajoutées
                          ..._images.asMap().entries.map((entry) {
                            final index = entry.key;
                            final imageUrl = entry.value;
                            
                            return Container(
                              width: 100,
                              margin: const EdgeInsets.only(right: 12),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      imageUrl,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.broken_image),
                                      ),
                                    ),
                                  ),
                                  // Bouton supprimer
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: GestureDetector(
                                      onTap: () => _supprimerImage(index),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Formulaire
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Titre
                    _buildTextField(
                      controller: _titreController,
                      label: 'Titre de l\'annonce',
                      hint: 'Ex: Moto Yamaha 125cc',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer un titre';
                        }
                        if (value.length < 5) {
                          return 'Le titre doit contenir au moins 5 caractères';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    
                    // Description
                    _buildTextField(
                      controller: _descriptionController,
                      label: 'Description',
                      hint: 'Décrivez votre produit en détail...',
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer une description';
                        }
                        if (value.length < 20) {
                          return 'La description doit contenir au moins 20 caractères';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    
                    // Prix
                    _buildTextField(
                      controller: _prixController,
                      label: 'Prix (FCFA)',
                      hint: 'Ex: 850000',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer un prix';
                        }
                        if (int.tryParse(value) == null || int.parse(value) <= 0) {
                          return 'Prix invalide';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    
                    // Catégorie
                  _buildDropdown(
                    label: 'Catégorie',
                    hint: 'Sélectionner une catégorie',
                    value: _categorieSelectionnee,
                    items: _categories.map<DropdownMenuItem<String>>((cat) {
                      return DropdownMenuItem<String>(
                        value: cat['value'] as String,
                        child: Row(
                          children: [
                            Icon(cat['icon'] as IconData, size: 20, color: Colors.grey[600]),
                            const SizedBox(width: 12),
                            Text(cat['label'] as String),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() => _categorieSelectionnee = value);
                    },
                  ),
                  const SizedBox(height: 20),
                    
                    // État
                    _buildDropdown(
                      label: 'État',
                      hint: 'Sélectionner l\'état',
                      value: _etatSelectionne,
                      items: _etats.map((etat) {
                        return DropdownMenuItem(
                          value: etat['value'],
                          child: Text(etat['label']!),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _etatSelectionne = value);
                      },
                    ),
                    const SizedBox(height: 20),
                    
                    // Localisation
                    _buildTextField(
                      controller: _localisationController,
                      label: 'Localisation',
                      hint: 'Lomé, Togo',
                      prefixIcon: Icons.location_on_outlined,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer votre localisation';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 80), // Espace pour le bouton flottant
            ],
          ),
        ),
      ),
      
      // Bouton flottant en bas
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _publierAnnonce,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                disabledBackgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Publier l\'annonce',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    IconData? prefixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label *',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 20) : null,
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 16,
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String hint,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label *',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          hint: Text(
            hint,
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),
          items: items,
          onChanged: onChanged,
          decoration: InputDecoration(
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
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 16,
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _titreController.dispose();
    _descriptionController.dispose();
    _prixController.dispose();
    _localisationController.dispose();
    super.dispose();
  }
}