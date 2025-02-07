import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Logo Image
          Center(
            child: Image.asset(
              'assets/image/logo.JPG', 
              height: 400,
              width: 400,
            ),
          ),
          SizedBox(height: 30),

          // Start journey Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: ElevatedButton(
              onPressed: () {
                // Navigate to Auth Screen
                Navigator.pushReplacementNamed(context, '/AuthScreen');
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30), // Adjusted padding
                backgroundColor: const Color.fromARGB(255, 10, 130, 228),
              ),
              child: Text(
                'Start Journey',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
