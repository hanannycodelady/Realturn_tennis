import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

class ScoreScreen extends StatefulWidget {
  const ScoreScreen({Key? key}) : super(key: key);

  @override
  State<ScoreScreen> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  String selectedFilter = 'All';
  List<String> filters = ['All', 'Ongoing', 'Completed', 'Interrupted'];
  List<Tournament> tournaments = [];
  bool isLoading = true;
  String? errorMessage;
  StreamSubscription<DatabaseEvent>? _scoresSubscription;
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _listenToScores();
  }

  @override
  void dispose() {
    _scoresSubscription?.cancel();
    super.dispose();
  }

  void _listenToScores() {
    _scoresSubscription = _databaseRef.onValue.listen(
      (DatabaseEvent event) {
        if (event.snapshot.exists) {
          _processFirebaseData(event.snapshot.value as Map<dynamic, dynamic>);
        } else {
          setState(() {
            tournaments = [];
            isLoading = false;
          });
        }
      },
      onError: (error) {
        setState(() {
          errorMessage = 'Error fetching data: $error';
          isLoading = false;
        });
      },
    );
  }

  void _processFirebaseData(Map<dynamic, dynamic> data) {
    try {
      List<Match> matches = [];
      
      data.forEach((key, value) {
        final matchData = value as Map<dynamic, dynamic>;
        matches.add(Match.fromFirebase(key, matchData));
      });

      // Group matches into tournaments (you can modify this logic based on your needs)
      Tournament tournament = Tournament(
        name: "Tennis Tournament",
        location: "Local Court",
        type: "Mixed Singles",
        badgeColor: const Color(0xFFE29000),
        cardColor: const Color(0xFF222222),
        startDate: "2025-05-28",
        endDate: "2025-05-30",
        courtType: "Hard Court",
        matches: matches,
      );

      setState(() {
        tournaments = [tournament];
        isLoading = false;
        errorMessage = null;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error processing data: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Tennis scores',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 28, 122, 245),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(errorMessage!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                            errorMessage = null;
                          });
                          _listenToScores();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    _buildFilterChips(),
                    Expanded(
                      child: tournaments.isEmpty
                          ? const Center(child: Text('No matches found'))
                          : ListView.builder(
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
                selectedColor: const Color.fromARGB(255, 22, 116, 240).withOpacity(0.3),
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
    final filteredMatches = selectedFilter == 'All'
        ? tournament.matches
        : tournament.matches.where((match) => match.status == selectedFilter).toList();

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
                  color: const Color.fromARGB(255, 14, 107, 245),
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
            color: const Color.fromARGB(255, 9, 107, 253),
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
          color: const Color.fromARGB(255, 14, 114, 245),
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
                  if (match.status == 'Interrupted' && match.reason != null)
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
              _buildFlag(player.country ?? 'Unknown'),
              const SizedBox(width: 10.0),
              Text(
                player.name ?? 'TBD',
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
            color: activePoint != null ? const Color.fromARGB(255, 15, 69, 248).withOpacity(0.1) : null,
            child: Text(
              activePoint ?? '-',
              style: TextStyle(
                color: activePoint != null ? const Color.fromARGB(255, 15, 69, 248) : Colors.black,
              ),
            ),
          ),
        ),
        TableCell(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(15.0),
            child: Text(
              score.sets.isNotEmpty ? score.sets[0][playerIndex].toString() : '-',
            ),
          ),
        ),
        TableCell(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(15.0),
            child: Text(
              score.sets.length > 1 ? score.sets[1][playerIndex].toString() : '-',
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
  final String id;
  final Player player1;
  final Player player2;
  final Score score;
  final String status;
  final String duration;
  final String round;
  final int? activePlayer;
  final String? activeScoringPoint;
  final String? reason;
  final String description;
  final DateTime matchTime;
  final String umpire;
  final String tieBreak;

  Match({
    required this.id,
    required this.player1,
    required this.player2,
    required this.score,
    required this.status,
    required this.duration,
    required this.round,
    this.activePlayer,
    this.activeScoringPoint,
    this.reason,
    required this.description,
    required this.matchTime,
    required this.umpire,
    required this.tieBreak,
  });

  factory Match.fromFirebase(String id, Map<dynamic, dynamic> data) {
    // Parse set scores from "7-5" format
    List<List<int>> parsedSets = [];
    String setScores = data['set_scores']?.toString() ?? '0-0';
    
    // Handle single set score like "7-5"
    if (setScores.contains('-')) {
      List<String> scores = setScores.split('-');
      if (scores.length == 2) {
        parsedSets.add([
          int.tryParse(scores[0].trim()) ?? 0,
          int.tryParse(scores[1].trim()) ?? 0,
        ]);
      }
    }
    
    // If no sets parsed, use individual player scores
    if (parsedSets.isEmpty) {
      parsedSets.add([
        int.tryParse(data['player1_score']?.toString() ?? '0') ?? 0,
        int.tryParse(data['player2_score']?.toString() ?? '0') ?? 0,
      ]);
    }

    // Determine match status based on winner
    String status = 'Ongoing';
    if (data['winner_id'] != null && data['winner_id'].toString().isNotEmpty) {
      status = 'Completed';
    }

    // Calculate duration from created_at to updated_at
    DateTime createdAt = DateTime.tryParse(data['created_at']?.toString() ?? '') ?? DateTime.now();
    DateTime updatedAt = DateTime.tryParse(data['updated_at']?.toString() ?? '') ?? DateTime.now();
    Duration diff = updatedAt.difference(createdAt);
    String duration = '${diff.inHours}:${(diff.inMinutes % 60).toString().padLeft(2, '0')}:${(diff.inSeconds % 60).toString().padLeft(2, '0')}';

    // Determine active player and scoring point for ongoing matches
    int? activePlayer;
    String? activeScoringPoint;
    if (status == 'Ongoing') {
      // For ongoing matches, show current scores
      int player1Score = int.tryParse(data['player1_score']?.toString() ?? '0') ?? 0;
      int player2Score = int.tryParse(data['player2_score']?.toString() ?? '0') ?? 0;
      
      if (player1Score >= player2Score) {
        activePlayer = 1;
        activeScoringPoint = data['player1_score']?.toString() ?? '0';
      } else {
        activePlayer = 2;
        activeScoringPoint = data['player2_score']?.toString() ?? '0';
      }
    }

    return Match(
      id: id,
      player1: Player(
        id: data['player1_id']?.toString() ?? '',
        name: 'Player 1', // You'll need to fetch player names from another Firebase node
        country: 'Unknown',
        seed: null,
      ),
      player2: Player(
        id: data['player2_id']?.toString() ?? '',
        name: 'Player 2', // You'll need to fetch player names from another Firebase node
        country: 'Unknown', 
        seed: null,
      ),
      score: Score(sets: parsedSets),
      status: status,
      duration: duration,
      round: data['round']?.toString() ?? 'Unknown',
      description: data['description']?.toString() ?? '',
      matchTime: DateTime.tryParse(data['match_time']?.toString() ?? '') ?? DateTime.now(),
      umpire: data['umpire']?.toString() ?? 'Unknown',
      tieBreak: data['tie_break']?.toString() ?? 'No',
      activePlayer: activePlayer,
      activeScoringPoint: activeScoringPoint,
    );
  }
}

class Player {
  final String id;
  final String name;
  final String? country;
  final int? seed;

  Player({
    required this.id,
    required this.name,
    this.country,
    this.seed,
  });
}

class Score {
  final List<List<int>> sets;

  Score({
    required this.sets,
  });
}