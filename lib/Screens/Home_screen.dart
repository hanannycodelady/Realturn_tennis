import 'package:flutter/material.dart';
import 'package:realturn_app/pages/Profile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // Add this import

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Function to launch WhatsApp
  Future<void> _launchWhatsApp() async {
    const String phone = '+256740598271';
    const String message = 'Welcome to RealTurn Tennis Uganda';
    Uri url;

    if (kIsWeb) {
      // Web uses wa.me URL
      url = Uri.parse('https://wa.me/$phone?text=${Uri.encodeComponent(message)}');
    } else {
      // Mobile uses whatsapp:// scheme
      url = Uri.parse('whatsapp://send?phone=$phone&text=${Uri.encodeComponent(message)}');
    }

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch WhatsApp')),
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
    // Your existing build method remains unchanged
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 27, 120, 243),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: SizedBox(
          height: 45,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: Icon(Icons.search, color: Colors.black),
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              print("Notification Icon Clicked");
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Image.asset(
              'assets/image/logo.JPG',
              height: 40,
            ),
          ),
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.black),
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
              padding: EdgeInsets.only(top: 50, bottom: 20, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "MENU",
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
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
                    title: Text('Home', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('About Us', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('Donations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('Contact', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    onTap: () {},
                  ),
                  ExpansionTile(
                    title: Text('Players', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    children: [
                      ExpansionTile(
                        title: Text('Female', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        children: [
                          ListTile(title: Text('Singles'), onTap: () {}),
                          ListTile(title: Text('Doubles'), onTap: () {}),
                          ListTile(title: Text('Mixed Doubles'), onTap: () {}),
                        ],
                      ),
                      ExpansionTile(
                        title: Text('Male', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        children: [
                          ListTile(title: Text('Singles'), onTap: () {}),
                          ListTile(title: Text('Doubles'), onTap: () {}),
                          ListTile(title: Text('Mixed Doubles'), onTap: () {}),
                        ],
                      ),
                    ],
                  ),
                  ListTile(
                    title: Text('Coaches', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    onTap: () {},
                  ),
                  ExpansionTile(
                    title: Text('Centres', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    children: [
                      ListTile(title: Text('Schools'), onTap: () {}),
                      ListTile(title: Text('Communities'), onTap: () {}),
                    ],
                  ),
                  ListTile(
                    title: Text('Calender', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('Scores', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    onTap: () {},
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
              Expanded(
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
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(color: Colors.blue, width: 3),
                        shadowColor: Colors.blue,
                        elevation: 10,
                        backgroundColor: Colors.white,
                        minimumSize: Size(100, 50),
                      ),
                      child: Text('ABOUT US', style: TextStyle(color: const Color.fromARGB(255, 10, 10, 10), fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(color: Colors.blue, width: 3),
                        shadowColor: Colors.blue,
                        elevation: 10,
                        backgroundColor: Colors.white,
                        minimumSize: Size(100, 50),
                      ),
                      child: Text('DONATE NOW', style: TextStyle(color: const Color.fromARGB(255, 12, 12, 12), fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: _launchWhatsApp,
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 239, 241, 241),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color.fromARGB(255, 253, 254, 255).withOpacity(0.5),
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
        selectedLabelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.leaderboard), label: 'Rankings'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Players'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendar'),
        ],
      ),
    );
  }
}
