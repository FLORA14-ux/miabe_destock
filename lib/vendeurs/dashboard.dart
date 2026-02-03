import 'package:flutter/material.dart';

class DashboardVendeur extends StatefulWidget {
  const DashboardVendeur({Key? key}) : super(key: key);

  @override
  _DashboardVendeurState createState() => _DashboardVendeurState();
}

class Article {
  final String id;
  final String titre;
  final double prix; // Prix en FCFA
  final int vues;
  final int messages;
  final String date;
  final String imageUrl;

  Article({
    required this.id,
    required this.titre,
    required this.prix,
    required this.vues,
    required this.messages,
    required this.date,
    required this.imageUrl,
  });
  
  // Formater le prix en FCFA
  String get prixFormate {
    if (prix >= 1000000) {
      return '${(prix / 1000000).toStringAsFixed(1)}M FCFA';
    } else if (prix >= 1000) {
      return '${(prix / 1000).toStringAsFixed(0)}k FCFA';
    } else {
      return '${prix.toInt()} FCFA';
    }
  }
  
  // Formater le prix avec séparateurs de milliers
  String get prixDetail {
    // Format: 250 000 FCFA
    String prixStr = prix.toInt().toString();
    String formatted = '';
    
    for (int i = prixStr.length - 1, count = 0; i >= 0; i--, count++) {
      formatted = prixStr[i] + formatted;
      if (count % 3 == 2 && i != 0) {
        formatted = ' $formatted';
      }
    }
    
    return '$formatted FCFA';
  }
}

class _DashboardVendeurState extends State<DashboardVendeur> {
  List<Article> _articles = [];
  bool _isLoading = false;
  bool _showEmptyState = false;

  // Statistiques
  int _totalArticles = 0;
  int _totalVues = 0;
  int _totalMessages = 0;

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  Future<void> _loadArticles() async {
    setState(() {
      _isLoading = true;
    });

    // Simuler un chargement réseau
    await Future.delayed(const Duration(seconds: 1));

    // Données de test avec prix en FCFA
    final testArticles = [
      Article(
        id: '1',
        titre: 'iPhone 13 Pro Max',
        prix: 599900, // 599 900 FCFA
        vues: 245,
        messages: 12,
        date: '15/01',
        imageUrl: 'https://picsum.photos/300/200?random=1',
      ),
      Article(
        id: '2',
        titre: 'Canon EOS R5',
        prix: 2349999, // 2 349 999 FCFA
        vues: 189,
        messages: 8,
        date: '14/01',
        imageUrl: 'https://picsum.photos/300/200?random=2',
      ),
      Article(
        id: '3',
        titre: 'MacBook Pro 16"',
        prix: 1675000, // 1 675 000 FCFA
        vues: 312,
        messages: 15,
        date: '13/01',
        imageUrl: 'https://picsum.photos/300/200?random=3',
      ),
      Article(
        id: '4',
        titre: 'Sony WH-1000XM4',
        prix: 234500, // 234 500 FCFA
        vues: 178,
        messages: 6,
        date: '12/01',
        imageUrl: 'https://picsum.photos/300/200?random=4',
      ),
      Article(
        id: '5',
        titre: 'Air Jordan 1',
        prix: 85000, // 85 000 FCFA
        vues: 95,
        messages: 3,
        date: '11/01',
        imageUrl: 'https://picsum.photos/300/200?random=5',
      ),
      Article(
        id: '6',
        titre: 'PlayStation 5',
        prix: 425000, // 425 000 FCFA
        vues: 210,
        messages: 9,
        date: '10/01',
        imageUrl: 'https://picsum.photos/300/200?random=6',
      ),
    ];

    setState(() {
      _articles = testArticles;
      _totalArticles = testArticles.length;
      _totalVues = testArticles.fold(0, (sum, article) => sum + article.vues);
      _totalMessages = testArticles.fold(0, (sum, article) => sum + article.messages);
      _showEmptyState = testArticles.isEmpty;
      _isLoading = false;
    });
  }

  Future<void> _onRefresh() async {
    await _loadArticles();
  }

  void _openArticleDetails(Article article) {
    // Navigation vers la page détails
    print('Ouvrir détails: ${article.titre} - ${article.prixDetail}');
  }

  // Fonction pour ouvrir le formulaire d'ajout
  void _ouvrirFormulaireAjout() {
    // Remplacer par votre navigation vers le formulaire d'ajout
    print('Ouvrir formulaire d\'ajout d\'annonce');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Formulaire d\'ajout'),
        content: const Text('Cette fonctionnalité ouvrira votre formulaire d\'ajout d\'annonce.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mon Dashboard',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      body: _buildBody(),
      // BOUTON FLOTTANT POUR AJOUTER UNE ANNONCE
      floatingActionButton: FloatingActionButton(
        onPressed: _ouvrirFormulaireAjout,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 5,
        child: const Icon(Icons.add, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
        ),
      );
    }

    if (_showEmptyState) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: Colors.deepPurple,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // Section Statistiques
            _buildStatsSection(),
            
            // Section Liste des articles
            _buildArticlesGrid(),
            
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.deepPurple[50],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem(
                icon: Icons.inventory,
                label: 'Articles',
                value: _totalArticles.toString(),
                color: Colors.blue,
              ),
              _buildStatItem(
                icon: Icons.visibility,
                label: 'Vues',
                value: _totalVues.toString(),
                color: Colors.green,
              ),
              _buildStatItem(
                icon: Icons.message,
                label: 'Messages',
                value: _totalMessages.toString(),
                color: Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Column(
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
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
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
      ),
    );
  }

  Widget _buildArticlesGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'Mes annonces',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemCount: _articles.length,
            itemBuilder: (context, index) {
              final article = _articles[index];
              return _buildArticleCard(article);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildArticleCard(Article article) {
    return GestureDetector(
      onTap: () => _openArticleDetails(article),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image avec badge de vues
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.network(
                    article.imageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 120,
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120,
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(Icons.photo, color: Colors.grey),
                        ),
                      );
                    },
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
                      color: Colors.black.withOpacity(0.7),
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
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            // Infos de l'article
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      article.titre,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      article.prixFormate, // Formaté en FCFA (ex: "600k FCFA")
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.message,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${article.messages}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          article.date,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: Colors.deepPurple,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inventory,
                  size: 80,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Aucune annonce publiée',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Commencez par créer votre première annonce pour vendre vos articles',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _ouvrirFormulaireAjout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Créer une annonce',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}