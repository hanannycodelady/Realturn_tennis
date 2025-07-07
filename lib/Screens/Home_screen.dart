import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:realturn_app/Screens/About_us.dart';
import 'package:realturn_app/Screens/Coach.dart';
import 'package:realturn_app/Screens/Community.dart';
import 'package:realturn_app/Screens/Donating.dart';
import 'package:realturn_app/Screens/Female_player.dart';
import 'package:realturn_app/Screens/Gallery.dart';
import 'package:realturn_app/Screens/Male_doubles.dart';
import 'package:realturn_app/Screens/Male_mixed_doubles.dart';
import 'package:realturn_app/Screens/Male_players.dart';
import 'package:realturn_app/Screens/Ranking.dart';
import 'package:realturn_app/Screens/School_screen.dart';
import 'package:realturn_app/Screens/Scores.dart';
import 'package:realturn_app/Screens/Tournament.dart';
import 'package:realturn_app/Screens/Video.dart';
import 'package:realturn_app/Screens/contact.dart';
import 'package:realturn_app/Screens/notification.dart';
import 'package:realturn_app/pages/Profile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:ui';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class FeaturedPlayer {
  final String name;
  final int ranking;
  final String imageUrl;
  final int yearFeatured;
  final String countryFlagUrl;
  final String gender;

  FeaturedPlayer({
    required this.name,
    required this.ranking,
    required this.imageUrl,
    required this.yearFeatured,
    required this.countryFlagUrl,
    this.gender = 'unknown',
  });

  factory FeaturedPlayer.fromMap(Map<dynamic, dynamic> map) {
    return FeaturedPlayer(
      name: map['name']?.toString() ?? 'Unknown',
      ranking: (map['Rankings'] is int)
          ? map['Rankings']
          : int.tryParse(map['Rankings']?.toString() ?? '0') ?? 0,
      imageUrl: map['image']?.toString() ?? '',
      yearFeatured: (map['Year_featured'] is int)
          ? map['Year_featured']
          : int.tryParse(map['Year_featured']?.toString() ?? '0') ?? 0,
      countryFlagUrl: map['country_flag']?.toString() ?? '',
      gender: map['gender']?.toString() ?? 'unknown',
    );
  }
}

class TournamentEvent {
  final String title;
  final String date;
  final String location;
  final bool isPremium;
  final DateTime? eventDateTime;

  TournamentEvent({
    required this.title,
    required this.date,
    required this.location,
    this.isPremium = false,
    this.eventDateTime,
  });

  factory TournamentEvent.fromMap(Map<dynamic, dynamic> map) {
    String rawDate = map['date']?.toString() ?? 'TBD';
    DateTime? parsedDate;
    // Handle countdown timestamp for eventDateTime
    if (map['countdown'] != null) {
      try {
        parsedDate = DateTime.fromMillisecondsSinceEpoch(map['countdown'] as int);
      } catch (_) {
        parsedDate = null;
      }
    }
    // Fallback to parsing date field if countdown is unavailable
    if (parsedDate == null) {
      try {
        final now = DateTime.now();
        final parts = rawDate.split(' ');
        if (parts.length == 2) {
          final month = _monthToInt(parts[0]);
          final day = int.parse(parts[1]);
          parsedDate = DateTime(now.year, month, day);
          if (parsedDate.isBefore(now)) {
            parsedDate = DateTime(now.year + 1, month, day);
          }
        }
      } catch (_) {
        parsedDate = null;
      }
    }
    return TournamentEvent(
      title: map['title']?.toString() ?? 'Untitled Event',
      date: rawDate,
      location: map['location']?.toString() ?? 'Unknown Location',
      isPremium: (map['badge']?.toString() ?? '') == 'premium',
      eventDateTime: parsedDate,
    );
  }

  static int _monthToInt(String month) {
    const months = {
      'jan': 1, 'feb': 2, 'mar': 3, 'apr': 4, 'may': 5, 'jun': 6,
      'jul': 7, 'aug': 8, 'sep': 9, 'oct': 10, 'nov': 11, 'dec': 12,
    };
    return months[month.toLowerCase()] ?? 1;
  }
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  late List<SearchItem> allSearchItems;
  List<SearchItem> filteredSearchItems = [];
  bool _isSearching = false;
  List<FeaturedPlayer> featuredPlayers = [];
  List<TournamentEvent> tournamentEvents = [];
  bool isLoading = true;
  late AnimationController _animationController;

  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    allSearchItems = [];
    _fetchData();
    _searchController.addListener(_filterSearchItems);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    try {
      final playerSnapshot = await _database.child('featured_players').get();
      List<FeaturedPlayer> players = [];
      if (playerSnapshot.exists) {
        final playerData = playerSnapshot.value;
        if (playerData is Map<dynamic, dynamic>) {
          playerData.forEach((key, value) {
            if (value is Map<dynamic, dynamic>) {
              players.add(FeaturedPlayer.fromMap(value));
            }
          });
        } else if (playerData is List<dynamic>) {
          for (var value in playerData) {
            if (value is Map<dynamic, dynamic>) {
              players.add(FeaturedPlayer.fromMap(value));
            }
          }
        }
      }

      final eventSnapshot = await _database.child('events').get();
      List<TournamentEvent> events = [];
      if (eventSnapshot.exists) {
        final eventData = eventSnapshot.value;
        if (eventData is Map<dynamic, dynamic>) {
          eventData.forEach((key, value) {
            if (value is Map<dynamic, dynamic>) {
              events.add(TournamentEvent.fromMap(value));
            }
          });
        } else if (eventData is List<dynamic>) {
          for (var value in eventData) {
            if (value is Map<dynamic, dynamic>) {
              events.add(TournamentEvent.fromMap(value));
            }
          }
        }
      }

      setState(() {
        featuredPlayers = players;
        tournamentEvents = events;
        isLoading = false;
        _initializeSearchItems();
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        _initializeSearchItems();
      });
    }
  }

  void _initializeSearchItems() {
    allSearchItems = [
      SearchItem(title: "Support Our Efforts", action: (context) => {}),
      SearchItem(
          title: "About Us",
          action: (context) => Navigator.push(
              context, MaterialPageRoute(builder: (context) => AboutUsScreen(fromMenu: false)))),
      SearchItem(
          title: "Donate Now",
          action: (context) => Navigator.push(context, MaterialPageRoute(builder: (context) => DonatingScreen()))),
      SearchItem(title: "WhatsApp", action: (context) => _launchWhatsApp()),
      SearchItem(title: "Home", action: (context) => Navigator.pop(context)),
      SearchItem(
          title: "About Us Drawer",
          action: (context) => Navigator.push(
              context, MaterialPageRoute(builder: (context) => AboutUsScreen(fromMenu: true)))),
      SearchItem(
          title: "Donations",
          action: (context) => Navigator.push(context, MaterialPageRoute(builder: (context) => DonatingScreen()))),
      SearchItem(
          title: "Contact",
          action: (context) => Navigator.push(context, MaterialPageRoute(builder: (context) => ContactUsScreen()))),
      SearchItem(
          title: "Female Players",
          action: (context) => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const FemalePlayer(
                        name: '',
                        image1: '',
                        image2: '',
                        details: '',
                        playerName: null,
                      )))),
      SearchItem(
          title: "Male Players",
          action: (context) => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const MalePlayer(
                        name: '',
                        image1: '',
                        image2: '',
                        details: '',
                        playerName: null,
                      )))),
      SearchItem(
          title: "Men Doubles",
          action: (context) => Navigator.push(context, MaterialPageRoute(builder: (context) => DoublesMenScreen()))),
      SearchItem(
          title: "Mixed Doubles Men",
          action: (context) => Navigator.push(context, MaterialPageRoute(builder: (context) => MixedDoublesMenScreen()))),
      SearchItem(
          title: "Coaches",
          action: (context) => Navigator.push(context, MaterialPageRoute(builder: (context) => CoachBioScreen(coachName: '', coachId: '')))),
      SearchItem(
          title: "Schools",
          action: (context) => Navigator.push(context, MaterialPageRoute(builder: (context) => SchoolScreen()))),
      SearchItem(
          title: "Communities",
          action: (context) => Navigator.push(context, MaterialPageRoute(builder: (context) => CommunityScreen()))),
      SearchItem(
          title: "Scores",
          action: (context) => Navigator.push(context, MaterialPageRoute(builder: (context) => ScoreScreen()))),
      SearchItem(
          title: "Tournament",
          action: (context) => Navigator.push(context, MaterialPageRoute(builder: (context) => TournamentPage()))),
      SearchItem(
          title: "Gallery",
          action: (context) => Navigator.push(context, MaterialPageRoute(builder: (context) => GalleryScreen()))),
      SearchItem(
          title: "Rankings",
          action: (context) => Navigator.push(context, MaterialPageRoute(builder: (context) => RankingsScreen()))),
      ...featuredPlayers.map((player) => SearchItem(
          title: player.name,
          action: (context) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => player.gender.toLowerCase() == 'female'
                      ? FemalePlayer(
                          playerName: player.name,
                          name: player.name,
                          image1: player.imageUrl,
                          image2: player.countryFlagUrl,
                          details: 'Ranking: ${player.ranking}, Year Featured: ${player.yearFeatured}',
                        )
                      : MalePlayer(
                          playerName: player.name,
                          name: player.name,
                          image1: player.imageUrl,
                          image2: player.countryFlagUrl,
                          details: 'Ranking: ${player.ranking}, Year Featured: ${player.yearFeatured}',
                        )),
            );
          })),
      SearchItem(title: "Home Bottom", action: (context) => _onItemTapped(0)),
      SearchItem(title: "Rankings Bottom", action: (context) => _onItemTapped(1)),
      SearchItem(title: "Scores Bottom", action: (context) => _onItemTapped(2)),
      SearchItem(title: "Tournament Bottom", action: (context) => _onItemTapped(3)),
    ];
    _filterSearchItems();
  }

  void _filterSearchItems() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredSearchItems = [];
        _isSearching = false;
      } else {
        filteredSearchItems =
            allSearchItems.where((item) => item.title.toLowerCase().contains(query)).toList();
        _isSearching = true;
      }
    });
  }

  Future<void> _launchWhatsApp() async {
    const String phone = '+256740598271';
    const String message = 'Welcome to RealTurn Tennis Uganda';
    Uri url;

    if (kIsWeb) {
      url = Uri.parse('https://wa.me/$phone?text=${Uri.encodeComponent(message)}');
    } else {
      url = Uri.parse('whatsapp://send?phone=$phone&text=${Uri.encodeComponent(message)}');
    }

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch WhatsApp')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to open WhatsApp: $e')),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => RankingsScreen()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) => ScoreScreen()));
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (context) => TournamentPage()));
        break;
    }
  }

  String _formatCountdown(DateTime? eventDate) {
    if (eventDate == null) return '';
    final now = DateTime.now();
    final difference = eventDate.difference(now);
    if (difference.isNegative) return 'Event has passed';
    final days = difference.inDays;
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;
    final seconds = difference.inSeconds % 60;
    return '$days:${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search for players, events...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: Colors.white, size: 20),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 24),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white, size: 24),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white, size: 24),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile()));
            },
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white.withOpacity(0.05),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 40, bottom: 15, left: 15, right: 15),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'MENU',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 24),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ListTile(
                      title: const Text('Home', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                      onTap: () => Navigator.pop(context),
                    ),
                    ListTile(
                      title: const Text('About Us', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AboutUsScreen(fromMenu: true)));
                      },
                    ),
                    ListTile(
                      title: const Text('Donations', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => DonatingScreen()));
                      },
                    ),
                    ListTile(
                      title: const Text('Contact', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ContactUsScreen()));
                      },
                    ),
                    ExpansionTile(
                      title: const Text('Players', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                      iconColor: const Color.fromARGB(255, 236, 235, 235),
                      children: [
                        ExpansionTile(
                          title: const Text('Female', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                          iconColor: Colors.black,
                          children: [
                            ListTile(
                              title: const Text('Singles', style: TextStyle(color: Colors.white, fontSize: 14)),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const FemalePlayer(
                                              name: '',
                                              image1: '',
                                              image2: '',
                                              details: '',
                                              playerName: null,
                                            )));
                              },
                            ),
                          ],
                        ),
                        ExpansionTile(
                          title: const Text('Male', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                          iconColor: Colors.black,
                          children: [
                            ListTile(
                              title: const Text('Singles', style: TextStyle(color: Colors.white, fontSize: 14)),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const MalePlayer(
                                              name: '',
                                              image1: '',
                                              image2: '',
                                              details: '',
                                              playerName: null,
                                            )));
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: const Text('Centres', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                      iconColor: const Color.fromARGB(255, 252, 251, 251),
                      children: [
                        ListTile(
                          title: const Text('Schools', style: TextStyle(color: Colors.white, fontSize: 14)),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SchoolScreen()));
                          },
                        ),
                        ListTile(
                          title: const Text('Communities', style: TextStyle(color: Colors.white, fontSize: 14)),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CommunityScreen()));
                          },
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: const Text('Events', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                      iconColor: const Color.fromARGB(255, 250, 249, 249),
                      children: [
                        ListTile(
                          title: const Text('Videos', style: TextStyle(color: Colors.white, fontSize: 14)),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => VideoScreen()));
                          },
                        ),
                        ListTile(
                          title: const Text('Gallery', style: TextStyle(color: Colors.white, fontSize: 14)),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => GalleryScreen()));
                          },
                        ),
                      ],
                    ),
                    ListTile(
                      title: const Text('Scores', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ScoreScreen()));
                      },
                    ),
                    ListTile(
                      title: const Text('Tournament', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => TournamentPage()));
                      },
                    ),
                    ListTile(
                      title: const Text('Ranking', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => RankingsScreen()));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E40AF), Color(0xFF3B82F6), Color(0xFF60A5FA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: _isSearching
            ? ListView.builder(
                itemCount: filteredSearchItems.length,
                itemBuilder: (context, index) {
                  final item = filteredSearchItems[index];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: ListTile(
                        title: Text(item.title, style: const TextStyle(color: Colors.white, fontSize: 14)),
                        tileColor: Colors.white.withOpacity(0.1),
                        onTap: () => item.action(context),
                      ),
                    ),
                  );
                },
              )
            : isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Section
                        Container(
                          height: MediaQuery.of(context).size.height * 0.25,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF1E40AF), Color(0xFF3B82F6).withOpacity(0.8)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: AnimatedBuilder(
                                  animation: _animationController,
                                  builder: (context, child) {
                                    return Transform.translate(
                                      offset: Offset(
                                          -50 * _animationController.value, -50 * _animationController.value),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage('assets/image/tennis_pattern.png'),
                                            repeat: ImageRepeat.repeat,
                                            opacity: 0.1,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Welcome back!',
                                              style: TextStyle(
                                                  color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(height: 4),
                                          Center(
                                            child: Text(
                                              'SUPPORT OUR EFFORTS TO BUILD THE TENNIS SPORT IN UGANDA',
                                               style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                 ),
                                                 maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center, 
                                                    ),
                                                     ),
                                          ],
                                        ),
                                        Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: const LinearGradient(
                                              colors: [Colors.white, Color(0xFFF0F0F0)],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black.withOpacity(0.2),
                                                  blurRadius: 15,
                                                  offset: const Offset(0, 5)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Upcoming Events Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 24,
                                        height: 24,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                            colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
                                          ),
                                        ),
                                        child: const Icon(Icons.emoji_events, color: Colors.white, size: 12),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Upcoming Events',
                                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => TournamentPage()));
                                    },
                                    child: const Text(
                                      'View All',
                                      style: TextStyle(color: Color(0xFF667EEA), fontSize: 12, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              tournamentEvents.isEmpty
                                  ? const Text(
                                      'No upcoming events available.',
                                      style: TextStyle(color: Colors.white70, fontSize: 14),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: tournamentEvents.length,
                                      itemBuilder: (context, index) {
                                        final event = tournamentEvents[index];
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => TournamentPage()));
                                          },
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(15),
                                            child: BackdropFilter(
                                              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                                              child: Container(
                                                margin: const EdgeInsets.only(bottom: 10),
                                                padding: const EdgeInsets.all(15),
                                                decoration: BoxDecoration(
                                                  color: Colors.white.withOpacity(0.08),
                                                  border: Border.all(color: Colors.white.withOpacity(0.15)),
                                                  borderRadius: BorderRadius.circular(15),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                                          decoration: BoxDecoration(
                                                            gradient: const LinearGradient(
                                                              colors: [Color(0xFFF093FB), Color(0xFFF5576C)],
                                                            ),
                                                            borderRadius: BorderRadius.circular(10),
                                                          ),
                                                          child: Text(
                                                            event.date,
                                                            style: const TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w700,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      event.title,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Row(
                                                      children: [
                                                        const Icon(Icons.location_on, color: Colors.white70, size: 14),
                                                        const SizedBox(width: 4),
                                                        Text(
                                                          event.location,
                                                          style: TextStyle(
                                                            color: Colors.white.withOpacity(0.8),
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    if (event.eventDateTime != null && event.isPremium)
                                                      Padding(
                                                        padding: const EdgeInsets.only(top: 8),
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(8),
                                                          child: BackdropFilter(
                                                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                                            child: Container(
                                                              padding: const EdgeInsets.all(8),
                                                              decoration: BoxDecoration(
                                                                color: Colors.white.withOpacity(0.1),
                                                                borderRadius: BorderRadius.circular(8),
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  _buildCountdownItem(
                                                                    _formatCountdown(event.eventDateTime!).split(':')[0],
                                                                    'Days',
                                                                  ),
                                                                  _buildCountdownItem(
                                                                    _formatCountdown(event.eventDateTime!).split(':')[1],
                                                                    'Hours',
                                                                  ),
                                                                  _buildCountdownItem(
                                                                    _formatCountdown(event.eventDateTime!).split(':')[2],
                                                                    'Mins',
                                                                  ),
                                                                  _buildCountdownItem(
                                                                    _formatCountdown(event.eventDateTime!).split(':')[3],
                                                                    'Secs',
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            ],
                          ),
                        ),
                        // Featured Players
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
                                      ),
                                    ),
                                    child: const Icon(Icons.sports_tennis, color: Colors.white, size: 12),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Featured Players',
                                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                  childAspectRatio: 0.75,
                                ),
                                itemCount: featuredPlayers.length,
                                itemBuilder: (context, index) {
                                  final player = featuredPlayers[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => player.gender.toLowerCase() == 'female'
                                                ? FemalePlayer(
                                                    playerName: player.name,
                                                    name: player.name,
                                                    image1: player.imageUrl,
                                                    image2: player.countryFlagUrl,
                                                    details:
                                                        'Ranking: ${player.ranking}, Year Featured: ${player.yearFeatured}',
                                                  )
                                                : MalePlayer(
                                                    playerName: player.name,
                                                    name: player.name,
                                                    image1: player.imageUrl,
                                                    image2: player.countryFlagUrl,
                                                    details:
                                                        'Ranking: ${player.ranking}, Year Featured: ${player.yearFeatured}',
                                                  )),
                                      );
                                    },
                                    child: AnimatedBuilder(
                                      animation: _animationController,
                                      builder: (context, child) {
                                        return Transform.scale(
                                          scale: 1.0 + 0.03 * _animationController.value,
                                          child: child,
                                        );
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.1),
                                              border: Border.all(color: Colors.white.withOpacity(0.2)),
                                              borderRadius: BorderRadius.circular(15),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.2),
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 5),
                                                ),
                                              ],
                                            ),
                                            child: Stack(
                                              children: [
                                                Positioned.fill(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Colors.transparent,
                                                          Colors.white.withOpacity(0.05),
                                                          Colors.transparent
                                                        ],
                                                        begin: Alignment.topLeft,
                                                        end: Alignment.bottomRight,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                                                      child: Image.network(
                                                        player.imageUrl.isNotEmpty
                                                            ? player.imageUrl
                                                            : 'https://via.placeholder.com/150',
                                                        fit: BoxFit.cover,
                                                        width: double.infinity,
                                                        height: 80,
                                                        errorBuilder: (context, error, stackTrace) => Container(
                                                          height: 80,
                                                          color: Colors.grey,
                                                          child: const Icon(Icons.person, size: 40, color: Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8),
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            player.name,
                                                            style: const TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w600),
                                                            textAlign: TextAlign.center,
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                          const SizedBox(height: 3),
                                                          Text(
                                                            'Rank: ${player.ranking}',
                                                            style: TextStyle(
                                                                color: Colors.white.withOpacity(0.8), fontSize: 11),
                                                          ),
                                                          const SizedBox(height: 3),
                                                          Image.network(
                                                            player.countryFlagUrl.isNotEmpty
                                                                ? player.countryFlagUrl
                                                                : 'https://via.placeholder.com/20x15',
                                                            width: 20,
                                                            height: 15,
                                                            errorBuilder: (context, error, stackTrace) =>
                                                                const Icon(Icons.flag, size: 15, color: Colors.white),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        // Support Us Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
                                      ),
                                    ),
                                    child: const Icon(Icons.info, color: Colors.white, size: 12),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Support Us',
                                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) => AboutUsScreen(fromMenu: false)));
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                                          child: Container(
                                            padding: const EdgeInsets.all(15),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.1),
                                              border: Border.all(color: Colors.white.withOpacity(0.2)),
                                              borderRadius: BorderRadius.circular(15),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.2),
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 5),
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    gradient: LinearGradient(
                                                      colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
                                                    ),
                                                  ),
                                                  child: const Icon(Icons.info, color: Colors.white, size: 20),
                                                ),
                                                const SizedBox(height: 8),
                                                const Text(
                                                  'About Us',
                                                  style: TextStyle(
                                                      color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                                                  textAlign: TextAlign.center,
                                                ),
                                                const SizedBox(height: 3),
                                                Text(
                                                  'Learn about our mission',
                                                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context, MaterialPageRoute(builder: (context) => DonatingScreen()));
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                                          child: Container(
                                            padding: const EdgeInsets.all(15),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.1),
                                              border: Border.all(color: Colors.white.withOpacity(0.2)),
                                              borderRadius: BorderRadius.circular(15),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.2),
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 5),
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    gradient: LinearGradient(
                                                      colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
                                                    ),
                                                  ),
                                                  child: const Icon(Icons.favorite, color: Colors.white, size: 20),
                                                ),
                                                const SizedBox(height: 8),
                                                const Text(
                                                  'Donate Now',
                                                  style: TextStyle(
                                                      color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                                                  textAlign: TextAlign.center,
                                                ),
                                                const SizedBox(height: 3),
                                                Text(
                                                  'Support our efforts',
                                                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E).withOpacity(0.95),
              border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  index: 0,
                  icon: Icons.home,
                  label: 'Home',
                  hasNotification: false,
                ),
                _buildNavItem(
                  index: 1,
                  icon: Icons.leaderboard,
                  label: 'Rankings',
                  hasNotification: true,
                ),
                _buildNavItem(
                  index: 2,
                  icon: Icons.score,
                  label: 'Scores',
                  hasNotification: false,
                ),
                _buildNavItem(
                  index: 3,
                  icon: Icons.emoji_events,
                  label: 'Tournament',
                  hasNotification: false,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: _launchWhatsApp,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: 1.0 + 0.03 * _animationController.value,
              child: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/image/loga_whatsapp-removebg-preview (1).png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    required bool hasNotification,
  }) {
    bool isActive = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        transform: Matrix4.translationValues(0, isActive ? -5 : 0, 0)
          ..scale(isActive ? 1.1 : 1.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive ? const Color(0xFF3B82F6) : Colors.white.withOpacity(0.5),
                      ),
                      child: Icon(
                        icon,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                    if (hasNotification)
                      Positioned(
                        top: -5,
                        right: -5,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 2000),
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFFF4757),
                          ),
                          child: AnimatedScale(
                            scale: 1.0 + 0.3 * _animationController.value,
                            duration: const Duration(milliseconds: 2000),
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFFF4757),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isActive ? const Color(0xFF3B82F6) : Colors.white.withOpacity(0.5),
                  ),
                ),
              ],
            ),
            Positioned(
              top: -12,
              child: AnimatedOpacity(
                opacity: isActive ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  width: 40,
                  height: 3,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                    gradient: LinearGradient(
                      colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountdownItem(String number, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          number,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Color(0xFFFFD700),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 8,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}

class SearchItem {
  final String title;
  final void Function(BuildContext) action;

  SearchItem({required this.title, required this.action});
}