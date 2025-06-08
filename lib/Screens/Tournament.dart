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

class _TournamentPageState extends State<TournamentPage> {
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

  // Firebase Realtime Database reference
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _fetchTournaments();
    _startPeriodicRefresh();
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
            
            // Ensure value is a Map
            if (value is Map) {
              tournaments.add(Tournament.fromMap(value));
            } else {
              print('Skipping invalid data format for key: $key');
            }
          } catch (e) {
            print('Error parsing tournament $key: $e');
          }
        });
        
        // Sort tournaments by start date
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tennis Tournaments'),
        backgroundColor: const Color.fromARGB(255, 38, 101, 236),
        foregroundColor: const Color.fromARGB(255, 248, 247, 247),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchTournaments,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchTournaments,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                color: Colors.grey[200],
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: months.map((month) {
                      return GestureDetector(
                        onTap: () {
                          if (mounted) {
                            setState(() {
                              selectedMonth = month;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 8),
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            border: selectedMonth == month
                                ? Border.all(
                                    color: const Color.fromARGB(255, 27, 115, 247),
                                    width: 2)
                                : null,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            month,
                            style: TextStyle(
                              color: selectedMonth == month 
                                  ? const Color.fromARGB(255, 27, 115, 247)
                                  : Colors.black54,
                              fontWeight: selectedMonth == month 
                                  ? FontWeight.bold 
                                  : FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 200,
                ),
                child: isLoading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(50.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : errorMessage != null
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.error_outline,
                                    size: 64,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    errorMessage!,
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.red),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: _fetchTournaments,
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : filteredTournaments.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.event_busy,
                                        size: 64,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'No tournaments in $selectedMonth',
                                        style: const TextStyle(
                                            fontSize: 18, color: Colors.grey),
                                      ),
                                      if (allTournaments.isNotEmpty) ...[
                                        const SizedBox(height: 8),
                                        Text(
                                          'Total tournaments: ${allTournaments.length}',
                                          style: const TextStyle(
                                              fontSize: 14, color: Colors.grey),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: filteredTournaments.length,
                                itemBuilder: (context, index) {
                                  final tournament = filteredTournaments[index];
                                  return TournamentCard(tournament: tournament);
                                },
                              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TournamentCard extends StatelessWidget {
  final Tournament tournament;

  const TournamentCard({Key? key, required this.tournament}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 150,
            width: double.infinity,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: tournament.surfaceImagePath,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.sports_tennis, size: 40, color: Colors.grey),
                              SizedBox(height: 8),
                              Text('Tournament Image', style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      color: Colors.black.withOpacity(0.2),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            color: Colors.white, size: 14),
                        const SizedBox(width: 5),
                        Text(
                          tournament.dateRange,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: tournament.isHard
                          ? Colors.blueAccent.withOpacity(0.8)
                          : tournament.surface.toLowerCase() == 'clay'
                              ? Colors.orange.withOpacity(0.8)
                              : Colors.green.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      tournament.surface,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: tournament.status.toLowerCase() == 'upcoming'
                          ? Colors.blue.withOpacity(0.8)
                          : tournament.status.toLowerCase() == 'ongoing'
                              ? Colors.green.withOpacity(0.8)
                              : Colors.grey.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      tournament.status,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: tournament.category == 'Open'
                              ? Colors.blue
                              : tournament.category == 'WTA 1000'
                                  ? const Color(0xFFB87D0D)
                                  : tournament.category == 'WTA 500'
                                      ? const Color(0xFF5F8787)
                                      : Colors.purple[800]!,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          tournament.category,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    if (tournament.prizeMoney.isNotEmpty && tournament.prizeMoney != '0')
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green[600],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${tournament.prizeMoneyCurrency} ${tournament.prizeMoney}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  tournament.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${tournament.location}, ${tournament.venue}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                if (tournament.sponsorName.isNotEmpty) ...[
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.business, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Sponsored by ${tournament.sponsorName}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}