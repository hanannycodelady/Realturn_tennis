import 'package:flutter/material.dart';
import 'package:realturn_app/Screens/Home_screen.dart';
import 'package:realturn_app/Screens/donate.dart';

class DonatingScreen extends StatelessWidget {
  const DonatingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("DONATING", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
          centerTitle: true,
          backgroundColor: Colors.blue,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreen()));
            },
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/image/images 1.jpg",
                      height: 250, fit: BoxFit.cover),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("MONETARY DONATIONS",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        const Text(
                          "Inspire a global impact by bringing joy to people's lives through the power of tennis!",
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "All contributions will be directed towards covering the costs of local shipping to ensure that donations reach real tennis communities",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.normal,
                              color: Colors.black87),
                        ),
                        const SizedBox(height: 12),

                        // Donate Button Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DonationScreen ()),
                      );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                              child: Text("Donate"),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),
                        Image.asset("assets/image/images 2.jpg", height: 30),
                        
                        const Text("TENNIS AID",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const Text(
  "Free land for community courts, time for volunteering,  sponsorship for international players",
  style: TextStyle(
    fontSize: 16,  
    color: Color.fromARGB(255, 10, 10, 10), 
  ),
  textAlign: TextAlign.center,  // Center-align the text
),
                        const Text("EQUIPMENT DONATIONS",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        const Text("Donate your gently used tennis equipment",
                            textAlign: TextAlign.center,
                             style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)
                            ),
                        const SizedBox(height: 8),
                        Column(
  children: [
    const Align(
      alignment: Alignment.centerLeft, 
      child: Text("• Athletic shoes", style: TextStyle(fontSize: 16,)),
    ),
    const SizedBox(height: 8),
    const Align(
      alignment: Alignment.centerLeft,
      child: Text("• Water", style: TextStyle(fontSize: 16,)),
    ),
    const SizedBox(height: 8),
    const Align(
      alignment: Alignment.centerLeft,
      child: Text("• Tennis rackets", style: TextStyle(fontSize: 16,)),
    ),
    const SizedBox(height: 8),
    const Align(
      alignment: Alignment.centerLeft,
      child: Text("• Tennis bags, balls", style: TextStyle(fontSize: 16,)),
    ),
    const SizedBox(height: 8),
    const Align(
      alignment: Alignment.centerLeft,
      child: Text("• Tennis clothes", style: TextStyle(fontSize: 16,)),
    ),
    const SizedBox(height: 8),
    
    // Row for displaying images horizontally
    Row(
      mainAxisAlignment: MainAxisAlignment.center, 
      children: [
        Image.asset("assets/image/shoe-removebg-preview_1-removebg-preview.png", height: 50, fit: BoxFit.contain),
        const SizedBox(width: 10), 
        Image.asset("assets/image/bottle-removebg-preview_1-removebg-preview.png", height: 50, fit: BoxFit.contain),
        const SizedBox(width: 10),
        Image.asset("assets/image/raquet-removebg-preview_1-removebg-preview.png", height: 50, fit: BoxFit.contain),
        const SizedBox(width: 10),
        Image.asset("assets/image/ball-removebg-preview 1 (1).jpg", height: 50, fit: BoxFit.contain),
        
      ],
    ),
  ],
),
                        const Text("To donate:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        const Text(
                            "Please visit our offices to physically drop off your donations",
                            textAlign: TextAlign.center),
                        const SizedBox(height: 8),
                        const Text(
                          "Uganda, Kampala\nNakawa division\nBukoto II, Mutoola Zone A",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        const Text("© 2025 Realturn tennis uganda",
                            style: TextStyle(
                                fontSize: 12, fontStyle: FontStyle.italic)),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget donationItem(String title, String imagePath, {bool isShoe = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: isShoe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start, 
        children: [
          Image.asset(imagePath, height: 40),
          const SizedBox(width: 10),
          Text(title, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
