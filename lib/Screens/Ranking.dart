import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class RankingsScreen extends StatefulWidget {
  const RankingsScreen({Key? key}) : super(key: key);

  @override
  _RankingsScreenState createState() => _RankingsScreenState();
}

class _RankingsScreenState extends State<RankingsScreen> {
  String currentCategory = 'SINGLES RANKINGS';
  List<Player> players = [];
  bool isLoading = true;

  final List<String> categories = [
    'SINGLES RANKINGS',
  ];

  @override
  void initState() {
    super.initState();
    _fetchPlayersFromFirebase();
  }

  Future<void> _fetchPlayersFromFirebase() async {
    try {
      DatabaseReference playersRef = FirebaseDatabase.instance.ref('players');
      DatabaseEvent event = await playersRef.once();
      
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> playersData = event.snapshot.value as Map<dynamic, dynamic>;
        List<Player> fetchedPlayers = [];
        
        playersData.forEach((key, value) {
          if (value is Map) {
            fetchedPlayers.add(Player.fromFirebase(key, Map<String, dynamic>.from(value)));
          }
        });
        
        // Sort players by ranking
        fetchedPlayers.sort((a, b) => a.rank.compareTo(b.rank));
        
        setState(() {
          players = fetchedPlayers;
          isLoading = false;
        });
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
      appBar: AppBar(
        title: const Text(''),
        automaticallyImplyLeading: false,
        flexibleSpace: _buildCategoryTabs(),
      ),
      body: Column(
        children: [
          const Divider(height: 1, color: Colors.grey),
          _buildColumnHeaders(),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : players.isEmpty
                    ? const Center(child: Text('No players found'))
                    : ListView.builder(
                        itemCount: players.length,
                        itemBuilder: (context, index) {
                          return _buildPlayerRow(players[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      color: Colors.black,
      child: Row(
        children: categories.map((category) {
          bool isSelected = currentCategory == category;
          return Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  currentCategory = category;
                });
              },
              child: Container(
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected ? Colors.white : Colors.transparent,
                      width: 4,
                    ),
                  ),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
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
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.white,
      child: Row(
        children: [
          _buildColumnHeader('Rank', flex: 1, isFirst: true),
          _buildColumnHeader('Player', flex: 3),
          _buildColumnHeader('Nationality', flex: 2),
          _buildColumnHeader('Age', flex: 1),
          _buildColumnHeader('Points', flex: 1, isLast: true),
        ],
      ),
    );
  }

  Widget _buildColumnHeader(String text,
      {required int flex,
      bool isFirst = false,
      bool isLast = false,
      bool isNumeric = false}) {
    return Expanded(
      flex: flex,
      child: Row(
        mainAxisAlignment:
            isNumeric ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (isFirst) const Icon(Icons.arrow_downward, size: 12),
          if (isFirst) const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (!isFirst && !isLast) const Icon(Icons.unfold_more, size: 12),
        ],
      ),
    );
  }

  Widget _buildPlayerRow(Player player) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE6E6E6), width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    player.rank.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 4),
                  const Text('-'),
                  const SizedBox(width: 4),
                  const Icon(Icons.star_border, size: 16),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  ClipOval(
                    child: Container(
                      width: 40,
                      height: 40,
                      color: Colors.grey[300],
                      child: player.playerImage != null && player.playerImage!.isNotEmpty
                          ? Image.network(
                              player.playerImage!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.person, size: 30),
                            )
                          : const Icon(Icons.person, size: 30),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${player.firstName} ',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: player.lastName,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  if (player.flagImage != null && player.flagImage!.isNotEmpty)
                    Container(
                      width: 24,
                      height: 16,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: Image.network(
                          player.flagImage!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: Colors.grey[300],
                                
                              ),
                        ),
                      ),
                    ),
                  Flexible(
                    child: Text(
                      player.nationality ?? '',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                player.age.toString(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                player.points.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
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