import 'package:flutter/material.dart';
import 'package:realturn_app/Screens/Donating.dart';
import 'package:realturn_app/Screens/credit_card.dart';
import 'package:realturn_app/Screens/mobile_money.dart';


class DonationScreen extends StatelessWidget {
  const DonationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 4, 104, 253),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 248, 247, 247)),
          onPressed: () {
            Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DonatingScreen()));
          },
        ),
      ),
      body: Column(
        children: [
          Expanded( // Expands to fill available space
            child: Center( // Centers buttons in available space
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 20.0),
                      child: Text(
                        "Support Real Tennis Projects!\nYour donation empowers communities and changes lives.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    DonationButton(
                      text: "Donate with Mobile Money",
                      borderColor: Colors.black,
                      textColor: Colors.black,
                      onTap: () {
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MobileMoneyScreen ()));
                      },
                    ),
                    const SizedBox(height: 20),
                    DonationButton(
                      text: "Donate with Debit or Credit Card",
                      borderColor: Colors.blue,
                      textColor: Colors.blue,
                      onTap: () {
                       Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DonationForm()));
                      },
                    ),
                    const SizedBox(height: 20),
                    // DonationButton(
                    //   text: "Donate with PayPal",
                    //   borderColor: Colors.black,
                    //   textColor: Colors.black,
                    //   onTap: () {
                    //      Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => DonationScreenOptions()));
                    //   },
                    // ),
                  ],
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                "© 2025 Realturn Tennis uganda",
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DonationButton extends StatelessWidget {
  final String text;
  final Color borderColor;
  final Color textColor;
  final VoidCallback onTap;

  const DonationButton({super.key, 
    required this.text,
    required this.borderColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity, // Make buttons full width
        height: 50,  // Standard button height
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: 2),
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(2, 3),
            ),
          ],
        ),
        child: TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          child: Text(
            text,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}