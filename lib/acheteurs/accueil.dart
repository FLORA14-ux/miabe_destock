// lib/acheteurs/accueil.dart
import 'package:flutter/material.dart';

// --- Classe Article ---
class Article {
  final String id;
  final String titre;
  final String description;
  final double prix;
  final String categorie;
  final List<String> images;
  final String vendeurNom;
  final String? ville;
  final String? etat;

  Article({
    required this.id,
    required this.titre,
    required this.description,
    required this.prix,
    required this.categorie,
    required this.images,
    required this.vendeurNom,
    this.ville,
    this.etat,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id']?.toString() ?? '',
      titre: json['titre'] ?? '',
      description: json['description'] ?? '',
      prix: (json['prix'] ?? 0).toDouble(),
      categorie: json['categorie'] ?? '',
      images: (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
      vendeurNom: json['vendeurNom'] ?? '',
      ville: json['ville'],
      etat: json['etat'],
    );
  }

  String get prixFormate => '${prix.toStringAsFixed(0)} FCFA';
  String get imagePrincipale => images.isNotEmpty ? images[0] : '';
}

// --- Classe CategoryItem ---
class CategoryItem {
  final String titre;
  final String apiPath;

  CategoryItem({required this.titre, required this.apiPath});
}

// --- Page d'accueil ---
class AccueilPage extends StatefulWidget {
  const AccueilPage({super.key});

  @override
  State<AccueilPage> createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> {
  String _selectedCategoryPath = 'all';
  Key _listKey = const ValueKey('all');

  // LES VRAIES CATÉGORIES (sans Destock)
  final List<CategoryItem> _categories = [
    CategoryItem(titre: 'Tous', apiPath: 'all'),
    CategoryItem(titre: 'Electroménagers', apiPath: 'ELECTROMENAGER'),
    CategoryItem(titre: 'Véhicules', apiPath: 'VEHICULE'),
    CategoryItem(titre: 'Electroniques & Informatiques', apiPath: 'ELECTRONIQUE_INFORMATIQUE'),
    CategoryItem(titre: 'Meubles & Décorations', apiPath: 'MEUBLE_DECORATION'),
    CategoryItem(titre: 'Accessoires', apiPath: 'ACCESSOIRE'),
  ];

  void _selectCategory(String apiPath) {
    if (_selectedCategoryPath == apiPath) return;
    setState(() {
      _selectedCategoryPath = apiPath;
      _listKey = ValueKey(apiPath);
    });
  }

  Future<List<Article>> _fetchArticles() async {
    // TON APPEL API ICI
    // Pour l'instant des données de test avec images correspondantes
    await Future.delayed(const Duration(seconds: 1));
    
    List<Article> articles = [
      Article(
        id: '1',
        titre: 'iPhone 12 Pro 128GB',
        description: 'iPhone 12 Pro en excellent état avec boîte d\'origine et tous les accessoires. Batterie à 92%. Aucune rayure.',
        prix: 420000,
        categorie: 'ELECTRONIQUE_INFORMATIQUE',
        images: ['https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=400&fit=crop'], // Image téléphone
        vendeurNom: 'Yao Kokou',
        ville: 'Lomé, Togo',
        etat: 'très bon',
      ),
      Article(
        id: '2',
        titre: 'Réfrigérateur Samsung 500L',
        description: 'Réfrigérateur neuf jamais utilisé, garantie 2 ans',
        prix: 250000,
        categorie: 'ELECTROMENAGER',
        images: ['https://images.unsplash.com/photo-1571175443880-49e1d25b2bc5?w=400&fit=crop'], // Image réfrigérateur
        vendeurNom: 'Kofi Mensah',
        ville: 'Lomé',
        etat: 'neuf',
      ),
      Article(
        id: '3',
        titre: 'Moto Yamaha 125cc 2022',
        description: 'Moto en très bon état, entretien régulier, 15000 km',
        prix: 850000,
        categorie: 'VEHICULE',
        images: ['https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400&fit=crop'], // Image moto
        vendeurNom: 'Jean Dupont',
        ville: 'Lomé',
        etat: 'bon',
      ),
      Article(
        id: '4',
        titre: 'Canapé 3 places cuir',
        description: 'Beau canapé en cuir marron, très confortable',
        prix: 180000,
        categorie: 'MEUBLE_DECORATION',
        images: ['https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=400&fit=crop'], // Image canapé
        vendeurNom: 'Marie Koffi',
        ville: 'Lomé',
        etat: 'occasion',
      ),
      Article(
        id: '5',
        titre: 'TV Samsung 55" 4K',
        description: 'Smart TV 4K UHD, presque neuve',
        prix: 300000,
        categorie: 'ELECTROMENAGER',
        images: ['https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?w=400&fit=crop'], // Image TV
        vendeurNom: 'Paul Adji',
        ville: 'Lomé',
        etat: 'excellent',
      ),
      Article(
        id: '6',
        titre: 'Voiture Peugeot 206',
        description: 'Voiture en bon état général, 120000 km',
        prix: 2200000,
        categorie: 'VEHICULE',
        images: ['https://images.unsplash.com/photo-1549399542-7e3f8b79c341?w=400&fit=crop'], // Image voiture
        vendeurNom: 'Martin Agbé',
        ville: 'Kpalimé',
        etat: 'bon',
      ),
      Article(
        id: '7',
        titre: 'Ordinateur Portable Dell',
        description: 'Intel i7, 16GB RAM, SSD 512GB',
        prix: 320000,
        categorie: 'ELECTRONIQUE_INFORMATIQUE',
        images: ['https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=400&fit=crop'], // Image ordinateur
        vendeurNom: 'Sarah Koné',
        ville: 'Lomé',
        etat: 'très bon',
      ),
      Article(
        id: '8',
        titre: 'Table basse design',
        description: 'Table basse en bois massif, design moderne',
        prix: 75000,
        categorie: 'MEUBLE_DECORATION',
        images: ['https://images.unsplash.com/photo-1556228453-efd6c1ff04f6?w=400&fit=crop'], // Image table
        vendeurNom: 'Julie Ahou',
        ville: 'Lomé',
        etat: 'neuf',
      ),
    ];

    // Filtrer par catégorie
    if (_selectedCategoryPath != 'all') {
      articles = articles.where((a) => a.categorie == _selectedCategoryPath).toList();
    }

    return articles;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'MIABE DESTOCK', // ← NOM CHANGÉ
          style: TextStyle(
            color: Color(0xFF7C3AED),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Container(
          padding: const EdgeInsets.all(8.0),
          child: const Icon(Icons.shopping_bag, color: Color(0xFF7C3AED), size: 28),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
          ),
        ],
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher des produits...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Catégories horizontales
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category.apiPath == _selectedCategoryPath;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: GestureDetector(
                    onTap: () => _selectCategory(category.apiPath),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF7C3AED) : Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          category.titre,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // Grille d'articles
          Expanded(
            child: FutureBuilder<List<Article>>(
              key: _listKey,
              future: _fetchArticles(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF7C3AED)),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 60, color: Colors.red),
                        const SizedBox(height: 16),
                        Text('Erreur: ${snapshot.error}'),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox, size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Aucun article disponible',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                final articles = snapshot.data!;

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    return GestureDetector(
                      onTap: () {
                        // Navigation vers la page de détails
                        // Navigator.push(context, MaterialPageRoute(builder: (_) => DetailArticle(article: article)));
                      },
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                  child: article.imagePrincipale.isNotEmpty
                                      ? Image.network(
                                          article.imagePrincipale,
                                          height: 130,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => Container(
                                            height: 130,
                                            color: Colors.grey[300],
                                            child: const Icon(Icons.image, size: 50),
                                          ),
                                        )
                                      : Container(
                                          height: 130,
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.image, size: 50),
                                        ),
                                ),
                                // Badge état
                                if (article.etat != null)
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black87,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        article.etat!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),

                            // Informations
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    article.titre,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    article.prixFormate,
                                    style: const TextStyle(
                                      color: Color(0xFF7C3AED),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  if (article.ville != null) ...[
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          size: 12,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            article.ville!,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 11,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}