// lib/vendeurs/accueil_vendeur.dart
import 'package:flutter/material.dart';
import 'ajouter_article.dart';
import 'detail_article.dart';

// Classe Article pour le vendeur
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
  final int vues;
  final int messages;

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
    this.vues = 0,
    this.messages = 0,
  });

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
    if (datePublication == null) return '';
    return '${datePublication!.day}/${datePublication!.month}/${datePublication!.year}';
  }
}

class DashboardVendeur extends StatefulWidget {
  const DashboardVendeur({Key? key}) : super(key: key);

  @override
  State<DashboardVendeur> createState() => _DashboardVendeurState();
}

class _DashboardVendeurState extends State<DashboardVendeur> {
  final Color primaryColor = const Color(0xFF7C3AED);
  late Future<List<Article>> _articlesFuture;

  @override
  void initState() {
    super.initState();
    _articlesFuture = _fetchMesArticles();
  }

  Future<List<Article>> _fetchMesArticles() async {
    // Simuler un appel API
    await Future.delayed(const Duration(seconds: 1));
    
    // Articles de test - À REMPLACER par un vrai appel API
    return [
      Article(
        id: '1',
        titre: 'iPhone 12 Pro 128GB',
        description: 'iPhone 12 Pro en excellent état avec boîte d\'origine.',
        prix: 420000,
        categorie: 'ELECTRONIQUE_INFORMATIQUE',
        images: ['https://images.unsplash.com/photo-1591337676887-a217a6970a8a?w=600&fit=crop'],
        vendeurNom: 'Moi',
        ville: 'Lomé, Togo',
        etat: 'très bon',
        datePublication: DateTime(2026, 1, 19),
        vues: 245,
        messages: 12,
      ),
      Article(
        id: '2',
        titre: 'MacBook Pro 2021 M1',
        description: 'MacBook Pro puce M1, 16GB RAM, 512GB SSD.',
        prix: 950000,
        categorie: 'ELECTRONIQUE_INFORMATIQUE',
        images: ['https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=600&fit=crop'],
        vendeurNom: 'Moi',
        ville: 'Lomé',
        etat: 'très bon',
        datePublication: DateTime(2026, 1, 22),
        vues: 189,
        messages: 8,
      ),
      Article(
        id: '3',
        titre: 'Moto Yamaha 125cc 2022',
        description: 'Moto en très bon état, entretien régulier.',
        prix: 850000,
        categorie: 'VEHICULE',
        images: ['https://images.unsplash.com/photo-1609630875171-b1321377ee65?w=600&fit=crop'],
        vendeurNom: 'Moi',
        ville: 'Lomé, Togo',
        etat: 'bon',
        datePublication: DateTime(2026, 1, 20),
        vues: 312,
        messages: 15,
      ),
      Article(
        id: '4',
        titre: 'Réfrigérateur Samsung 500L',
        description: 'Réfrigérateur neuf jamais utilisé.',
        prix: 250000,
        categorie: 'ELECTROMENAGER',
        images: ['https://images.unsplash.com/photo-1571175443880-49e1d25b2bc5?w=600&fit=crop'],
        vendeurNom: 'Moi',
        ville: 'Lomé',
        etat: 'neuf',
        datePublication: DateTime(2026, 1, 18),
        vues: 178,
        messages: 6,
      ),
    ];
  }

  void _rafraichirListe() {
    setState(() {
      _articlesFuture = _fetchMesArticles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Mes articles',
          style: TextStyle(
            color: primaryColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.store, color: primaryColor, size: 28),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Notifications
            },
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined, color: Colors.black),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: const Text(
                      '3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Article>>(
        future: _articlesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: primaryColor),
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
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _rafraichirListe,
                    style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState();
          }

          final articles = snapshot.data!;

          return RefreshIndicator(
            onRefresh: () async {
              _rafraichirListe();
            },
            color: primaryColor,
            child: CustomScrollView(
              slivers: [
                // Statistiques
                SliverToBoxAdapter(
                  child: _buildStatistiques(articles),
                ),
                
                // Header "Mes articles"
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${articles.length} article${articles.length > 1 ? 's' : ''}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            // TODO: Filtrer/trier
                          },
                          icon: const Icon(Icons.filter_list, size: 20),
                          label: const Text('Filtrer'),
                          style: TextButton.styleFrom(
                            foregroundColor: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Grille d'articles
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
                        return _buildArticleCard(article);
                      },
                      childCount: articles.length,
                    ),
                  ),
                ),
                
                // Espace pour le bouton flottant
                const SliverToBoxAdapter(
                  child: SizedBox(height: 80),
                ),
              ],
            ),
          );
        },
      ),
      
      // Bouton flottant pour ajouter une annonce
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AjouterArticle(),
            ),
          );
          
          if (result == true) {
            _rafraichirListe();
          }
        },
        backgroundColor: primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Nouvelle annonce',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Widget état vide
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.inventory_2_outlined,
                size: 80,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Aucun article publié',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Commencez par publier votre\npremière annonce',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AjouterArticle(),
                  ),
                );
                
                if (result == true) {
                  _rafraichirListe();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Créer une annonce',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget statistiques
  Widget _buildStatistiques(List<Article> articles) {
    final totalVues = articles.fold(0, (sum, a) => sum + a.vues);
    final totalMessages = articles.fold(0, (sum, a) => sum + a.messages);
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Statistiques',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                icon: Icons.inventory_2,
                value: articles.length.toString(),
                label: 'Articles',
                color: primaryColor,
              ),
              _buildStatItem(
                icon: Icons.visibility,
                value: totalVues.toString(),
                label: 'Vues',
                color: Colors.blue,
              ),
              _buildStatItem(
                icon: Icons.message,
                value: totalMessages.toString(),
                label: 'Messages',
                color: Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  // Widget carte d'article
  Widget _buildArticleCard(Article article) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailArticleVendeur(article: article),
          ),
        );
        
        if (result == true) {
          _rafraichirListe();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
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
                // Badge vues
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
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.visibility,
                          size: 12,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${article.vues}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Contenu
            Padding(
              padding: const EdgeInsets.all(10),
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
                  const SizedBox(height: 6),
                  Text(
                    article.prixFormate,
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Stats en bas
                  Row(
                    children: [
                      Icon(
                        Icons.message,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${article.messages}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.calendar_today,
                        size: 12,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          article.dateFormatee,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}