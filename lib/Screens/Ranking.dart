import 'package:flutter/material.dart';

class RankingsScreen extends StatefulWidget {
  const RankingsScreen({Key? key}) : super(key: key);

  @override
  _RankingsScreenState createState() => _RankingsScreenState();
}

class _RankingsScreenState extends State<RankingsScreen> {
  String currentCategory = 'SINGLES RANKINGS';
  String currentRegion = 'All Regions';

  final List<String> categories = [
    'SINGLES RANKINGS',
    'DOUBLES RANKINGS',
    'MIXED DOUBLES RANKING',
  ];

  final List<Player> players = [
    Player(
      id: 1,
      firstName: 'ARYNA',
      lastName: 'SABALENKA',
      rank: 1,
      previousRank: 1,
      age: 26,
      country: null,
      countryCode: null,
      points: 9606,
      tournamentsPlayed: 20,
      profileImage: 'assets/players/sabalenka.png',
    ),
    Player(
      id: 2,
      firstName: 'IGA',
      lastName: 'SWIATEK',
      rank: 2,
      previousRank: 2,
      age: 23,
      country: 'Poland',
      countryCode: 'POL',
      points: 7375,
      tournamentsPlayed: 17,
      profileImage: 'assets/players/swiatek.png',
    ),
    Player(
      id: 3,
      firstName: 'COCO',
      lastName: 'GAUFF',
      rank: 3,
      previousRank: 3,
      age: 21,
      country: 'United States',
      countryCode: 'USA',
      points: 6063,
      tournamentsPlayed: 21,
      profileImage: 'assets/players/gauff.png',
    ),
    Player(
      id: 4,
      firstName: 'JESSICA',
      lastName: 'PEGULA',
      rank: 4,
      previousRank: 4,
      age: 31,
      country: 'United States',
      countryCode: 'USA',
      points: 5361,
      tournamentsPlayed: 18,
      profileImage: 'assets/players/pegula.png',
    ),
  ];

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
          _buildFiltersBar(),
          const Divider(height: 1, color: Colors.grey),
          _buildColumnHeaders(),
          Expanded(
            child: ListView.builder(
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

  Widget _buildFiltersBar() {
    return Container(
      color: const Color(0xFFE6E6E6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _buildFilterButton(
              label: 'Filter by Region',
              value: currentRegion,
              icon: Icons.arrow_forward_ios,
              onTap: _showRegionPicker,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.deepPurple,
              fontSize: 12,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            children: [
              Flexible(
                child: Text(
                  value,
                  style: const TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                icon,
                color: Colors.deepPurple,
                size: 12,
              ),
            ],
          ),
        ],
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
          _buildColumnHeader('Region', flex: 1),
          _buildColumnHeader('Age', flex: 1),
          _buildColumnHeader('Tournaments', flex: 1),
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
                      child: Image.network(
                        'https://via.placeholder.com/40',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.person, size: 30),
                      ),
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
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: player.countryCode != null
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 24,
                          height: 16,
                          color: player.countryCode == 'USA'
                              ? Colors.blue
                              : (player.countryCode == 'POL'
                                  ? Colors.red
                                  : Colors.grey),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            player.countryCode ?? '',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    )
                  : const Text(''),
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
                player.tournamentsPlayed.toString(),
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

  void _showRegionPicker() {
    final regions = [
      'All Regions',
      'Europe',
      'North America',
      'South America',
      'Asia',
      'Africa',
      'Oceania',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Region'),
        content: SizedBox(
          width: 300,
          height: 300,
          child: ListView.builder(
            itemCount: regions.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(regions[index]),
                onTap: () {
                  setState(() {
                    currentRegion = regions[index];
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class Player {
  final int id;
  final String firstName;
  final String lastName;
  final int rank;
  final int previousRank;
  final int age;
  final String? country;
  final String? countryCode;
  final int points;
  final int tournamentsPlayed;
  final String profileImage;

  Player({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.rank,
    required this.previousRank,
    required this.age,
    required this.country,
    required this.countryCode,
    required this.points,
    required this.tournamentsPlayed,
    required this.profileImage,
  });
}