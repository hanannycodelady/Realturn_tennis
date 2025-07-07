import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:realturn_app/Screens/Players_overview.dart';
import 'package:realturn_app/models/PlayerCard.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FemalePlayer extends StatefulWidget {
  const FemalePlayer({Key? key, required String image1, required String name, required String image2, required String details, required playerName}) : super(key: key);

  @override
  _FemalePlayerState createState() => _FemalePlayerState();
}

class _FemalePlayerState extends State<FemalePlayer> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final DatabaseReference _playersRef = FirebaseDatabase.instance.ref('players');
  
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  List<PlayerCard> allPlayers = [];
  List<PlayerCard> filteredPlayers = [];
  bool isLoading = true;
  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack));
    
    fetchFemalePlayersFromFirebase();
    _searchController.addListener(_filterPlayers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> fetchFemalePlayersFromFirebase() async {
    try {
      setState(() => isLoading = true);

      final snapshot = await _playersRef.get();

      if (snapshot.exists) {
        List<PlayerCard> players = [];

        if (snapshot.value is List) {
          List<dynamic> playersData = snapshot.value as List<dynamic>;
          for (int i = 0; i < playersData.length; i++) {
            if (playersData[i] != null) {
              Map<String, dynamic> playerData = Map<String, dynamic>.from(playersData[i]);
              if (playerData['gender']?.toString().toLowerCase() == 'female' ||
                  playerData['gender']?.toString().toLowerCase() == 'f') {
                players.add(PlayerCard.fromFirebaseJson(playerData));
              }
            }
          }
        } else {
          Map<String, dynamic> playersData = Map<String, dynamic>.from(snapshot.value as Map);
          playersData.forEach((key, value) {
            if (value != null) {
              Map<String, dynamic> playerData = Map<String, dynamic>.from(value);
              if (playerData['gender']?.toString().toLowerCase() == 'female' ||
                  playerData['gender']?.toString().toLowerCase() == 'f') {
                players.add(PlayerCard.fromFirebaseJson(playerData));
              }
            }
          });
        }

        setState(() {
          allPlayers = players;
          filteredPlayers = players;
          isLoading = false;
        });
        
        _fadeController.forward();
        _slideController.forward();
      } else {
        setState(() {
          allPlayers = [];
          filteredPlayers = [];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        _showErrorSnackBar('Error fetching players: $e');
      }
    }
  }

  void _filterPlayers() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredPlayers = allPlayers.where((player) {
        return player.fullName.toLowerCase().contains(query) ||
            (player.country?.toLowerCase().contains(query) ?? false) ||
            (player.nationality.toLowerCase().contains(query));
      }).toList();
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message, maxLines: 2, overflow: TextOverflow.ellipsis)),
          ],
        ),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          _buildHeader(),
          _buildSearchAndFilter(),
          _buildTitle(),
          Expanded(child: _buildPlayersList()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue[700]!,
            Colors.blue[500]!,
            Colors.blue[300]!,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue[200]!.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              "Women's Tennis",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                _isGridView ? Icons.view_list : Icons.grid_view,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _isGridView = !_isGridView;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300]!,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: "Search players by name or country...",
            hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
            prefixIcon: Icon(Icons.search, color: Colors.blue[600], size: 24),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey[500]),
                    onPressed: () {
                      _searchController.clear();
                      _filterPlayers();
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Female Players",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                "${filteredPlayers.length} players found",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          if (filteredPlayers.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, color: Colors.blue[600], size: 16),
                  const SizedBox(width: 4),
                  Text(
                    "Elite",
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlayersList() {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(strokeWidth: 3),
            SizedBox(height: 16),
            Text(
              "Loading players...",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    if (filteredPlayers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off,
                size: 64,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "No players found",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Try adjusting your search criteria",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: fetchFemalePlayersFromFirebase,
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: fetchFemalePlayersFromFirebase,
      color: Colors.blue[600],
      child: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: _isGridView ? _buildGridView() : _buildListView(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 1.8),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: filteredPlayers.length,
      itemBuilder: (context, index) {
        return _buildEnhancedPlayerCard(filteredPlayers[index], index);
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredPlayers.length,
      itemBuilder: (context, index) {
        return _buildListPlayerCard(filteredPlayers[index], index);
      },
    );
  }

  Widget _buildEnhancedPlayerCard(PlayerCard player, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      PlayerOverviewScreen(player: player),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: animation.drive(
                        Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                            .chain(CurveTween(curve: Curves.easeInOut)),
                      ),
                      child: child,
                    );
                  },
                ),
              );
            },
            child: Hero(
              tag: 'player_${player.fullName}_$index',
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      Colors.blue[50]!,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[300]!,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Header with ranking badge
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue[400]!, Colors.blue[600]!],
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: FittedBox(
                              child: Text(
                                "Ranking #${player.ranking ?? 0}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "Points ${player.points?.toInt() ?? 0}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Player content
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [Colors.blue[100]!, Colors.blue[200]!],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue[200]!,
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: _buildPlayerImage(player),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Flexible(
                              child: Text(
                                player.fullName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Flexible(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildFlag(player),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      player.nationality.isNotEmpty ? player.nationality : 'Unknown',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey[600],
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildListPlayerCard(PlayerCard player, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 200 + (index * 50)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[200]!,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.blue[100]!, Colors.blue[200]!],
                    ),
                  ),
                  child: ClipOval(child: _buildPlayerImage(player)),
                ),
                title: Text(
                  player.fullName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Row(
                  children: [
                    _buildFlag(player),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        player.nationality.isNotEmpty ? player.nationality : 'Unknown',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.blue[600],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "Ranking #${player.ranking ?? 0}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Points ${player.points?.toInt() ?? 0}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayerOverviewScreen(player: player),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlayerImage(PlayerCard player) {
    bool isValidUrl(String? url) {
      if (url == null || url.isEmpty) return false;
      final uri = Uri.tryParse(url);
      if (uri == null || !uri.hasScheme || !uri.hasAuthority) return false;
      return url.contains('firebasestorage.googleapis.com') &&
             url.contains('alt=media') &&
             url.contains('token=');
    }

    if (player.playerImage != null && isValidUrl(player.playerImage)) {
      return CachedNetworkImage(
        imageUrl: player.playerImage!,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey[200],
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        errorWidget: (context, url, error) {
          return Container(
            color: Colors.grey[200],
            child: Icon(
              Icons.person,
              size: 40,
              color: Colors.grey[600],
            ),
          );
        },
      );
    }

    return Container(
      color: Colors.grey[200],
      child: Icon(
        Icons.person,
        size: 40,
        color: Colors.grey[600],
      ),
    );
  }

  Widget _buildFlag(PlayerCard player) {
    bool isValidUrl(String? url) {
      if (url == null || url.isEmpty) return false;
      final uri = Uri.tryParse(url);
      if (uri == null || !uri.hasScheme || !uri.hasAuthority) return false;
      return url.contains('firebasestorage.googleapis.com') &&
             url.contains('alt=media') &&
             url.contains('token=');
    }

    if (player.flagUrl.isNotEmpty && isValidUrl(player.flagUrl)) {
      return Container(
        width: 24,
        height: 16,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300]!,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: CachedNetworkImage(
            imageUrl: player.flagUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.grey[300],
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 1),
              ),
            ),
            errorWidget: (context, url, error) {
              return Container(
                color: Colors.grey[300],
                child: Center(
                  child: Text(
                    player.country?.substring(0, 2).toUpperCase() ?? 'NA',
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    return Container(
      width: 24,
      height: 16,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          player.country?.substring(0, 2).toUpperCase() ?? 'NA',
          style: const TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}