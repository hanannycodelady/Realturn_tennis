import 'package:flutter/material.dart';
import 'package:realturn_app/Screens/About_us.dart';
import 'package:realturn_app/Screens/Community.dart';
import 'package:realturn_app/Screens/Donating.dart';
import 'package:realturn_app/Screens/Female_mixed_doubles%20.dart';
import 'package:realturn_app/Screens/Female_player.dart';
import 'package:realturn_app/Screens/Gallery.dart';
import 'package:realturn_app/Screens/Male_doubles.dart';
import 'package:realturn_app/Screens/Male_mixed_doubles.dart';
import 'package:realturn_app/Screens/Male_players.dart';
import 'package:realturn_app/Screens/Ranking.dart';
import 'package:realturn_app/Screens/School.dart';
import 'package:realturn_app/Screens/Scores.dart';
import 'package:realturn_app/Screens/Tournament.dart';
import 'package:realturn_app/Screens/Women_doubles.dart';
import 'package:realturn_app/Screens/notification.dart';
import 'package:realturn_app/pages/Profile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Search-related variables
  final TextEditingController _searchController = TextEditingController();
  late List<SearchItem> allSearchItems; // Changed to late initialization
  List<SearchItem> filteredSearchItems = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // Initialize allSearchItems here where 'this' is accessible
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
      // Drawer items
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
      SearchItem(title: "Contact", action: (context) => {}),
      SearchItem(
          title: "Female Players",
          action: (context) => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const FemalePlayer()))),
      SearchItem(title: "Coaches", action: (context) => {}),
      SearchItem(title: "Schools", action: (context) => {}),
      SearchItem(title: "Communities", action: (context) => {}),
      SearchItem(title: "Calendar", action: (context) => {}),
      SearchItem(title: "Scores", action: (context) => {}),
      // Bottom navigation items
      SearchItem(title: "Home Bottom", action: (context) => _onItemTapped(0)),
      SearchItem(title: "Rankings", action: (context) => _onItemTapped(1)),
      SearchItem(title: "Players", action: (context) => _onItemTapped(2)),
      SearchItem(
          title: "Calendar Bottom", action: (context) => _onItemTapped(3)),
    ];
    filteredSearchItems = [];
    _searchController.addListener(_filterSearchItems);
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

  // Function to launch WhatsApp (unchanged)
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 27, 120, 243),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: SizedBox(
          height: 45,
          child: TextField(
            controller: _searchController, // Add controller
            decoration: InputDecoration(
              hintText: 'Search...',
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Image.asset(
              'assets/image/logo.JPG',
              height: 40,
            ),
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
              padding:
                  const EdgeInsets.only(top: 50, bottom: 20, left: 20, right: 20),
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
                    onTap: () {},
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
                                      builder: (context) => const FemalePlayer()),
                                );
                              }),
                          ListTile(
                              title: const Text('Doubles'),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DoublesWomenScreen()));
                              }),
                          ListTile(
                              title: const Text('Mixed Doubles'),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MixedWomenScreen()));
                              }),
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
                                      builder: (context) => const MalePlayer()),
                                );
                              }),
                          ListTile(
                              title: const Text('Doubles'),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DoublesMenScreen()));
                              }),
                          ListTile(
                              title: const Text('Mixed Doubles'),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MixedDoublesMenScreen()));
                              }),
                        ],
                      ),
                    ],
                  ),
                  ListTile(
                    title: const Text('Coaches',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    onTap: () {},
                  ),
                  ExpansionTile(
                    title: const Text('Centres',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    children: [
                      ListTile(title: const Text('Schools'), onTap: () {
                        Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SchoolScreen()));
                      }),
                      ListTile(title: const Text('Communities'), onTap: () {
                        Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CommunityScreen()));}),
                    ],
                  ),
                  ExpansionTile(
                    title: const Text('Events',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    children: [
                      ListTile(title: const Text('Videos'), onTap: () {
                        Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SchoolScreen()));
                      }),
                      ListTile(title: const Text('Gallery'), onTap: () {
                        Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => GalleryScreen()));}),
                    ],
                  ),
                  ListTile(
                    title: const Text('Calendar',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    onTap: () {},
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
                    title: const Text('Tournament ',
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
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/image/WhatsApp Image 2024-09-23 at 16.18.27_e00067ff.jpg',
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),
          Column(
            children: [
              // Replace Expanded with conditional search results
              if (_isSearching)
                Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: ListView.builder(
                    itemCount: filteredSearchItems.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(filteredSearchItems[index].title),
                        onTap: () {
                          filteredSearchItems[index].action(context);
                          _searchController.clear();
                        },
                      );
                    },
                  ),
                )
              else
                const Expanded(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'SUPPORT OUR EFFORTS TO BUILD THE TENNIS SPORT IN UGANDA',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              // Conditionally show the buttons
              if (!_isSearching)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AboutUsScreen(fromMenu: false)),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          side: const BorderSide(color: Colors.blue, width: 3),
                          shadowColor: Colors.blue,
                          elevation: 10,
                          backgroundColor: Colors.white,
                          minimumSize: const Size(100, 50),
                        ),
                        child: const Text('ABOUT US',
                            style: TextStyle(
                                color: Color.fromARGB(255, 10, 10, 10),
                                fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DonatingScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          side: const BorderSide(color: Colors.blue, width: 3),
                          shadowColor: Colors.blue,
                          elevation: 10,
                          backgroundColor: Colors.white,
                          minimumSize: const Size(100, 50),
                        ),
                        child: const Text('DONATE NOW',
                            style: TextStyle(
                                color: Color.fromARGB(255, 12, 12, 12),
                                fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: _launchWhatsApp,
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 239, 241, 241),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color.fromARGB(
                                              255, 253, 254, 255)
                                          .withOpacity(0.5),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'assets/image/loga_whatsapp-removebg-preview (1).png',
                                    height: 60,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        currentIndex: _selectedIndex,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
        selectedLabelStyle:
            const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        unselectedLabelStyle:
            const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard), label: 'Rankings'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Players'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Calendar'),
        ],
      ),
    );
  }
}

// Add this class for search items
class SearchItem {
  final String title;
  final void Function(BuildContext) action;

  SearchItem({required this.title, required this.action});
}
