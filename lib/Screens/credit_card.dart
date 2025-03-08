 import 'package:flutter/material.dart';

class CreditCardDonationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              // Back Arrow
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Spacer(),
                  Text(
                    "Donate to",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  Spacer(),
                ],
              ),
              Text(
                "Real turn tennis",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),

              // Dropdown (Country Selection)
              _buildDropdown(),

              SizedBox(height: 20),

              // Card Number
              _buildTextField("Card number"),

              SizedBox(height: 10),

              // Expiry & Security Code (Side by Side)
              Row(
                children: [
                  Expanded(child: _buildTextField("Expires")),
                  SizedBox(width: 10),
                  Expanded(child: _buildTextField("Security code")),
                ],
              ),

              SizedBox(height: 10),

              // Personal Information Fields
              _buildTextField("First name"),
              SizedBox(height: 10),
              _buildTextField("Last name"),
              SizedBox(height: 10),
              _buildTextField("Phone number"),
              SizedBox(height: 10),
              _buildTextField("Email"),

              SizedBox(height: 10),

              // Checkbox (Save info for next time)
              Row(
                children: [
                  Checkbox(value: false, onChanged: (value) {}),
                  Expanded(
                    child: Text(
                      "Save this information for next time",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),

              // Donate Button
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  "Donate now",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),

              Spacer(),

              // Footer
              Text(
                "© 2024 real turn projects",
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),

              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // Text Field Builder
  Widget _buildTextField(String hintText) {
    return TextField(
      style: TextStyle(color: Colors.black, fontSize: 16), // Increased font size
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.black, fontSize: 16), // Visible hint
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      ),
    );
  }

  // Dropdown Builder
  Widget _buildDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white, // Background for visibility
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: "Uganda",
          dropdownColor: Colors.white, // Ensuring dropdown is visible
          items: ["Uganda", "Kenya", "Tanzania", "Rwanda"]
              .map((country) => DropdownMenuItem(
                    value: country,
                    child: Text(country, style: TextStyle(color: Colors.black, fontSize: 16)),
                  ))
              .toList(),
          onChanged: (value) {},
        ),
      ),
    );
  }
}
