// lib/acheteurs/accueil.dart
import 'package:flutter/material.dart';
import 'categorie.dart'; // Import du widget Categorie personnalisé

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
  final DateTime? datePublication;

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
    this.datePublication,
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
      datePublication: json['datePublication'] != null
          ? DateTime.parse(json['datePublication'])
          : null,
    );
  }

  String get prixFormate {
    final prixString = prix.toStringAsFixed(0);
    String result = '';
    int count = 0;
    
    for (int i = prixString.length - 1; i >= 0; i--) {
      result = prixString[i] + result;
      count++;
      if (count == 3 && i != 0) {
        result = ' $result';
        count = 0;
      }
    }
    
    return '$result FCFA';
  }

  String get imagePrincipale => images.isNotEmpty ? images[0] : '';

  String get dateFormatee {
    if (datePublication == null) return '20/01/2026';
    return '${datePublication!.day.toString().padLeft(2, '0')}/'
        '${datePublication!.month.toString().padLeft(2, '0')}/'
        '${datePublication!.year}';
  }
}

// --- Classe CategoryItem ---
class CategoryItem {
  final String titre;
  final String apiPath;
  final IconData? icon;

  CategoryItem({
    required this.titre,
    required this.apiPath,
    this.icon,
  });
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
  int _currentImageIndex = 0;
  late Future<List<Article>> _articlesFuture;

  // LES VRAIES CATÉGORIES
  final List<CategoryItem> _categories = [
    CategoryItem(titre: 'Tous', apiPath: 'all', icon: Icons.grid_view),
    CategoryItem(titre: 'Electroménagers', apiPath: 'ELECTROMENAGER', icon: Icons.kitchen),
    CategoryItem(titre: 'Véhicules', apiPath: 'VEHICULE', icon: Icons.directions_car),
    CategoryItem(titre: 'Electroniques & Informatiques', apiPath: 'ELECTRONIQUE_INFORMATIQUE', icon: Icons.laptop),
    CategoryItem(titre: 'Meubles & Décorations', apiPath: 'MEUBLE_DECORATION', icon: Icons.chair),
    CategoryItem(titre: 'Accessoires', apiPath: 'ACCESSOIRE', icon: Icons.shopping_cart),
  ];

  @override
  void initState() {
    super.initState();
    _articlesFuture = _fetchArticles();
  }

  void _selectCategory(String apiPath) {
    if (_selectedCategoryPath == apiPath) return;
    setState(() {
      _selectedCategoryPath = apiPath;
      _listKey = ValueKey(apiPath);
      _articlesFuture = _fetchArticles();
    });
  }

  void _showArticleDetails(Article article) {
    setState(() {
      _currentImageIndex = 0;
    });
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildDetailsModal(article),
    );
  }

  Widget _buildDetailsModal(Article article) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Header avec bouton fermer
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Handle pour drag
                    Expanded(
                      child: Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 2),
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),

              // Contenu scrollable
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Carousel d'images avec légendes
                      SizedBox(
                        height: 300,
                        child: article.images.isEmpty
                            ? Container(
                                color: Colors.grey[200],
                                child: const Center(
                                  child: Icon(Icons.image, size: 100, color: Colors.grey),
                                ),
                              )
                            : Stack(
                                children: [
                                  PageView.builder(
                                    itemCount: article.images.length,
                                    onPageChanged: (index) {
                                      setState(() => _currentImageIndex = index);
                                    },
                                    itemBuilder: (context, index) {
                                      return Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          Image.network(
                                            article.images[index],
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => Container(
                                              color: Colors.grey[200],
                                              child: const Icon(Icons.image, size: 100, color: Colors.grey),
                                            ),
                                          ),
                                          // Légende en bas de l'image
                                          Positioned(
                                            bottom: 0,
                                            left: 0,
                                            right: 0,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 12,
                                              ),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.bottomCenter,
                                                  end: Alignment.topCenter,
                                                  colors: [
                                                    Colors.black.withOpacity(0.7),
                                                    Colors.transparent,
                                                  ],
                                                ),
                                              ),
                                              child: Text(
                                                'Photo ${index + 1} sur ${article.images.length}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  // Indicateurs de page
                                  if (article.images.length > 1)
                                    Positioned(
                                      top: 16,
                                      left: 0,
                                      right: 0,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: List.generate(
                                          article.images.length,
                                          (index) => Container(
                                            width: 8,
                                            height: 8,
                                            margin: const EdgeInsets.symmetric(horizontal: 4),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: _currentImageIndex == index
                                                  ? Colors.white
                                                  : Colors.white.withOpacity(0.5),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  // Badge état
                                  if (article.etat != null)
                                    Positioned(
                                      top: 16,
                                      right: 16,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black87,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          article.etat!,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                      ),

                      // Contenu
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Titre
                            Text(
                              article.titre,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Prix
                            Text(
                              article.prixFormate,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF7C3AED),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Infos (catégorie, localisation, date)
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    article.categorie,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                                if (article.ville != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.location_on, size: 16),
                                        const SizedBox(width: 4),
                                        Text(
                                          article.ville!,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.calendar_today, size: 14),
                                      const SizedBox(width: 4),
                                      Text(
                                        article.dateFormatee,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Section Description
                            const Text(
                              'Description',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              article.description,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                height: 1.5,
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Section Vendeur
                            const Text(
                              'Vendeur',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: const Color(0xFF7C3AED),
                                  child: Text(
                                    article.vendeurNom.isNotEmpty
                                        ? article.vendeurNom[0].toUpperCase()
                                        : 'V',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        article.vendeurNom,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (article.ville != null)
                                        Text(
                                          article.ville!,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 32),

                            // Boutons d'action
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      // Action message
                                    },
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: const Color(0xFF7C3AED),
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      side: const BorderSide(color: Color(0xFF7C3AED)),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    icon: const Icon(Icons.message_outlined),
                                    label: const Text('Message'),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      // Action appeler
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF7C3AED),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    icon: const Icon(Icons.phone),
                                    label: const Text('Appeler'),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<List<Article>> _fetchArticles() async {
    await Future.delayed(const Duration(seconds: 1));
    
    List<Article> articles = [
      Article(
        id: '1',
        titre: 'iPhone 12 Pro 128GB',
        description: 'iPhone 12 Pro en excellent état avec boîte d\'origine et tous les accessoires. Batterie à 92%. Aucune rayure.',
        prix: 420000,
        categorie: 'ELECTRONIQUE_INFORMATIQUE',
        images: [
          'https://images.unsplash.com/photo-1591337676887-a217a6970a8a?w=600&fit=crop', // iPhone bleu
          'https://images.unsplash.com/photo-1592286927505-f0e0b6c6e707?w=600&fit=crop', // iPhone côté
        ],
        vendeurNom: 'Yao Kokou',
        ville: 'Lomé, Togo',
        etat: 'très bon',
        datePublication: DateTime(2026, 1, 19),
      ),
      Article(
        id: '2',
        titre: 'Réfrigérateur Samsung 500L',
        description: 'Réfrigérateur neuf jamais utilisé, garantie 2 ans. Classe énergétique A++. Double porte avec distributeur d\'eau.',
        prix: 250000,
        categorie: 'ELECTROMENAGER',
        images: [
          'https://images.unsplash.com/photo-1571175443880-49e1d25b2bc5?w=600&fit=crop', // Réfrigérateur
          'https://images.unsplash.com/photo-1584568694244-14fbdf83bd30?w=600&fit=crop', // Cuisine moderne
        ],
        vendeurNom: 'Kofi Mensah',
        ville: 'Lomé',
        etat: 'neuf',
        datePublication: DateTime(2026, 1, 18),
      ),
      Article(
        id: '3',
        titre: 'Moto Yamaha 125cc 2022',
        description: 'Moto en très bon état, entretien régulier, 15000 km. Idéale pour se déplacer en ville. Papiers à jour.',
        prix: 850000,
        categorie: 'VEHICULE',
        images: [
          'https://images.unsplash.com/photo-1609630875171-b1321377ee65?w=600&fit=crop', // Moto moderne
          'https://images.unsplash.com/photo-1558980664-769d59546b3d?w=600&fit=crop', // Moto détail
        ],
        vendeurNom: 'Jean Dupont',
        ville: 'Lomé, Togo',
        etat: 'bon',
        datePublication: DateTime(2026, 1, 20),
      ),
      Article(
        id: '4',
        titre: 'Canapé 3 places en cuir',
        description: 'Beau canapé en cuir marron, très confortable. En excellent état, aucune déchirure.',
        prix: 180000,
        categorie: 'MEUBLE_DECORATION',
        images: [
          'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=600&fit=crop', // Salon moderne
          'https://images.unsplash.com/photo-1493663284031-b7e3aefcae8e?w=600&fit=crop', // Canapé gros plan
        ],
        vendeurNom: 'Marie Koffi',
        ville: 'Lomé',
        etat: 'bon',
        datePublication: DateTime(2026, 1, 15),
      ),
      Article(
        id: '5',
        titre: 'MacBook Pro 2021 M1',
        description: 'MacBook Pro puce M1, 16GB RAM, 512GB SSD. Comme neuf, utilisé 6 mois seulement.',
        prix: 950000,
        categorie: 'ELECTRONIQUE_INFORMATIQUE',
        images: [
          'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=600&fit=crop', // MacBook bureau
          'https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?w=600&fit=crop', // MacBook fermé
        ],
        vendeurNom: 'Alex Martin',
        ville: 'Lomé',
        etat: 'très bon',
        datePublication: DateTime(2026, 1, 22),
      ),
      Article(
        id: '6',
        titre: 'Montre connectée Samsung',
        description: 'Montre Galaxy Watch 4, toutes les fonctionnalités santé. Bracelet sport inclus.',
        prix: 85000,
        categorie: 'ACCESSOIRE',
        images: [
          'https://images.unsplash.com/photo-1579586337278-3befd40fd17a?w=600&fit=crop', // Smartwatch
          'https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?w=600&fit=crop', // Montre détail
        ],
        vendeurNom: 'Sophie Laurent',
        ville: 'Lomé, Togo',
        etat: 'neuf',
        datePublication: DateTime(2026, 1, 25),
      ),
    ];

    if (_selectedCategoryPath != 'all') {
      articles = articles.where((a) => a.categorie == _selectedCategoryPath).toList();
    }

    return articles;
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          top: BorderSide(color: Colors.grey[200]!, width: 1),
        ),
      ),
      child: Column(
        children: [
          // Logo
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF7C3AED).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_bag,
              color: Color(0xFF7C3AED),
              size: 32,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'MIABE DESTOCK',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF7C3AED),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '© ${DateTime.now().year} Tous droits réservés',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          // Liens sociaux
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.facebook, color: Colors.grey[600]),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.phone, color: Colors.grey[600]),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.email, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'MIABE DESTOCK',
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
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          // Catégories horizontales avec widget personnalisé
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
                  child: Categorie(
                    titre: category.titre,
                    icon: category.icon ?? Icons.grid_view,
                    isSelected: isSelected,
                    onTap: () => _selectCategory(category.apiPath),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // Nombre d'annonces
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: FutureBuilder<List<Article>>(
              future: _articlesFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${snapshot.data!.length} annonce${snapshot.data!.length > 1 ? 's' : ''}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),

          const SizedBox(height: 8),

          // Grille d'articles avec footer
          Expanded(
            child: FutureBuilder<List<Article>>(
              key: _listKey,
              future: _articlesFuture,
              builder: (context, snapshot) {
                // État de chargement
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF7C3AED)),
                  );
                }

                // État d'erreur
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 60, color: Colors.red),
                        const SizedBox(height: 16),
                        Text('Erreur: ${snapshot.error}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _articlesFuture = _fetchArticles();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7C3AED),
                          ),
                          child: const Text('Réessayer'),
                        ),
                      ],
                    ),
                  );
                }

                // Aucune donnée
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.inbox, size: 80, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text(
                          'Aucun article disponible',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Essayez une autre catégorie',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                }

                final articles = snapshot.data!;

                return CustomScrollView(
                  slivers: [
                    // Grille d'articles
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final article = articles[index];
                            return GestureDetector(
                              onTap: () => _showArticleDetails(article),
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Image avec badge
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
                          childCount: articles.length,
                        ),
                      ),
                    ),
                    
                    // Footer
                    SliverToBoxAdapter(
                      child: _buildFooter(),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}