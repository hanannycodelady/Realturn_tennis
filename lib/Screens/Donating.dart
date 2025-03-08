import 'package:flutter/material.dart';
import 'package:realturn_app/Screens/Home_screen.dart';
import 'package:realturn_app/Screens/donate.dart';

void main() {
  runApp(DonatingScreen());
}

class DonatingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("DONATING", style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Colors.blue,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
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
                      height: 200, fit: BoxFit.cover),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("MONETARY DONATIONS",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text(
                          "Inspire a global impact by bringing joy to people's lives through the power of tennis!",
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "All contributions will be directed towards covering the costs of local shipping to ensure that donations reach real tennis communities",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.normal,
                              color: Colors.black87),
                        ),
                        SizedBox(height: 12),

                        // Donate Button Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DonationScreen ()),
                      );
                              },
                              child: Text("Donate"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 12),
                        Image.asset("assets/image/images 2.jpg", height: 30),
                        
                        Text("TENNIS AID",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(
  "Free land for community courts, time for volunteering,  sponsorship for international players",
  style: TextStyle(
    fontSize: 16,  
    color: const Color.fromARGB(255, 10, 10, 10), 
  ),
  textAlign: TextAlign.center,  // Center-align the text
),
                        Text("EQUIPMENT DONATIONS",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text("Donate your gently used tennis equipment",
                            textAlign: TextAlign.center,
                             style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)
                            ),
                        SizedBox(height: 8),
                        Column(
  children: [
    Align(
      alignment: Alignment.centerLeft, 
      child: Text("• Athletic shoes", style: TextStyle(fontSize: 16,)),
    ),
    SizedBox(height: 8),
    Align(
      alignment: Alignment.centerLeft,
      child: Text("• Water", style: TextStyle(fontSize: 16,)),
    ),
    SizedBox(height: 8),
    Align(
      alignment: Alignment.centerLeft,
      child: Text("• Tennis rackets", style: TextStyle(fontSize: 16,)),
    ),
    SizedBox(height: 8),
    Align(
      alignment: Alignment.centerLeft,
      child: Text("• Tennis bags, balls", style: TextStyle(fontSize: 16,)),
    ),
    SizedBox(height: 8),
    Align(
      alignment: Alignment.centerLeft,
      child: Text("• Tennis clothes", style: TextStyle(fontSize: 16,)),
    ),
    SizedBox(height: 8),
    
    // Row for displaying images horizontally
    Row(
      mainAxisAlignment: MainAxisAlignment.center, 
      children: [
        Image.asset("assets/image/shoe-removebg-preview_1-removebg-preview.png", height: 50, fit: BoxFit.contain),
        SizedBox(width: 10), 
        Image.asset("assets/image/bottle-removebg-preview_1-removebg-preview.png", height: 50, fit: BoxFit.contain),
        SizedBox(width: 10),
        Image.asset("assets/image/raquet-removebg-preview_1-removebg-preview.png", height: 50, fit: BoxFit.contain),
        SizedBox(width: 10),
        Image.asset("assets/image/ball-removebg-preview 1 (1).jpg", height: 50, fit: BoxFit.contain),
        
      ],
    ),
  ],
),
                        Text("To donate:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text(
                            "Please visit our offices to physically drop off your donations",
                            textAlign: TextAlign.center),
                        SizedBox(height: 8),
                        Text(
                          "Uganda, Kampala\nNakawa division\nBukoto II, Mutoola Zone A",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                        Text("© 2024 real tennis projects",
                            style: TextStyle(
                                fontSize: 12, fontStyle: FontStyle.italic)),
                        SizedBox(height: 16),
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
          SizedBox(width: 10),
          Text(title, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// void main() {
//   runApp(DonatingScreen());
// }

// class DonatingScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text("DONATING", style: TextStyle(fontWeight: FontWeight.bold)),
//           centerTitle: true,
//           backgroundColor: Colors.blue,
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back, color: Colors.white),
//             onPressed: () {},
//           ),
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Image.asset("assets/image/images 1.jpg", height: 200, fit: BoxFit.cover),
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Text("MONETARY DONATIONS", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                     SizedBox(height: 8),
//                     Text(
//                       "Inspire a global impact by bringing joy to people's lives through the power of tennis!", 
//                       textAlign: TextAlign.center,
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       "*All contributions will be directed towards covering the costs of local shipping to ensure that donations reach real tennis communities",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
//                     ),
//                     SizedBox(height: 12),
//                     ElevatedButton(
//                       onPressed: () {},
//                       child: Text("Donate"),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         foregroundColor: Colors.white,
//                       ),
//                     ),
//                     SizedBox(height: 12),
//                     Image.asset("assets/image/images 2.jpg", height: 30),
//                     Divider(),
//                     Text("EQUIPMENT DONATIONS", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                     SizedBox(height: 8),
//                     Text("Donate your gently used tennis equipment", textAlign: TextAlign.center),
//                     SizedBox(height: 8),
//                     Column(
//                       children: [
//                         donationItem("Athletic shoes", "assets/image/shoe-removebg-preview_1-removebg-preview.png"),
//                         donationItem("Water", "assets/image/bottle-removebg-preview_1-removebg-preview.png"),
//                         donationItem("Tennis rackets", "assets/image/raquet-removebg-preview_1-removebg-preview.png"),
//                         donationItem("Tennis bags, balls", "assets/image/ball-removebg-preview 1 (1).jpg"),
//                         donationItem("Tennis clothes", ""),
//                       ],
//                     ),
//                     Divider(),
//                     Text("To donate :", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                     SizedBox(height: 8),
//                     Text("Please visit our offices to physically drop off your donations", textAlign: TextAlign.center),
//                     SizedBox(height: 8),
//                     Text(
//                       "Uganda, Kampala\nNakawa division\nBukoto II, Mutoola Zone A",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 16),
//                     Text("© 2024 real tennis projects", style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
//                     SizedBox(height: 16),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget donationItem(String title, String imagePath) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         children: [
//           Image.asset(imagePath, height: 40),
//           SizedBox(width: 10),
//           Text(title, style: TextStyle(fontSize: 16)),
//         ],
//       ),
//     );
//   }
// }
