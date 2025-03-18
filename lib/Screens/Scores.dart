import 'package:flutter/material.dart';

class ScoreScreen extends StatefulWidget {
  const ScoreScreen({Key? key}) : super(key: key);

  @override
  State<ScoreScreen> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  String selectedFilter = 'All';
  List<String> filters = ['All', 'Ongoing', 'Completed', 'Interrupted'];

  final List<Tournament> tournaments = [
    Tournament(
      name: 'MIAMI OPEN PRESENTE...',
      location: 'MIAMI, FL, UNITED STATES',
      type: 'WTA1000',
      badgeColor: const Color(0xFFE29000),
      cardColor: const Color(0xFF222222),
      startDate: 'Mar 18, 2025',
      endDate: 'Mar 23, 2025',
      courtType: 'HARD',
      matches: [
        Match(
          player1: Player(name: 'J. PAOLINI', country: 'Italy', seed: 4),
          player2: Player(name: 'M. KEYS', country: 'USA', seed: null),
          score: Score(sets: [
            [6, 3],
            [6, 4],
            [0, 0]
          ]),
          status: 'Completed',
          duration: '1:45',
          round: 'ROUND OF 16',
        ),
        Match(
          player1: Player(name: 'C. GAUFF', country: 'USA', seed: 1),
          player2: Player(name: 'E. RYBAKINA', country: 'Kazakhstan', seed: 3),
          score: Score(sets: [
            [4, 6],
            [3, 1],
            [0, 0]
          ]),
          status: 'Ongoing',
          duration: '1:32',
          round: 'QUARTER FINALS',
          activePlayer: 2,
          activeScoringPoint: '30',
        ),
      ],
    ),
    Tournament(
      name: 'MEGASARAY HOTELS OPEN',
      location: 'ANTALYA, TURKEY',
      type: 'WTA125',
      badgeColor: const Color(0xFF5B2C91),
      cardColor: const Color(0xFF00C07F),
      startDate: 'Mar 18, 2025',
      endDate: 'Mar 23, 2025',
      courtType: 'CLAY',
      matches: [
        Match(
          player1: Player(name: 'P. UDVARDY', country: 'Hungary', seed: null),
          player2: Player(name: 'A. TODONI', country: 'Romania', seed: 6),
          score: Score(sets: [
            [6, 4],
            [3, 4],
            [0, 0]
          ]),
          status: 'Ongoing',
          duration: '1:25',
          round: 'ROUND OF 32',
          activePlayer: 1,
          activeScoringPoint: '15',
        ),
        Match(
          player1: Player(name: 'A. RUS', country: 'Netherlands', seed: 3),
          player2: Player(name: 'A. AKSU', country: 'Turkey', seed: null),
          score: Score(sets: [
            [4, 6],
            [6, 0],
            [0, 0]
          ]),
          status: 'Ongoing',
          duration: '1:26',
          round: 'ROUND OF 32',
          activePlayer: 1,
          activeScoringPoint: '0',
        ),
        Match(
          player1: Player(name: 'A. BONDAR', country: 'Hungary', seed: 1),
          player2: Player(name: 'S. ERRANI', country: 'Italy', seed: 5),
          score: Score(sets: [
            [4, 6],
            [6, 7],
            [0, 0]
          ]),
          status: 'Completed',
          duration: '1:58',
          round: 'ROUND OF 32',
        ),
        Match(
          player1: Player(name: 'E. ANDREEVA', country: 'Russia', seed: 2),
          player2: Player(name: 'D. SNIGUR', country: 'Ukraine', seed: null),
          score: Score(sets: [
            [3, 1],
            [0, 0],
            [0, 0]
          ]),
          status: 'Interrupted',
          duration: '0:42',
          round: 'ROUND OF 32',
          reason: 'Rain Delay',
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tennis Tournaments'),
        backgroundColor: const Color(0xFF00C07F),
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: ListView.builder(
              itemCount: tournaments.length,
              itemBuilder: (context, index) {
                final tournament = tournaments[index];
                return _buildTournamentCard(tournament);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      color: Colors.grey[100],
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((filter) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: FilterChip(
                selected: selectedFilter == filter,
                label: Text(filter),
                backgroundColor: Colors.white,
                selectedColor: const Color(0xFF00C07F).withOpacity(0.3),
                onSelected: (bool selected) {
                  setState(() {
                    selectedFilter = filter;
                  });
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTournamentCard(Tournament tournament) {
    // Filter matches based on selected filter
    final filteredMatches = selectedFilter == 'All'
        ? tournament.matches
        : tournament.matches
            .where((match) => match.status == selectedFilter)
            .toList();

    if (filteredMatches.isEmpty && selectedFilter != 'All') {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  color: tournament.cardColor,
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 2.0,
                        ),
                        decoration: BoxDecoration(
                          color: tournament.badgeColor,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          tournament.type,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        tournament.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      Text(
                        tournament.location,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Stack(
          children: [
            Container(
              height: 200.0,
              color: tournament.type == 'WTA1000'
                  ? const Color(0xFF2980B9)
                  : const Color(0xFFD35400),
              child: Center(
                child: Text(
                  tournament.courtType,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 15.0,
              left: 15.0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 5.0,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF00C07F),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 10.0,
                      height: 10.0,
                      decoration: const BoxDecoration(
                        color: Color(0xFF222222),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    const Text(
                      'STREAMING LIVE',
                      style: TextStyle(
                        color: Color(0xFF222222),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 15.0,
              left: 15.0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 5.0,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF222222),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                      size: 14.0,
                    ),
                    const SizedBox(width: 5.0),
                    Text(
                      '${tournament.startDate} - ${tournament.endDate}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        InkWell(
          onTap: () {},
          child: Container(
            color: const Color(0xFF00C07F),
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.play_arrow,
                  color: Color(0xFF222222),
                  size: 24.0,
                ),
                const SizedBox(width: 10.0),
                Text(
                  'Watch ${tournament.name}',
                  style: const TextStyle(
                    color: Color(0xFF222222),
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          ),
        ),
        ...filteredMatches.map((match) => _buildMatchContainer(match)).toList(),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildMatchContainer(Match match) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 1.0),
          color: const Color(0xFF00C07F),
          padding: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 10.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    match.status.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  const Icon(
                    Icons.timer,
                    color: Colors.white,
                    size: 14.0,
                  ),
                  const SizedBox(width: 5.0),
                  Text(
                    match.duration,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  if (match.status == 'Interrupted')
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        '(${match.reason})',
                        style: const TextStyle(
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
              Text(
                match.round,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Table(
          border: TableBorder.all(
            color: Colors.grey[300]!,
            width: 1.0,
          ),
          columnWidths: const {
            0: FlexColumnWidth(5),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
            4: FlexColumnWidth(1),
          },
          children: [
            _buildPlayerRow(match.player1, match.score, 0, match.activePlayer == 1 ? match.activeScoringPoint : null),
            _buildPlayerRow(match.player2, match.score, 1, match.activePlayer == 2 ? match.activeScoringPoint : null),
          ],
        ),
        Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 5.0,
          ),
          child: const Text(
            'MATCH STATS',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12.0,
            ),
          ),
        ),
      ],
    );
  }

  TableRow _buildPlayerRow(Player player, Score score, int playerIndex, String? activePoint) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              _buildFlag(player.country),
              const SizedBox(width: 10.0),
              Text(
                player.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (player.seed != null)
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    '(${player.seed})',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
            ],
          ),
        ),
        TableCell(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(15.0),
            color: activePoint != null ? const Color(0xFF00C07F).withOpacity(0.1) : null,
            child: Text(
              activePoint ?? '-',
              style: TextStyle(
                color: activePoint != null ? const Color(0xFF00C07F) : Colors.black,
              ),
            ),
          ),
        ),
        TableCell(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(15.0),
            child: Text(
              score.sets[0][playerIndex].toString(),
            ),
          ),
        ),
        TableCell(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(15.0),
            child: Text(
              score.sets[1][playerIndex].toString(),
            ),
          ),
        ),
        TableCell(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(15.0),
            child: Text(
              score.sets.length > 2 && score.sets[2][playerIndex] > 0
                  ? score.sets[2][playerIndex].toString()
                  : '-',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFlag(String country) {
    Map<String, Color> flagColors = {
      'Hungary': const Color(0xFFCE2939),
      'Romania': const Color(0xFF002B7F),
      'Netherlands': const Color(0xFFAE1C28),
      'Turkey': const Color(0xFFE30A17),
      'Italy': const Color(0xFF009246),
      'USA': const Color(0xFF0052B4),
      'Kazakhstan': const Color(0xFF00AFCA),
      'Russia': const Color(0xFFFF0000),
      'Ukraine': const Color(0xFF0057B7),
    };

    return Container(
      width: 20.0,
      height: 15.0,
      decoration: BoxDecoration(
        color: flagColors[country] ?? Colors.grey,
        border: Border.all(color: Colors.grey[300]!, width: 0.5),
      ),
    );
  }
}

class Tournament {
  final String name;
  final String location;
  final String type;
  final Color badgeColor;
  final Color cardColor;
  final String startDate;
  final String endDate;
  final String courtType;
  final List<Match> matches;

  Tournament({
    required this.name,
    required this.location,
    required this.type,
    required this.badgeColor,
    required this.cardColor,
    required this.startDate,
    required this.endDate,
    required this.courtType,
    required this.matches,
  });
}

class Match {
  final Player player1;
  final Player player2;
  final Score score;
  final String status;
  final String duration;
  final String round;
  final int? activePlayer;
  final String? activeScoringPoint;
  final String? reason;

  Match({
    required this.player1,
    required this.player2,
    required this.score,
    required this.status,
    required this.duration,
    required this.round,
    this.activePlayer,
    this.activeScoringPoint,
    this.reason,
  });
}

class Player {
  final String name;
  final String country;
  final int? seed;

  Player({
    required this.name,
    required this.country,
    this.seed,
  });
}

class Score {
  final List<List<int>> sets;

  Score({
    required this.sets,
  });
}