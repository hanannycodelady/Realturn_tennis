import 'package:flutter/material.dart';
import 'package:realturn_app/Screens/credit_card.dart';



class DonationScreenOptions extends StatefulWidget {
  const DonationScreenOptions({super.key});

  @override
  _DonationScreenOptionsState createState() => _DonationScreenOptionsState();
}

class _DonationScreenOptionsState extends State<DonationScreenOptions> {
  String selectedAmount = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Donate to",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
            ),
            const SizedBox(height: 5),
            const Text(
              "Realtum Projects",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 5),
            const Text(
              "Make a difference and put a smile",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                donationButton("20"),
                donationButton("50"),
                donationButton("100"),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Or",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
            ),
            const SizedBox(height: 10),
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter amount",
                hintStyle: TextStyle(color: Colors.black54),
              ),
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DonationForm()),
                      );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.black),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              ),
              child: const Text(
                "Donate with Debit or Credit Card",
                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            const Spacer(),
            const Text(
              "2024 real turn projects",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget donationButton(String amount) {
    bool isSelected = selectedAmount == amount;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedAmount = amount;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
        child: Column(
          children: [
            Text(
              "\$ $amount",
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "USD",
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
