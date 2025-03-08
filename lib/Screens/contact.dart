import 'package:flutter/material.dart';

class ContactUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate to the previous screen (Menu)
          },
        ),
        title: Text('Contact', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/image/image 5.jpg',
                 // color: const Color.fromARGB(255, 253, 251, 251).withOpacity(0.3),
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 30,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CONTACT US !',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 10, 10, 10),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'www.youtube.com/@realturnprojects9651',
                        style: TextStyle(
                          fontSize: 16,
                          color: const Color.fromARGB(255, 12, 12, 12),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'TEL: +256 756 873677',
                        style: TextStyle(
                          fontSize: 16,
                          color: const Color.fromARGB(255, 12, 12, 12),
                          fontWeight: FontWeight.bold,
                        
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Please fill in the form below if you have any questions.',
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color.fromARGB(255, 7, 7, 7),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildTextField('Name'),
                  SizedBox(height: 10),
                  _buildTextField('Email'),
                  SizedBox(height: 10),
                  _buildTextField('Subject'),
                  SizedBox(height: 10),
                  _buildTextField('Message', maxLines: 5),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white, fontSize: 16),
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

  Widget _buildTextField(String label, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}


