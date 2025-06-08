import 'package:flutter/material.dart';
import 'package:realturn_app/Screens/home_screen.dart';

class AboutUsScreen extends StatefulWidget {
  final bool fromMenu;
  const AboutUsScreen({super.key, required this.fromMenu});

  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  Map<int, bool> _isHovered = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ABOUT US',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (widget.fromMenu) {
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildHoverCard(
                context,
                index: 0,
                title: 'Welcome to the Real Turn Tennis Community Initiative Drive',
                normalText:
                    'We are dedicated to raising awareness, fostering inclusion, and enhancing the development of lawn tennis in underserved communities across Uganda.',
                hoverText:
                    'Through strategic partnerships, outreach programs, and training, we empower young athletes in rural areas with opportunities in sports.',
              ),
              _buildHoverCard(
                context,
                index: 1,
                title: 'OUR MISSION:',
                normalText:
                    'To promote and inspire the growth of lawn tennis by creating career opportunities for the youth.',
                hoverText:
                    'We achieve this through training, advocacy, sponsorships, and establishing community tennis facilities.',
              ),
              _buildHoverCard(
                context,
                index: 2,
                title: 'Target:',
                normalText:
                    'Our goal is to have a presence in 25 districts and 30 colleges by 2030.',
                hoverText:
                    'Operations will officially start in January 2025 with structured tennis programs.',
              ),
              _buildHoverCard(
                context,
                index: 3,
                title: 'OUR AIM:',
                normalText:
                    'We strive to provide free community tennis courts, raise awareness, and empower young girls.',
                hoverText:
                    'Additionally, we support college tennis programs, lobby for sponsorships, and organize free training and competitions.',
              ),
              _buildHoverCard(
                context,
                index: 4,
                title: '"Nothing comes out of doing nothing"',
                normalText: 'A reminder that progress only comes with action.',
                hoverText: 'Join us in making a difference in young athletes’ lives!',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHoverCard(
    BuildContext context, {
    required int index,
    required String title,
    required String normalText,
    required String hoverText,
  }) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered[index] = true),
      onExit: (_) => setState(() => _isHovered[index] = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: _isHovered[index] == true ? Colors.blueAccent : Colors.grey.withOpacity(0.3),
              blurRadius: _isHovered[index] == true ? 15 : 5,
              spreadRadius: _isHovered[index] == true ? 3 : 1,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                _isHovered[index] == true ? hoverText : normalText,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
