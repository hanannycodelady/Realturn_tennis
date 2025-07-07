import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

class ScoreScreen extends StatefulWidget {
  const ScoreScreen({Key? key}) : super(key: key);

  @override
  State<ScoreScreen> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> with TickerProviderStateMixin {
  String selectedFilter = 'All';
  List<String> filters = ['All', 'Live', 'Completed', 'Upcoming'];
  List<Tournament> tournaments = [];
  bool isLoading = true;
  String? errorMessage;
  StreamSubscription<DatabaseEvent>? _scoresSubscription;
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _listenToScores();
  }

  @override
  void dispose() {
    _scoresSubscription?.cancel();
    _animationController.dispose();
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

      Tournament tournament = Tournament(
        name: "Wimbledon Championship",
        location: "All England Club",
        type: "Grand Slam",
        badgeColor: const Color(0xFF00A651),
        cardColor: const Color(0xFF1E1E1E),
        startDate: "2025-06-28",
        endDate: "2025-07-11",
        courtType: "Grass Court",
        matches: matches,
      );

      setState(() {
        tournaments = [tournament];
        isLoading = false;
        errorMessage = null;
      });
      _animationController.forward();
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
      backgroundColor: const Color(0xFF0A0A0A),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: isLoading
                ? _buildLoadingState()
                : errorMessage != null
                    ? _buildErrorState()
                    : _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: const Color(0xFF0A0A0A),
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Live Scores',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1A1A1A),
                Color(0xFF0A0A0A),
              ],
            ),
          ),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() {
                isLoading = true;
                errorMessage = null;
              });
              _listenToScores();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00A651)),
              strokeWidth: 3,
            ),
            SizedBox(height: 20),
            Text(
              'Loading matches...',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 48,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              errorMessage!,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildGlassButton(
              onPressed: () {
                setState(() {
                  isLoading = true;
                  errorMessage = null;
                });
                _listenToScores();
              },
              child: const Text(
                'Try Again',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          _buildFilterSection(),
          const SizedBox(height: 20),
          tournaments.isEmpty
              ? _buildEmptyState()
              : Column(
                  children: tournaments
                      .map((tournament) => _buildTournamentCard(tournament))
                      .toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter Matches',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: filters.map((filter) => _buildFilterChip(filter)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String filter) {
    final isSelected = selectedFilter == filter;
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedFilter = filter;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [Color(0xFF00A651), Color(0xFF00D865)],
                  )
                : null,
            color: isSelected ? null : Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : Colors.white.withOpacity(0.2),
            ),
          ),
          child: Text(
            filter,
            style: TextStyle(
              color: Colors.white,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.sports_tennis,
                color: Colors.white54,
                size: 48,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No matches found',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Check back later for live scores',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTournamentCard(Tournament tournament) {
    final filteredMatches = selectedFilter == 'All'
        ? tournament.matches
        : tournament.matches
            .where((match) => _mapStatus(match.status) == selectedFilter)
            .toList();

    if (filteredMatches.isEmpty && selectedFilter != 'All') {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          _buildTournamentHeader(tournament),
          ...filteredMatches.map((match) => _buildMatchCard(match)).toList(),
        ],
      ),
    );
  }

  Widget _buildTournamentHeader(Tournament tournament) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: tournament.badgeColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              tournament.type,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tournament.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${tournament.location} • ${tournament.courtType}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: Colors.white.withOpacity(0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchCard(Match match) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          _buildMatchHeader(match),
          const SizedBox(height: 16),
          _buildMatchScore(match),
          if (match.status == 'Ongoing') ...[
            const SizedBox(height: 12),
            _buildLiveIndicator(),
          ],
        ],
      ),
    );
  }

  Widget _buildMatchHeader(Match match) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: _getStatusColor(match.status).withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _getStatusColor(match.status).withOpacity(0.5)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _getStatusColor(match.status),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                _mapStatus(match.status),
                style: TextStyle(
                  color: _getStatusColor(match.status),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Text(
          match.round,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildMatchScore(Match match) {
    return Column(
      children: [
        _buildPlayerScore(match.player1, match.score, 0, match.activePlayer == 1),
        const SizedBox(height: 12),
        _buildPlayerScore(match.player2, match.score, 1, match.activePlayer == 2),
      ],
    );
  }

  Widget _buildPlayerScore(Player player, Score score, int playerIndex, bool isActive) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isActive 
            ? const Color(0xFF00A651).withOpacity(0.1)
            : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive 
              ? const Color(0xFF00A651).withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          _buildPlayerInfo(player),
          const Spacer(),
          _buildScoreSets(score, playerIndex),
        ],
      ),
    );
  }

  Widget _buildPlayerInfo(Player player) {
    return Row(
      children: [
        _buildModernFlag(player.country ?? 'Unknown'),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              player.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            if (player.seed != null)
              Text(
                'Seed ${player.seed}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildScoreSets(Score score, int playerIndex) {
    return Row(
      children: [
        for (int i = 0; i < 3; i++) ...[
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: i < score.sets.length && score.sets[i][playerIndex] > 0
                  ? Colors.white.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Center(
              child: Text(
                i < score.sets.length 
                    ? score.sets[i][playerIndex].toString()
                    : '-',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          if (i < 2) const SizedBox(width: 8),
        ],
      ],
    );
  }

  Widget _buildLiveIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF4444), Color(0xFFFF6666)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          const Text(
            'LIVE',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernFlag(String country) {
    Map<String, List<Color>> flagGradients = {
      'Hungary': [const Color(0xFFCE2939), const Color(0xFFFF4757)],
      'Romania': [const Color(0xFF002B7F), const Color(0xFF3742FA)],
      'Netherlands': [const Color(0xFFAE1C28), const Color(0xFFFF3838)],
      'Turkey': [const Color(0xFFE30A17), const Color(0xFFFF4757)],
      'Italy': [const Color(0xFF009246), const Color(0xFF00D2FF)],
      'USA': [const Color(0xFF0052B4), const Color(0xFF3742FA)],
      'Kazakhstan': [const Color(0xFF00AFCA), const Color(0xFF2ED573)],
      'Russia': [const Color(0xFFFF0000), const Color(0xFFFF4757)],
      'Ukraine': [const Color(0xFF0057B7), const Color(0xFF3742FA)],
    };

    return Container(
      width: 32,
      height: 24,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: flagGradients[country] ?? [Colors.grey, Colors.grey.shade600],
        ),
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassButton({required VoidCallback onPressed, required Widget child}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: child,
      ),
    );
  }

  String _mapStatus(String status) {
    switch (status.toLowerCase()) {
      case 'ongoing':
        return 'Live';
      case 'completed':
        return 'Completed';
      case 'interrupted':
        return 'Interrupted';
      default:
        return 'Upcoming';
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'ongoing':
        return const Color(0xFF00A651);
      case 'completed':
        return const Color(0xFF3742FA);
      case 'interrupted':
        return const Color(0xFFFFA502);
      default:
        return const Color(0xFF747D8C);
    }
  }
}

// Keep your existing classes unchanged
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
    List<List<int>> parsedSets = [];
    String setScores = data['set_scores']?.toString() ?? '0-0';
    
    if (setScores.contains('-')) {
      List<String> scores = setScores.split('-');
      if (scores.length == 2) {
        parsedSets.add([
          int.tryParse(scores[0].trim()) ?? 0,
          int.tryParse(scores[1].trim()) ?? 0,
        ]);
      }
    }
    
    if (parsedSets.isEmpty) {
      parsedSets.add([
        int.tryParse(data['player1_score']?.toString() ?? '0') ?? 0,
        int.tryParse(data['player2_score']?.toString() ?? '0') ?? 0,
      ]);
    }

    String status = 'Ongoing';
    if (data['winner_id'] != null && data['winner_id'].toString().isNotEmpty) {
      status = 'Completed';
    }

    DateTime createdAt = DateTime.tryParse(data['created_at']?.toString() ?? '') ?? DateTime.now();
    DateTime updatedAt = DateTime.tryParse(data['updated_at']?.toString() ?? '') ?? DateTime.now();
    Duration diff = updatedAt.difference(createdAt);
    String duration = '${diff.inHours}:${(diff.inMinutes % 60).toString().padLeft(2, '0')}:${(diff.inSeconds % 60).toString().padLeft(2, '0')}';

    int? activePlayer;
    String? activeScoringPoint;
    if (status == 'Ongoing') {
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
        name: 'Player 1',
        country: 'USA',
        seed: 1,
      ),
      player2: Player(
        id: data['player2_id']?.toString() ?? '',
        name: 'Player 2',
        country: 'Italy',
        seed: 3,
      ),
      score: Score(sets: parsedSets),
      status: status,
      duration: duration,
      round: data['round']?.toString() ?? 'Quarter Final',
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