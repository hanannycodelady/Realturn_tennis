import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:realturn_app/Screens/Players_overview.dart';
import 'package:realturn_app/models/PlayerCard.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FemalePlayer extends StatefulWidget {
  const FemalePlayer({
    Key? key,
    required String name,
    required String image1,
    required String details,
    required String image2,
    required playerName,
  }) : super(key: key);

  @override
  _FemalePlayerState createState() => _FemalePlayerState();
}

class _FemalePlayerState extends State<FemalePlayer> {
  final TextEditingController _searchController = TextEditingController();
  final DatabaseReference _playersRef = FirebaseDatabase.instance.ref('players');

  List<PlayerCard> allPlayers = [];
  List<PlayerCard> filteredPlayers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFemalePlayersFromFirebase();
    _searchController.addListener(_filterPlayers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Fetch female players from Firebase Realtime Database
  Future<void> fetchFemalePlayersFromFirebase() async {
    try {
      setState(() => isLoading = true);

      final snapshot = await _playersRef.get();

      if (snapshot.exists) {
        List<PlayerCard> players = [];

        // Handle both array and object structures
        if (snapshot.value is List) {
          List<dynamic> playersData = snapshot.value as List<dynamic>;
          for (int i = 0; i < playersData.length; i++) {
            if (playersData[i] != null) {
              Map<String, dynamic> playerData = Map<String, dynamic>.from(playersData[i]);
              // Filter for female players only
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
              // Filter for female players only
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching players: $e')),
        );
      }
      print('Error fetching players: $e');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(8, 40, 8, 8),
            color: Colors.white,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
                Flexible(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                            decoration: const InputDecoration(
                              hintText: "Search for player",
                              hintStyle: TextStyle(color: Colors.white70),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: Colors.blue[700],
            child: const Text(
              "REAL TURN WOMEN PLAYERS",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey[300],
              padding: const EdgeInsets.all(12),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredPlayers.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "No female players found",
                                style: TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: fetchFemalePlayersFromFirebase,
                                child: const Text("Retry"),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: fetchFemalePlayersFromFirebase,
                          child: GridView.builder(
                            padding: const EdgeInsets.all(8),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemCount: filteredPlayers.length,
                            itemBuilder: (context, index) {
                              final player = filteredPlayers[index];
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PlayerOverviewScreen(player: player),
                                      ),
                                    );
                                  },
                                  child: _buildPlayerCard(player),
                                ),
                              );
                            },
                          ),
                        ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerCard(PlayerCard player) {
    // Validate Firebase Storage URL
    bool isValidUrl(String? url) {
      if (url == null || url.isEmpty) return false;
      final uri = Uri.tryParse(url);
      if (uri == null || !uri.hasScheme || !uri.hasAuthority) return false;
      // Check for Firebase Storage URL pattern
      return url.contains('firebasestorage.googleapis.com') &&
             url.contains('alt=media') &&
             url.contains('token=');
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
            child: Column(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: ClipOval(
                    child: player.playerImage != null && isValidUrl(player.playerImage)
                        ? CachedNetworkImage(
                            imageUrl: player.playerImage!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) {
                              print('Error loading player image: $url - $error');
                              CachedNetworkImage.evictFromCache(url);
                              return Image.asset(
                                'assets/image/default_player.png',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  print('Error loading default player asset: $error');
                                  return Icon(
                                    Icons.person,
                                    size: 40,
                                    color: Colors.grey[700],
                                  );
                                },
                              );
                            },
                          )
                        : Image.asset(
                            'assets/image/default_player.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              print('Error loading default player asset: $error');
                              return Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.grey[700],
                              );
                            },
                          ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(height: 2, color: Colors.black),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: Column(
              children: [
                Text(
                  player.fullName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  player.nationality,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: player.flagUrl.isNotEmpty && isValidUrl(player.flagUrl)
                      ? CachedNetworkImage(
                          imageUrl: player.flagUrl,
                          width: 20,
                          height: 15,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          errorWidget: (context, url, error) {
                            print('Error loading flag image: $url - $error');
                            CachedNetworkImage.evictFromCache(url);
                            return Image.asset(
                              'assets/image/default_flag.png',
                              width: 20,
                              height: 15,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                print('Error loading default flag asset: $error');
                                return Text(
                                  player.country ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                );
                              },
                            );
                          },
                        )
                      : Image.asset(
                          'assets/image/default_flag.png',
                          width: 20,
                          height: 15,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            print('Error loading default flag asset: $error');
                            return Text(
                              player.country ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.black, width: 2)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(right: BorderSide(color: Colors.black, width: 1)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Singles",
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            (player.ranking ?? 0).toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "Ranking",
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Points",
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          (player.points ?? 0).toInt().toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
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
    );
  }
}