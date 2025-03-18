import 'package:flutter/material.dart';
import 'package:realturn_app/Screens/home_screen.dart';


class AboutUsScreen extends StatelessWidget {
  final bool fromMenu;
  const AboutUsScreen({super.key, required this.fromMenu});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ABOUT US', style: TextStyle(color: Color.fromARGB(255, 10, 10, 10)),textAlign: TextAlign.center,),
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 12, 12, 12)),
          onPressed: () {
            if (fromMenu) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            }
          },
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Text(
                  'Welcome to the Real Turn Tennis Community Initiative Drive'
                  'We are dedicated to raising awareness, fostering inclusion, and enhancing the development of lawn tennis in underserved '
                  'communities across various districts in Uganda. Our initiative focuses on breaking barriers to entry for young and aspiring '
                  'athletes, particularly in rural areas where access to sports infrastructure and opportunities is limited. Through strategic partnerships, '
                  'advocacy, and outreach programs, we aim to inspire a love for the game, promote healthy lifestyles, and empower the next generation of '
                  'tennis players by providing access to training, facilities, and support.',
                  style: TextStyle(fontSize: 16,color: Color.fromARGB(221, 20, 20, 20)),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 20),
                Text(
                  'OUR MISSION:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'To promote and inspire the growth of lawn tennis, while creating career opportunities for the youth through training, '
                  'advocacy, sponsorship, and by establishing accessible tennis facilities at the community level in different districts in Uganda.',
                  style: TextStyle(fontSize: 16,color: Color.fromARGB(221, 20, 20, 20)),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 20),
                Text(
                  'Target:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'Our goal is to have a presence in 25 districts and 30 colleges by 2030, with operations officially starting in January 2025.',
                  style: TextStyle(fontSize: 16,color: Color.fromARGB(221, 20, 20, 20)),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 10),
                Text(
                  'OUR AIM:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'We strive to:',
                  style: TextStyle(fontSize: 16, color: Color.fromARGB(221, 20, 20, 20)),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 5),
                Text(
                  '• Provide free, accessible community tennis courts.\n'
                  '• Raise public awareness about the sport.\n'
                  '• Empower young girls to participate in tennis.\n'
                  '• Support college tennis programs.\n'
                  '• Lobby for sponsorship of local tournaments and events to expand the fan base.\n'
                  '• Offer free community training, demonstration clinics, collaborations, and competitions.\n'
                  '• Build sustainable infrastructure.\n',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 20),
                Text(
                  '"Nothing comes out of doing nothing"',
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
