import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:realturn_app/Screens/About_us.dart';
import 'package:realturn_app/Screens/Coach.dart';
//import 'package:realturn_app/Screens/Coach_list.dart';
import 'package:realturn_app/Screens/Community.dart';
import 'package:realturn_app/Screens/Donating.dart';
// import 'package:realturn_app/Screens/Female_mixed_doubles.dart';
import 'package:realturn_app/Screens/Female_player.dart';
import 'package:realturn_app/Screens/Gallery.dart';
import 'package:realturn_app/Screens/Male_doubles.dart';
import 'package:realturn_app/Screens/Male_mixed_doubles.dart';
import 'package:realturn_app/Screens/Male_players.dart';
import 'package:realturn_app/Screens/Ranking.dart';
import 'package:realturn_app/Screens/School.dart';
import 'package:realturn_app/Screens/Scores.dart';
import 'package:realturn_app/Screens/Tournament.dart';
import 'package:realturn_app/Screens/Video.dart';
import 'package:realturn_app/Screens/Women_doubles.dart';
import 'package:realturn_app/Screens/contact.dart';
import 'package:realturn_app/Screens/notification.dart';
import 'package:realturn_app/pages/Profile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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
    required this.gender,
  });

  factory FeaturedPlayer.fromMap(Map<dynamic, dynamic> map) {
    return FeaturedPlayer(
      name: map['name']?.toString() ?? 'Unknown',
      ranking: (map['ranking'] is int)
          ? map['ranking']
          : int.tryParse(map['ranking']?.toString() ?? '0') ?? 0,
      imageUrl: map['imageUrl']?.toString() ?? '',
      yearFeatured: (map['yearFeatured'] is int)
          ? map['yearFeatured']
          : int.tryParse(map['yearFeatured']?.toString() ?? '0') ?? 0,
      countryFlagUrl: map['countryFlagUrl']?.toString() ?? '',
      gender: map['gender']?.toString() ?? 'unknown',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ranking': ranking,
      'imageUrl': imageUrl,
      'yearFeatured': yearFeatured,
      'countryFlagUrl': countryFlagUrl,
      'gender': gender,
    };
  }
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  late List<SearchItem> allSearchItems;
  List<SearchItem> filteredSearchItems = [];
  bool _isSearching = false;
  List<FeaturedPlayer> featuredPlayers = [];
  bool isLoading = true;

  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    allSearchItems = []; // Initialize as empty; populate after fetching players
    _fetchFeaturedPlayers();
    _searchController.addListener(_filterSearchItems);
  }

  Future<void> _fetchFeaturedPlayers() async {
    try {
      final snapshot = await _database.child('featured_players').get();
      if (snapshot.exists) {
        final data = snapshot.value;
        List<FeaturedPlayer> players = [];
        if (data is Map<dynamic, dynamic>) {
          data.forEach((key, value) {
            if (value is Map) {
              try {
                players.add(FeaturedPlayer.fromMap(value));
              } catch (e) {
                print('Error parsing player data for key $key: $e');
              }
            }
          });
        }
        setState(() {
          featuredPlayers = players;
          isLoading = false;
          _initializeSearchItems(); // Update search items after fetching players
        });
      } else {
        setState(() {
          isLoading = false;
          _initializeSearchItems(); // Initialize search items even if no players
        });
      }
    } on FirebaseException catch (e) {
      print('Firebase error fetching featured players: ${e.code} - ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load players: ${e.message}')),
      );
      setState(() {
        isLoading = false;
        _initializeSearchItems(); // Initialize search items on error
      });
    } catch (e, stackTrace) {
      print('Unexpected error fetching featured players: $e');
      print('Stack trace: $stackTrace');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred')),
      );
      setState(() {
        isLoading = false;
        _initializeSearchItems(); // Initialize search items on error
      });
    }
  }

  void _initializeSearchItems() {
    allSearchItems = [
      SearchItem(title: "Support Our Efforts", action: (context) => {}),
      SearchItem(
          title: "About Us",
          action: (context) => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AboutUsScreen(fromMenu: false)))),
      SearchItem(
          title: "Donate Now",
          action: (context) => Navigator.push(context,
              MaterialPageRoute(builder: (context) => DonatingScreen()))),
      SearchItem(title: "WhatsApp", action: (context) => _launchWhatsApp()),
      SearchItem(title: "Home", action: (context) => Navigator.pop(context)),
      SearchItem(
          title: "About Us Drawer",
          action: (context) => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AboutUsScreen(fromMenu: true)))),
      SearchItem(
          title: "Donations",
          action: (context) => Navigator.push(context,
              MaterialPageRoute(builder: (context) => DonatingScreen()))),
      SearchItem(
          title: "Contact",
          action: (context) => Navigator.push(context,
              MaterialPageRoute(builder: (context) => ContactUsScreen()))),
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
          title: "Women Doubles",
          action: (context) => Navigator.push(context,
              MaterialPageRoute(builder: (context) => DoublesWomenScreen()))),
      SearchItem(
          title: "Men Doubles",
          action: (context) => Navigator.push(context,
              MaterialPageRoute(builder: (context) => DoublesMenScreen()))),
      // SearchItem(
      //     title: "Mixed Doubles Women",
      //     action: (context) => Navigator.push(context,
      //         MaterialPageRoute(builder: (context) => MixedWomenScreen()))),
      SearchItem(
          title: "Mixed Doubles Men",
          action: (context) => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MixedDoublesMenScreen()))),
      SearchItem(
          title: "Coaches",
          action: (context) => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CoachBioScreen(coachName: '', coachId: '',)))),
      SearchItem(
          title: "Schools",
          action: (context) => Navigator.push(context,
              MaterialPageRoute(builder: (context) => SchoolScreen()))),
      SearchItem(
          title: "Communities",
          action: (context) => Navigator.push(context,
              MaterialPageRoute(builder: (context) => CommunitiesPage()))),
      SearchItem(
          title: "Scores",
          action: (context) => Navigator.push(
              context, MaterialPageRoute(builder: (context) => ScoreScreen()))),
      SearchItem(
          title: "Tournament",
          action: (context) => Navigator.push(context,
              MaterialPageRoute(builder: (context) => TournamentPage()))),
      SearchItem(
          title: "Gallery",
          action: (context) => Navigator.push(context,
              MaterialPageRoute(builder: (context) => GalleryScreen()))),
      SearchItem(
          title: "Rankings",
          action: (context) => Navigator.push(context,
              MaterialPageRoute(builder: (context) => RankingsScreen()))),
      // Add featured players to search items
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
          })),
      SearchItem(title: "Home Bottom", action: (context) => _onItemTapped(0)),
      SearchItem(
          title: "Rankings Bottom", action: (context) => _onItemTapped(1)),
      SearchItem(title: "Scores Bottom", action: (context) => _onItemTapped(2)),
      SearchItem(
          title: "Tournament Bottom", action: (context) => _onItemTapped(3)),
    ];
    // Update filtered search items if search is active
    _filterSearchItems();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterSearchItems() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredSearchItems = [];
        _isSearching = false;
      } else {
        filteredSearchItems = allSearchItems
            .where((item) => item.title.toLowerCase().contains(query))
            .toList();
        _isSearching = true;
      }
    });
  }

  Future<void> _launchWhatsApp() async {
    const String phone = '+256740598271';
    const String message = 'Welcome to RealTurn Tennis Uganda';
    Uri url;

    if (kIsWeb) {
      url = Uri.parse(
          'https://wa.me/$phone?text=${Uri.encodeComponent(message)}');
    } else {
      url = Uri.parse(
          'whatsapp://send?phone=$phone&text=${Uri.encodeComponent(message)}');
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
      print("Error launching WhatsApp: $e");
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
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RankingsScreen()));
        break;
      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ScoreScreen()));
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => TournamentPage()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: SizedBox(
          height: 45,
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search for more ...',
              prefixIcon: const Icon(Icons.search, color: Colors.black),
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfile()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              color: Colors.blue,
              padding: const EdgeInsets.only(
                  top: 50, bottom: 20, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "MENU",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    title: const Text('Home',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('About Us',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AboutUsScreen(fromMenu: true)),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Donations',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DonatingScreen()),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Contact',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ContactUsScreen()),
                      );
                    },
                  ),
                  ExpansionTile(
                    title: const Text('Players',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    children: [
                      ExpansionTile(
                        title: const Text('Female',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                        children: [
                          ListTile(
                              title: const Text('Singles'),
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
                                          )),
                                );
                              }),
                          // ListTile(
                          //     title: const Text('Doubles'),
                          //     onTap: () {
                          //       Navigator.pop(context);
                          //       Navigator.push(
                          //           context,
                          //           MaterialPageRoute(
                          //               builder: (context) =>
                          //                   DoublesWomenScreen()));
                          //     }),
                          // ListTile(
                          //     title: const Text('Mixed Doubles'),
                          //     onTap: () {
                          //       Navigator.pop(context);
                          //       Navigator.push(
                          //           context,
                          //           MaterialPageRoute(
                          //               builder: (context) =>
                          //                   MixedWomenScreen()));
                          //     }),
                        ],
                      ),
                      ExpansionTile(
                        title: const Text('Male',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                        children: [
                          ListTile(
                              title: const Text('Singles'),
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
                                          )),
                                );
                              }),
                          // ListTile(
                          //     title: const Text('Doubles'),
                          //     onTap: () {
                          //       Navigator.pop(context);
                          //       Navigator.push(
                          //           context,
                          //           MaterialPageRoute(
                          //               builder: (context) =>
                          //                   DoublesMenScreen()));
                          //     }),
                          // ListTile(
                          //     title: const Text('Mixed Doubles'),
                          //     onTap: () {
                          //       Navigator.pop(context);
                          //       Navigator.push(
                          //           context,
                          //           MaterialPageRoute(
                          //               builder: (context) =>
                          //                   MixedDoublesMenScreen()));
                          //     }),
                        ],
                      ),
                    ],
                  ),
                  // ListTile(
                  //   title: const Text('Coach',
                  //       style: TextStyle(
                  //           fontSize: 18, fontWeight: FontWeight.bold)),
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => CoachListScreen()));
                  //   },
                  // ),
                  ExpansionTile(
                    title: const Text('Centres',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    children: [
                      ListTile(
                          title: const Text('Schools'),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SchoolScreen()));
                          }),
                      ListTile(
                          title: const Text('Communities'),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CommunitiesPage()));
                          }),
                    ],
                  ),
                  ExpansionTile(
                    title: const Text('Events',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    children: [
                      ListTile(
                          title: const Text('Videos'),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VideoScreen()));
                          }),
                      ListTile(
                          title: const Text('Gallery'),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GalleryScreen()));
                          }),
                    ],
                  ),
                  ListTile(
                    title: const Text('Scores',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ScoreScreen()));
                    },
                  ),
                  ListTile(
                    title: const Text('Tournament',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TournamentPage()));
                    },
                  ),
                  ListTile(
                    title: const Text('Ranking',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RankingsScreen()));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: _isSearching
          ? ListView.builder(
              itemCount: filteredSearchItems.length,
              itemBuilder: (context, index) {
                final item = filteredSearchItems[index];
                return ListTile(
                  title: Text(item.title),
                  onTap: () => item.action(context),
                );
              },
            )
          : isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      // Background Image with Text
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image:
                                  AssetImage('assets/image/home tennis ball.jpeg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Container(
                                color: Colors.black.withOpacity(0.3),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(right: 20, left: 40),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.5,
                                    child: const Text(
                                      'SUPPORT OUR EFFORTS TO BUILD THE TENNIS SPORT IN UGANDA',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Cards for Donations, Players, About Us
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              // Donation Card
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DonatingScreen()),
                                  );
                                },
                                child: Container(
                                  width: 150,
                                  margin: const EdgeInsets.only(right: 20),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF1E40AF),
                                        Color(0xFF3B82F6)
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF3B82F6)
                                            .withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DonatingScreen()),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.favorite,
                                                color: Colors.white, size: 30),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Donate Now',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    Colors.white.withOpacity(0.9),
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Players Card
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const MalePlayer(
                                              name: '',
                                              image1: '',
                                              image2: '',
                                              details: '',
                                              playerName: null,
                                            )),
                                  );
                                },
                                child: Container(
                                  width: 150,
                                  margin: const EdgeInsets.only(right: 20),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF1E40AF),
                                        Color(0xFF3B82F6)
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF3B82F6)
                                            .withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const MalePlayer(
                                                    name: '',
                                                    image1: '',
                                                    image2: '',
                                                    details: '',
                                                    playerName: null,
                                                  )),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.sports_tennis,
                                                color: Colors.white, size: 30),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Players',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    Colors.white.withOpacity(0.9),
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // About Us Card
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AboutUsScreen(fromMenu: false)),
                                  );
                                },
                                child: Container(
                                  width: 150,
                                  margin: const EdgeInsets.only(right: 20),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF1E40AF),
                                        Color(0xFF3B82F6)
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF3B82F6)
                                            .withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AboutUsScreen(fromMenu: false)),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.info,
                                                color: Colors.white, size: 30),
                                            const SizedBox(height: 8),
                                            Text(
                                              'About Us',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    Colors.white.withOpacity(0.9),
                                              ),
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
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Featured Players Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF3B82F6),
                                        Color(0xFF1D4ED8)
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: const Icon(Icons.sports_tennis,
                                      color: Colors.white, size: 24),
                                ),
                                const SizedBox(width: 15),
                                const Text(
                                  'Featured Players',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 13, 13, 14),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            featuredPlayers.isEmpty
                                ? const Center(
                                    child: Text(
                                      'No featured players available.',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    ),
                                  )
                                : GridView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: MediaQuery.of(context)
                                                  .size
                                                  .width >
                                              1200
                                          ? 4
                                          : MediaQuery.of(context).size.width > 800
                                              ? 3
                                              : MediaQuery.of(context).size.width >
                                                      600
                                                  ? 2
                                                  : 1,
                                      mainAxisSpacing: 20,
                                      crossAxisSpacing: 20,
                                      childAspectRatio: 0.7,
                                    ),
                                    itemCount: featuredPlayers.length,
                                    itemBuilder: (context, index) {
                                      final player = featuredPlayers[index];
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => player
                                                            .gender
                                                            .toLowerCase() ==
                                                        'female'
                                                    ? FemalePlayer(
                                                        playerName: player.name,
                                                        name: player.name,
                                                        image1: player.imageUrl,
                                                        image2:
                                                            player.countryFlagUrl,
                                                        details:
                                                            'Ranking: ${player.ranking}, Year Featured: ${player.yearFeatured}',
                                                      )
                                                    : MalePlayer(
                                                        playerName: player.name,
                                                        name: player.name,
                                                        image1: player.imageUrl,
                                                        image2:
                                                            player.countryFlagUrl,
                                                        details:
                                                            'Ranking: ${player.ranking}, Year Featured: ${player.yearFeatured}',
                                                      )),
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: const Color(0xFFE5E7EB),
                                                width: 2),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.05),
                                                spreadRadius: 1,
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => player
                                                                  .gender
                                                                  .toLowerCase() ==
                                                              'female'
                                                          ? FemalePlayer(
                                                              playerName:
                                                                  player.name,
                                                              name: player.name,
                                                              image1:
                                                                  player.imageUrl,
                                                              image2: player
                                                                  .countryFlagUrl,
                                                              details:
                                                                  'Ranking: ${player.ranking}, Year Featured: ${player.yearFeatured}',
                                                            )
                                                          : MalePlayer(
                                                              playerName:
                                                                  player.name,
                                                              name: player.name,
                                                              image1:
                                                                  player.imageUrl,
                                                              image2: player
                                                                  .countryFlagUrl,
                                                              details:
                                                                  'Ranking: ${player.ranking}, Year Featured: ${player.yearFeatured}',
                                                            )),
                                                );
                                              },
                                              child: Stack(
                                                children: [
                                                  // Top gradient border
                                                  Positioned(
                                                    top: 0,
                                                    left: 0,
                                                    right: 0,
                                                    child: Container(
                                                      height: 4,
                                                      decoration:
                                                          const BoxDecoration(
                                                        gradient: LinearGradient(
                                                          colors: [
                                                            Color(0xFF3B82F6),
                                                            Color(0xFF1D4ED8)
                                                          ],
                                                          begin:
                                                              Alignment.centerLeft,
                                                          end:
                                                              Alignment.centerRight,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .vertical(
                                                                top: Radius
                                                                    .circular(15)),
                                                        child: Image.network(
                                                          player.imageUrl
                                                                  .isNotEmpty
                                                              ? player.imageUrl
                                                              : 'https://via.placeholder.com/150',
                                                          fit: BoxFit.cover,
                                                          width: double.infinity,
                                                          height: 150,
                                                          errorBuilder: (context,
                                                              error, stackTrace) {
                                                            print(
                                                                'Error loading player image: ${player.imageUrl} - $error');
                                                            return Container(
                                                              height: 150,
                                                              color: Colors.grey,
                                                              child: const Icon(
                                                                  Icons.person,
                                                                  size: 50,
                                                                  color: Colors
                                                                      .white),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                                15.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              player.name,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Color(
                                                                    0xFF1E40AF),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 5),
                                                            Text(
                                                              'Ranking: ${player.ranking}',
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 12,
                                                                color: Color(
                                                                    0xFF6B7280),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 5),
                                                            Text(
                                                              'Year Featured: ${player.yearFeatured}',
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 12,
                                                                color: Color(
                                                                    0xFF6B7280),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 5),
                                                            Image.network(
                                                              player.countryFlagUrl
                                                                      .isNotEmpty
                                                                  ? player
                                                                      .countryFlagUrl
                                                                  : 'https://via.placeholder.com/30x20',
                                                              width: 24,
                                                              height: 16,
                                                              errorBuilder:
                                                                  (context, error,
                                                                      stackTrace) {
                                                                print(
                                                                    'Error loading flag: ${player.countryFlagUrl} - $error');
                                                                return const Icon(
                                                                    Icons.flag,
                                                                    size: 16,
                                                                    color: Colors
                                                                        .black);
                                                              },
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
                                      );
                                    },
                                  ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // WhatsApp Floating Button
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20, right: 20),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: GestureDetector(
                            onTap: _launchWhatsApp,
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                image: const DecorationImage(
                                  image: AssetImage(
                                      'assets/image/loga_whatsapp-removebg-preview (1).png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        currentIndex: _selectedIndex,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
        selectedLabelStyle:
            const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        unselectedLabelStyle:
            const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard), label: 'Rankings'),
          BottomNavigationBarItem(icon: Icon(Icons.score), label: 'Scores'),
          BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events), label: 'Tournament'),
        ],
      ),
    );
  }
}

class SearchItem {
  final String title;
  final void Function(BuildContext) action;

  SearchItem({required this.title, required this.action});
}