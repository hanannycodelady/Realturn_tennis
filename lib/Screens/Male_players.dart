import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:realturn_app/Screens/Players_overview.dart';
import 'package:realturn_app/models/PlayerCard.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MalePlayer extends StatefulWidget {
  const MalePlayer({
    Key? key,
    required String name,
    required String image1,
    required String details,
    required String image2,
    required playerName,
  }) : super(key: key);

  @override
  _MalePlayerState createState() => _MalePlayerState();
}

class _MalePlayerState extends State<MalePlayer> {
  final TextEditingController _searchController = TextEditingController();
  final DatabaseReference _playersRef = FirebaseDatabase.instance.ref('players');

  List<PlayerCard> allPlayers = [];
  List<PlayerCard> filteredPlayers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMalePlayersFromFirebase();
    _searchController.addListener(_filterPlayers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Fetch male players from Firebase Realtime Database
  Future<void> fetchMalePlayersFromFirebase() async {
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
              // Filter male players only
              if (playerData['gender']?.toString().toLowerCase() == 'male') {
                players.add(PlayerCard.fromFirebaseJson(playerData));
              }
            }
          }
        } else {
          Map<String, dynamic> playersData = Map<String, dynamic>.from(snapshot.value as Map);
          playersData.forEach((key, value) {
            if (value != null) {
              Map<String, dynamic> playerData = Map<String, dynamic>.from(value);
              // Filter male players only
              if (playerData['gender']?.toString().toLowerCase() == 'male') {
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
              "REAL TURN MEN PLAYERS",
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
                                "No male players found",
                                style: TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: fetchMalePlayersFromFirebase,
                                child: const Text("Retry"),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: fetchMalePlayersFromFirebase,
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

  // Helper method to build player image widget
  Widget _buildPlayerImage(String? imageUrl, {double size = 70}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: ClipOval(
        child: _isValidUrl(imageUrl)
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[300],
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) {
                  print('Error loading player image: $url - $error');
                  return Container(
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.person,
                      size: size * 0.6,
                      color: Colors.grey[700],
                    ),
                  );
                },
              )
            : Container(
                color: Colors.grey[300],
                child: Icon(
                  Icons.person,
                  size: size * 0.6,
                  color: Colors.grey[700],
                ),
              ),
      ),
    );
  }

  // Helper method to build flag widget
  Widget _buildFlagWidget(PlayerCard player) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: _isValidUrl(player.flagUrl)
          ? CachedNetworkImage(
              imageUrl: player.flagUrl,
              width: 20,
              height: 15,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 20,
                height: 15,
                color: Colors.grey[400],
                child: Center(
                  child: SizedBox(
                    width: 10,
                    height: 10,
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ),
                ),
              ),
              errorWidget: (context, url, error) {
                print('Error loading flag image: $url - $error');
                return Container(
                  width: 20,
                  height: 15,
                  color: Colors.grey[400],
                  child: Center(
                    child: Text(
                      _getCountryCode(player.country ?? player.nationality),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 8,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                );
              },
            )
          : Container(
              width: 20,
              height: 15,
              color: Colors.grey[400],
              child: Center(
                child: Text(
                  _getCountryCode(player.country ?? player.nationality),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 8,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
    );
  }

  // Helper method to validate URLs
  bool _isValidUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && 
             uri.hasAuthority && 
             (uri.scheme == 'http' || uri.scheme == 'https') &&
             url.contains('firebasestorage.googleapis.com');
    } catch (e) {
      return false;
    }
  }

  // Helper method to get country code from country name
  String _getCountryCode(String country) {
    if (country.isEmpty) return '--';
    
    // Map of common countries to their codes
    Map<String, String> countryMap = {
      'serbia': 'SR',
      'spain': 'ES',
      'russia': 'RU',
      'italy': 'IT',
      'greece': 'GR',
      'united states': 'US',
      'france': 'FR',
      'germany': 'DE',
      'united kingdom': 'UK',
      'australia': 'AU',
      'canada': 'CA',
      'brazil': 'BR',
      'argentina': 'AR',
      'poland': 'PL',
      'czech republic': 'CZ',
      'switzerland': 'CH',
      'austria': 'AT',
      'belgium': 'BE',
      'netherlands': 'NL',
      'sweden': 'SE',
      'norway': 'NO',
      'denmark': 'DK',
    };
    
    String lowerCountry = country.toLowerCase();
    return countryMap[lowerCountry] ?? country.substring(0, 2).toUpperCase();
  }

  Widget _buildPlayerCard(PlayerCard player) {
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
                _buildPlayerImage(player.playerImage),
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
                _buildFlagWidget(player),
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