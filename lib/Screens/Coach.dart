// lib/coach_bio_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class CoachBioScreen extends StatefulWidget {
  final String coachId;
  
  const CoachBioScreen({super.key, required this.coachId, required String coachName});

  @override
  State<CoachBioScreen> createState() => _CoachBioScreenState();
}

class _CoachBioScreenState extends State<CoachBioScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  
  Map<String, dynamic>? coachData;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = 0;
    _loadCoachData();
  }

  Future<void> _loadCoachData() async {
    try {
      final snapshot = await _database.child('coaches').child(widget.coachId).get();
      if (snapshot.exists) {
        setState(() {
          coachData = Map<String, dynamic>.from(snapshot.value as Map);
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Coach not found';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error loading coach data: $e';
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: SafeArea(
          child: Container(
            color: const Color(0xFF0066CC),
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
        ),
      );
    }

    if (error != null) {
      return Scaffold(
        body: SafeArea(
          child: Container(
            color: const Color(0xFF0066CC),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.white, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    error!,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildStatusBar(),
                    _buildHeader(),
                    _buildProfilePicture(),
                    _buildCoachInfo(),
                    _buildTabBar(),
                  ],
                ),
              ),
            ];
          },
          body: Material(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildBioTab(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: 30,
      color: Colors.white,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(15),
      color: const Color(0xFF0066CC),
      width: double.infinity,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          const SizedBox(width: 10),
          const Text(
            'COACH PROFILE',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePicture() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      color: Colors.white,
      child: Center(
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.circular(60),
          ),
          child: coachData!['profilePicture'] != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Image.network(
                    coachData!['profilePicture'],
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: const Icon(Icons.person, size: 60, color: Colors.white),
                      );
                    },
                  ),
                )
              : const Icon(Icons.person, size: 60, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildCoachInfo() {
    final firstName = coachData!['firstName'] ?? '';
    final lastName = coachData!['lastName'] ?? '';
    final age = coachData!['age']?.toString() ?? '0';

    return Container(
      padding: const EdgeInsets.all(15),
      color: const Color(0xFF0066CC),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            firstName.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
            ),
          ),
          Text(
            lastName.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Age',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    age,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildTabBar() {
    return Container(
      color: Colors.black,
      child: TabBar(
        controller: _tabController,
        indicatorColor: const Color(0xFF0066CC),
        indicatorWeight: 3,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Bio'),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    final playersCoached = coachData!['playersCoached'] as Map<String, dynamic>? ?? {};
    final latestAims = coachData!['latestAims'] ?? 'No aims specified';

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Players Coached Section
            const Text(
              'Players Coached',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ...playersCoached.entries.map((entry) {
              final player = entry.value as Map<String, dynamic>;
              final firstName = player['first_name'] ?? '';
              final lastName = player['second_name'] ?? '';
              final fullName = '$firstName $lastName'.trim();
              
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                color: const Color(0xFF0066CC),
                width: double.infinity,
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      fullName.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            if (playersCoached.isEmpty)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                color: const Color(0xFF0066CC),
                width: double.infinity,
                child: const Text(
                  'No players coached yet',
                  style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            // Latest Coach Aims Section
            const Text(
              'Latest Coach Aims',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Center(
                child: Icon(
                  Icons.image,
                  size: 50,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              latestAims,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBioTab() {
    final firstName = coachData!['firstName'] ?? '';
    final lastName = coachData!['lastName'] ?? '';
    final fullName = '$firstName $lastName';
    final bio = coachData!['bio'] ?? 'No bio available';
    final coachingCareer = coachData!['coachingCareer'] ?? 'No coaching career information available';
    final coachingPhilosophy = coachData!['coachingPhilosophy'] ?? 'No coaching philosophy specified';

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About $fullName',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              bio,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 20),
            const Text(
              'Coaching Career',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              coachingCareer,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 20),
            const Text(
              'Coaching Philosophy',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              coachingPhilosophy,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}