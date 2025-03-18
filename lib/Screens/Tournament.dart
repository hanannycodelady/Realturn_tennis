import 'package:flutter/material.dart';

class TournamentPage extends StatefulWidget {
  @override
  _TournamentPageState createState() => _TournamentPageState();
}

class Tournament {
  final String name;
  final String location;
  final String dateRange;
  final String surface;
  final String surfaceImagePath; // Added field for surface image
  final String category;
  final String month;
  final bool isHard;

  Tournament({
    required this.name,
    required this.location,
    required this.dateRange,
    required this.surface,
    required this.surfaceImagePath,
    required this.category,
    required this.month,
    required this.isHard,
  });
}

class _TournamentPageState extends State<TournamentPage> {
  String selectedMonth = 'March';
  final months = ['Jan', 'Feb', 'March', 'April', 'May', 'June', 'July', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec'];
  
  final List<Tournament> allTournaments = [
    Tournament(
      name: 'MIAMI OPEN PRESENTED BY ITAÚ',
      location: 'MIAMI, FL, UNITED STATES',
      dateRange: 'Mar 18 - Mar 30, 2025',
      surface: 'HARD',
      surfaceImagePath: 'assets/images/hard_court.jpg',
      category: 'WTA 1000',
      month: 'March',
      isHard: true,
    ),
    Tournament(
      name: 'INDIAN WELLS MASTERS',
      location: 'INDIAN WELLS, CA, UNITED STATES',
      dateRange: 'Mar 6 - Mar 17, 2025',
      surface: 'HARD',
      surfaceImagePath: 'assets/images/hard_court.jpg',
      category: 'WTA 1000',
      month: 'March',
      isHard: true,
    ),
    Tournament(
      name: 'AUSTRALIAN OPEN',
      location: 'MELBOURNE, AUSTRALIA',
      dateRange: 'Jan 13 - Jan 26, 2025',
      surface: 'HARD',
      surfaceImagePath: 'assets/images/hard_court.jpg',
      category: 'Grand Slam',
      month: 'Jan',
      isHard: true,
    ),
    Tournament(
      name: 'QATAR TOTAL OPEN',
      location: 'DOHA, QATAR',
      dateRange: 'Feb 10 - Feb 15, 2025',
      surface: 'HARD',
      surfaceImagePath: 'assets/images/hard_court.jpg',
      category: 'WTA 500',
      month: 'Feb',
      isHard: true,
    ),
    Tournament(
      name: 'ROLAND GARROS',
      location: 'PARIS, FRANCE',
      dateRange: 'May 26 - June 9, 2025',
      surface: 'CLAY',
      surfaceImagePath: 'assets/images/clay_court.jpg',
      category: 'Grand Slam',
      month: 'May',
      isHard: false,
    ),
    Tournament(
      name: 'MADRID OPEN',
      location: 'MADRID, SPAIN',
      dateRange: 'April 26 - May 9, 2025',
      surface: 'CLAY',
      surfaceImagePath: 'assets/images/clay_court.jpg',
      category: 'WTA 1000',
      month: 'April',
      isHard: false,
    ),
  ];

  List<Tournament> get filteredTournaments {
    return allTournaments.where((tournament) => tournament.month == selectedMonth).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tennis Tournaments'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Month filter
          Container(
            color: Colors.grey[200],
            padding: EdgeInsets.symmetric(vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: months.map((month) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedMonth = month;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        border: selectedMonth == month
                            ? Border.all(color: const Color.fromARGB(255, 27, 115, 247), width: 2)
                            : null,
                      ),
                      child: Text(
                        month,
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          
          // Tournament list
          Expanded(
            child: filteredTournaments.isEmpty
                ? Center(
                    child: Text(
                      'No tournaments in ${selectedMonth}',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredTournaments.length,
                    itemBuilder: (context, index) {
                      final tournament = filteredTournaments[index];
                      return Column(
                        children: [
                          // Court image with date
                          Container(
                            height: 150,
                            child: Stack(
                              children: [
                                // Court image as background
                                Positioned.fill(
                                  child: Image.asset(
                                    tournament.surfaceImagePath,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                // Semi-transparent overlay for better text visibility
                                Positioned.fill(
                                  child: Container(
                                    color: Colors.black.withOpacity(0.2),
                                  ),
                                ),
                                // Tournament date
                                Positioned(
                                  bottom: 30,
                                  left: 20,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                    color: Colors.black,
                                    child: Row(
                                      children: [
                                        Icon(Icons.calendar_today, color: Colors.white, size: 16),
                                        SizedBox(width: 8),
                                        Text(
                                          tournament.dateRange,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Court type
                                Positioned(
                                  bottom: 30,
                                  right: 20,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: tournament.isHard 
                                          ? Colors.blueAccent.withOpacity(0.8) 
                                          : Colors.orange.withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      tournament.surface,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Tournament details
                          Container(
                            color: Colors.grey[200],
                            padding: EdgeInsets.all(20),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Category badge
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: tournament.category == 'WTA 1000' 
                                        ? Color(0xFFB87D0D)
                                        : tournament.category == 'WTA 500'
                                            ? Color(0xFF5F8787)
                                            : Colors.purple[800],
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    tournament.category,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15),
                                // Tournament name
                                Text(
                                  tournament.name,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 10),
                                // Tournament location
                                Text(
                                  tournament.location,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}