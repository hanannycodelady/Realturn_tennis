import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:realturn_app/models/Tournament.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TournamentPage extends StatefulWidget {
  const TournamentPage({super.key});

  @override
  _TournamentPageState createState() => _TournamentPageState();
}

class _TournamentPageState extends State<TournamentPage> 
    with TickerProviderStateMixin {
  Timer? _refreshTimer;
  String selectedMonth = 'May';
  final months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  final monthToInt = {
    'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4, 'May': 5, 'Jun': 6,
    'Jul': 7, 'Aug': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12
  };
  List<Tournament> allTournaments = [];
  bool isLoading = true;
  String? errorMessage;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Firebase Realtime Database reference
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _fetchTournaments();
    _startPeriodicRefresh();
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));
  }

  void _startPeriodicRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _fetchTournaments();
    });
  }

  Future<void> _fetchTournaments() async {
    if (mounted) {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
    }

    try {
      print('Fetching tournaments from Firebase...');
      final snapshot = await _database.child('tournaments').get();
      
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        List<Tournament> tournaments = [];
        
        print('Found ${data.length} tournament records');
        
        data.forEach((key, value) {
          try {
            print('Processing tournament with key: $key');
            print('Tournament data: $value');
            
            if (value is Map) {
              tournaments.add(Tournament.fromMap(value));
            } else {
              print('Skipping invalid data format for key: $key');
            }
          } catch (e) {
            print('Error parsing tournament $key: $e');
          }
        });
        
        tournaments.sort((a, b) {
          try {
            if (a.startDate.isEmpty || b.startDate.isEmpty) return 0;
            return DateTime.parse(a.startDate).compareTo(DateTime.parse(b.startDate));
          } catch (e) {
            return 0;
          }
        });
        
        if (mounted) {
          setState(() {
            allTournaments = tournaments;
            isLoading = false;
          });
          _fadeController.forward();
          _slideController.forward();
        }
        
        print('Successfully loaded ${tournaments.length} tournaments');
      } else {
        print('No tournaments found in database');
        if (mounted) {
          setState(() {
            allTournaments = [];
            isLoading = false;
            errorMessage = 'No tournaments found';
          });
        }
      }
    } catch (e) {
      print('Fetch error: $e');
      if (mounted) {
        setState(() {
          errorMessage = 'Failed to load tournaments: ${e.toString()}';
          isLoading = false;
        });
      }
    }
  }

  List<Tournament> get filteredTournaments {
    final monthInt = monthToInt[selectedMonth] ?? 0;
    final filtered = allTournaments.where((t) => t.month == monthInt).toList();
    print('Filtered tournaments for month $selectedMonth ($monthInt): ${filtered.length}');
    return filtered;
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E3A8A), // Deep blue
              Color(0xFF3B82F6), // Medium blue
              Color(0xFF60A5FA), // Light blue
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              backgroundColor: Colors.transparent,
              elevation: 10.0, // Added comma
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.blue.shade900.withOpacity(0.9),
                        Colors.blue.shade600.withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        Icon(
                          Icons.emoji_events,
                          color: Colors.white,
                          size: 32,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tennis Tournaments',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: () {
                      _fadeController.reset();
                      _slideController.reset();
                      _fetchTournaments();
                    },
                  ),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: months.asMap().entries.map((entry) {
                      String month = entry.value;
                      bool isSelected = selectedMonth == month;
                      
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        child: GestureDetector(
                          onTap: () {
                            if (mounted) {
                              setState(() {
                                selectedMonth = month;
                              });
                              _fadeController.reset();
                              _slideController.reset();
                              _fadeController.forward();
                              _slideController.forward();
                            }
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: Colors.white.withOpacity(0.3),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Text(
                              month,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.blue.shade700
                                    : Colors.white,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                fontSize: 16,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Container(
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height - 300,
                        ),
                        child: isLoading
                            ? const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(50),
                                  child: Column(
                                    children: [
                                      CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'Loading tournaments...',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : errorMessage != null
                                ? Center(
                                    child: Container(
                                      margin: const EdgeInsets.all(20),
                                      padding: const EdgeInsets.all(24),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.error_outline,
                                            size: 64,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            errorMessage!,
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 20),
                                          ElevatedButton(
                                            onPressed: _fetchTournaments,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              foregroundColor: Colors.blue.shade700,
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 32,
                                                vertical: 16,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: Text('Retry'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : filteredTournaments.isEmpty
                                    ? Center(
                                        child: Container(
                                          margin: EdgeInsets.all(20),
                                          padding: const EdgeInsets.all(24),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.15),
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(color: Colors.white.withOpacity(0.3)),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.event_busy,
                                                size: 64,
                                                color: Colors.white,
                                              ),
                                              SizedBox(height: 16),
                                              Text(
                                                'No tournaments in $selectedMonth',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              if (allTournaments.isNotEmpty) ...[
                                                SizedBox(height: 8),
                                                Text(
                                                  'Total tournaments: ${allTournaments.length}',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white.withOpacity(0.8),
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          children: filteredTournaments
                                              .asMap()
                                              .entries
                                              .map((entry) {
                                            int index = entry.key;
                                            Tournament tournament = entry.value;
                                            return AnimatedContainer(
                                              duration: Duration(
                                                milliseconds: 400 + (index * 100),
                                              ),
                                              curve: Curves.easeOutBack,
                                              child: TournamentCard(
                                                tournament: tournament,
                                                index: index,
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TournamentCard extends StatefulWidget {
  final Tournament tournament;
  final int index;

  const TournamentCard({
    Key? key,
    required this.tournament,
    required this.index,
  }) : super(key: key);

  @override
  State<TournamentCard> createState() => _TournamentCardState();
}

class _TournamentCardState extends State<TournamentCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));
    
    _elevationAnimation = Tween<double>(
      begin: 6.0,
      end: 12.0,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'upcoming':
        return const Color(0xFF3B82F6);
      case 'ongoing':
        return const Color(0xFF10B981);
      case 'completed':
        return const Color(0xFF6B7280);
      default:
        return const Color(0xFF8B5CF6);
    }
  }

  Color _getSurfaceColor(String surface) {
    switch (surface.toLowerCase()) {
      case 'hard':
        return const Color(0xFF1E40AF);
      case 'clay':
        return const Color(0xFFEA580C);
      case 'grass':
        return const Color(0xFF16A34A);
      case 'carpet':
        return const Color(0xFF7C3AED);
      default:
        return const Color(0xFF6B7280);
    }
  }

  List<Color> _getCategoryColors(String category) {
    switch (category.toLowerCase()) {
      case 'open':
        return [const Color(0xFF1E40AF), const Color(0xFF3B82F6)];
      case 'wta 1000':
        return [const Color(0xFFB45309), const Color(0xFFD97706)];
      case 'wta 500':
        return [const Color(0xFF0F766E), const Color(0xFF14B8A6)];
      case 'wta 250':
        return [const Color(0xFF7C2D12), const Color(0xFFEA580C)];
      default:
        return [const Color(0xFF7C3AED), const Color(0xFF8B5CF6)];
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) => _hoverController.forward(),
            onTapUp: (_) => _hoverController.reverse(),
            onTapCancel: () => _hoverController.reverse(),
            child: Container(
              margin: EdgeInsets.only(
                bottom: 12,
                top: widget.index == 0 ? 0 : 0,
              ),
              child: Card(
                elevation: _elevationAnimation.value,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white,
                        Colors.blue.shade50,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Section
                      SizedBox(
                        height: 140,
                        width: double.infinity,
                        child: Stack(
                          children: [
                            // Main Image
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: widget.tournament.surfaceImagePath,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.blue.shade200,
                                          Colors.blue.shade400,
                                        ],
                                      ),
                                    ),
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.blue.shade200,
                                          Colors.blue.shade400,
                                        ],
                                      ),
                                    ),
                                    child: const Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.sports_tennis,
                                            size: 32,
                                            color: Colors.white,
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            'Tournament Image',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Gradient Overlay
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.4),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Status Badge
                            Positioned(
                              top: 16,
                              right: 16,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(widget.tournament.status),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  widget.tournament.status.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                            // Date Info
                            Positioned(
                              bottom: 16,
                              left: 16,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      widget.tournament.dateRange,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Surface Badge
                            Positioned(
                              bottom: 16,
                              right: 16,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _getSurfaceColor(widget.tournament.surface),
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  widget.tournament.surface.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Content Section
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Category and Prize Money Row
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: _getCategoryColors(widget.tournament.category),
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: _getCategoryColors(widget.tournament.category)[0]
                                              .withOpacity(0.3),
                                          blurRadius: 6,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      widget.tournament.category,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                if (widget.tournament.prizeMoney.isNotEmpty && 
                                    widget.tournament.prizeMoney != '0') ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF10B981),
                                          Color(0xFF059669),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF10B981).withOpacity(0.3),
                                          blurRadius: 6,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      '${widget.tournament.prizeMoneyCurrency} ${widget.tournament.prizeMoney}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Tournament Name
                            Text(
                              widget.tournament.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Location
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.blue.shade200,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 16,
                                    color: Colors.blue.shade600,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      '${widget.tournament.location}, ${widget.tournament.venue}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.blue.shade700,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Sponsor Info
                            if (widget.tournament.sponsorName.isNotEmpty)
                              ...[
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.business,
                                        size: 16,
                                        color: Colors.grey.shade600,
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          'Sponsored by ${widget.tournament.sponsorName}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade700,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}