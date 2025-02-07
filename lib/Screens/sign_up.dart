import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:realturn_app/Screens/sign_in.dart'; 

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.blue,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              "assets/image/image 5.jpg",
              fit: BoxFit.cover,
              width: double.infinity,
              height: 300,
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context); 
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Welcome to Realturn Tennis Uganda",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        _buildTextField("First name"),
                        _buildTextField("Last name"),
                        _buildTextField("Email address"),
                        _buildTextField("Password", isPassword: true),
                        _buildTextField("Contact"),
                        SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade800,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            minimumSize: Size(double.infinity, 50),
                          ),
                          onPressed: () {
                            // You can add your sign-up logic here
                            // After sign-up, navigate to SignInScreen
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignInScreen()), 
                            );
                          },
                          child: Text("Sign Up", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                        SizedBox(height: 10),
                        _buildSocialButton("Continue with Google", "assets/image/google-removebg-preview.png"),
                        _buildSocialButton("Continue with Apple", "assets/image/apple-removebg-preview.png"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String hintText, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              spreadRadius: 1,
              offset: Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          obscureText: isPassword,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hintText,
            hintStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            labelStyle: TextStyle(color: const Color.fromARGB(255, 12, 12, 12)),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(String text, String iconPath) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: OutlinedButton.icon(
        icon: Image.asset(iconPath, height: 24),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: BorderSide(color: Colors.white),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.symmetric(vertical: 15),
          minimumSize: Size(double.infinity, 50),
        ),
        onPressed: () {},
        label: Text(
          text,
          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:realturn_app/Screens/auth_screen.dart';

// class SignUpScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             color: Colors.blue, // Set the background color to blue
//           ),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Image.asset(
//               "assets/image/image 5.jpg",
//               fit: BoxFit.cover,
//               width: double.infinity,
//               height: 300, // Adjusted height to better fit the design
//             ),
//           ),
//           SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Align(
//                     alignment: Alignment.topLeft,
//                     child: IconButton(
//                       icon: Icon(Icons.arrow_back, color: Colors.white),
//                       onPressed: () {},
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   Container(
//                     padding: EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.3), // Transparent background
//                       borderRadius: BorderRadius.circular(15),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black26,
//                           blurRadius: 10,
//                           spreadRadius: 2,
//                           offset: Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Text(
//                           "Welcome to realturn tennis Uganda",
//                           textAlign: TextAlign.center,
//                           style: GoogleFonts.poppins(
//                             fontSize: 20,
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(height: 20),
//                         _buildTextField("First name"),
//                         _buildTextField("Last name"),
//                         _buildTextField("Email address"),
//                         _buildTextField("Password", isPassword: true),
//                         _buildTextField("Contact"),
//                         SizedBox(height: 20),
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blue.shade800,
//                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                             padding: EdgeInsets.symmetric(vertical: 15),
//                             minimumSize: Size(double.infinity, 50),
//                           ),
//                           onPressed: () {
//                             // Navigate to SignInScreen when Sign Up is pressed
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(builder: (context) => SignInScreen()),
//                             );
//                           },
//                           child: Text("Sign Up", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
//                         ),
//                         SizedBox(height: 10),
//                         _buildSocialButton("Continue with Google", "assets/image/google-removebg-preview.png"),
//                         _buildSocialButton("Continue with Apple", "assets/image/apple-removebg-preview.png"),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTextField(String hintText, {bool isPassword = false}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10.0),
//       child: Container(
//         decoration: BoxDecoration(
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black26,
//               blurRadius: 5,
//               spreadRadius: 1,
//               offset: Offset(0, 3),
//             ),
//           ],
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: TextField(
//           obscureText: isPassword,
//           decoration: InputDecoration(
//             filled: true,
//             fillColor: Colors.white,
//             hintText: hintText,
//             hintStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue), // Blue hint text
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
//             contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//             labelStyle: TextStyle(color: Colors.blue), // Blue text color for the input
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSocialButton(String text, String iconPath) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 10.0),
//       child: OutlinedButton.icon(
//         icon: Image.asset(iconPath, height: 24),
//         style: OutlinedButton.styleFrom(
//           backgroundColor: Colors.white, // White background for social buttons
//           side: BorderSide(color: Colors.white),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           padding: EdgeInsets.symmetric(vertical: 15),
//           minimumSize: Size(double.infinity, 50),
//         ),
//         onPressed: () {},
//         label: Text(
//           text,
//           style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold), // Black text for social buttons
//         ),
//       ),
//     );
//   }
// }
