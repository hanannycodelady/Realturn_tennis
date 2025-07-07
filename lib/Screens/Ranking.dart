import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:realturn_app/Screens/Home_screen.dart';

class RankingsScreen extends StatefulWidget {
  const RankingsScreen({Key? key}) : super(key: key);

  @override
  _RankingsScreenState createState() => _RankingsScreenState();
}

class _RankingsScreenState extends State<RankingsScreen> with TickerProviderStateMixin {
  String currentCategory = 'Men';
  List<Player> malePlayers = [];
  List<Player> femalePlayers = [];
  bool isLoading = true;
  late AnimationController _fadeController;
  late AnimationController _slideController;

  final List<String> categories = ['Men', 'Women'];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fetchPlayersFromFirebase();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _fetchPlayersFromFirebase() async {
    try {
      DatabaseReference playersRef = FirebaseDatabase.instance.ref('players');
      DatabaseEvent event = await playersRef.once();
      
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> playersData = event.snapshot.value as Map<dynamic, dynamic>;
        List<Player> fetchedMalePlayers = [];
        List<Player> fetchedFemalePlayers = [];
        
        playersData.forEach((key, value) {
          if (value is Map) {
            Player player = Player.fromFirebase(key, Map<String, dynamic>.from(value));
            if (player.gender?.toLowerCase() == 'male') {
              fetchedMalePlayers.add(player);
            } else if (player.gender?.toLowerCase() == 'female') {
              fetchedFemalePlayers.add(player);
            }
          }
        });
        
        fetchedMalePlayers.sort((a, b) => a.rank.compareTo(b.rank));
        fetchedFemalePlayers.sort((a, b) => a.rank.compareTo(b.rank));
        
        setState(() {
          malePlayers = fetchedMalePlayers;
          femalePlayers = fetchedFemalePlayers;
          isLoading = false;
        });
        
        _fadeController.forward();
        _slideController.forward();
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching players: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0D47A1), // Dark blue
              Color(0xFF1976D2), // Primary blue
              Color(0xFF42A5F5), // Light blue
              Color(0xFF1565C0), // Mid blue
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildGlassmorphicHeader(),
              Expanded(
                child: isLoading
                    ? _buildLoadingState()
                    : (currentCategory == 'Men' ? malePlayers : femalePlayers).isEmpty
                        ? _buildEmptyState()
                        : _buildPlayersList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassmorphicHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                        );
                      },
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.emoji_events,
                            color: Colors.amber,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'PLAYER RANKINGS',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.3),
                                    offset: const Offset(2, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
              _buildCategoryTabs(),
              _buildColumnHeaders(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: categories.map((category) {
          bool isSelected = currentCategory == category;
          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isSelected 
                    ? Colors.amber.withOpacity(0.2)
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected ? Colors.amber : Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: InkWell(
                onTap: () {
                  setState(() {
                    currentCategory = category;
                    _slideController.reset();
                    _slideController.forward();
                  });
                },
                borderRadius: BorderRadius.circular(12),
                child: Center(
                  child: Text(
                    category.toUpperCase(),
                    style: TextStyle(
                      color: isSelected ? Colors.amber : Colors.white,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildColumnHeaders() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildColumnHeader('RANK', flex: 1),
          _buildColumnHeader('PLAYER', flex: 3),
          _buildColumnHeader('COUNTRY', flex: 2),
          _buildColumnHeader('AGE', flex: 1),
          _buildColumnHeader('POINTS', flex: 1),
        ],
      ),
    );
  }

  Widget _buildColumnHeader(String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withOpacity(0.8),
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        textAlign: flex == 1 ? TextAlign.center : TextAlign.left,
      ),
    );
  }

  Widget _buildPlayersList() {
    List<Player> currentPlayers = currentCategory == 'Men' ? malePlayers : femalePlayers;
    return FadeTransition(
      opacity: _fadeController,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: currentPlayers.length,
              itemBuilder: (context, index) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _slideController,
                    curve: Interval(
                      index * 0.1,
                      (index * 0.1) + 0.3,
                      curve: Curves.easeOutCubic,
                    ),
                  )),
                  child: _buildPlayerCard(currentPlayers[index], index),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerCard(Player player, int index) {
    Color rankColor = _getRankColor(player.rank);
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withOpacity(0.08),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          // Handle player tap
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                child: Column(
                  children: [
                    if (player.rank <= 3)
                      Icon(
                        Icons.emoji_events,
                        color: rankColor,
                        size: 20,
                      ),
                    Text(
                      player.rank.toString(),
                      style: TextStyle(
                        color: rankColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: rankColor.withOpacity(0.5),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: rankColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: player.playerImage != null && player.playerImage!.isNotEmpty
                            ? Image.network(
                                player.playerImage!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      color: Colors.grey[700],
                                      child: const Icon(Icons.person, color: Colors.white),
                                    ),
                              )
                            : Container(
                                color: Colors.grey[700],
                                child: const Icon(Icons.person, color: Colors.white),
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${player.firstName} ${player.lastName}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (player.nationality != null)
                            Text(
                              player.nationality!,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: player.flagImage != null && player.flagImage!.isNotEmpty
                      ? Container(
                          width: 32,
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.network(
                              player.flagImage!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(color: Colors.grey[600]),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    player.age.toString(),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        player.points.toStringAsFixed(0),
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'pts',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 10,
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
    );
  }

  Color _getRankColor(int rank) {
    if (rank == 1) return const Color(0xFFFFD700); // Gold
    if (rank == 2) return const Color(0xFFC0C0C0); // Silver
    if (rank == 3) return const Color(0xFFCD7F32); // Bronze
    if (rank <= 10) return Colors.amber;
    return Colors.white;
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading Rankings...',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(40),
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.emoji_events_outlined,
              size: 64,
              color: Colors.white.withOpacity(0.6),
            ),
            const SizedBox(height: 16),
            Text(
              'No Players Found',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Rankings will appear here once players are added.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class Player {
  final String id;
  final String firstName;
  final String lastName;
  final int rank;
  final int age;
  final String? nationality;
  final String? flagImage;
  final double points;
  final String? playerImage;
  final String? category;
  final String? gender;
  final String? coachName;
  final String? height;
  final String? dateOfBirth;
  final int? createdAt;
  final int? updatedAt;

  Player({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.rank,
    required this.age,
    this.nationality,
    this.flagImage,
    required this.points,
    this.playerImage,
    this.category,
    this.gender,
    this.coachName,
    this.height,
    this.dateOfBirth,
    this.createdAt,
    this.updatedAt,
  });

  factory Player.fromFirebase(String id, Map<String, dynamic> data) {
    return Player(
      id: id,
      firstName: data['first_name'] ?? '',
      lastName: data['second_name'] ?? '',
      rank: int.tryParse(data['ranking']?.toString() ?? '0') ?? 0,
      age: int.tryParse(data['age']?.toString() ?? '0') ?? 0,
      nationality: data['nationality'],
      flagImage: data['flag_image'],
      points: double.tryParse(data['points']?.toString() ?? '0') ?? 0.0,
      playerImage: data['player_image'],
      category: data['category'],
      gender: data['gender'],
      coachName: data['coach_name'],
      height: data['height'],
      dateOfBirth: data['date_of_birth'],
      createdAt: data['created_at'],
      updatedAt: data['updated_at'],
    );
  }
}