// import 'package:flutter/material.dart';

// // Verification Code Screen
// class VerificationCodeScreen extends StatefulWidget {
//   const VerificationCodeScreen({super.key});

//   @override
//   _VerificationCodeScreenState createState() => _VerificationCodeScreenState();
// }

// class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
//   // Controllers for each digit of the verification code
//   final List<TextEditingController> _controllers = List.generate(
//     4,
//     (index) => TextEditingController(),
//   );

//   // Focus nodes for each text field
//   final List<FocusNode> _focusNodes = List.generate(
//     4,
//     (index) => FocusNode(),
//   );

//   @override
//   void initState() {
//     super.initState();
//     // Auto-focus the first digit field when the screen loads
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _focusNodes[0].requestFocus();
//     });
//   }

//   @override
//   void dispose() {
//     // Dispose controllers and focus nodes to prevent memory leaks
//     for (var controller in _controllers) {
//       controller.dispose();
//     }
//     for (var node in _focusNodes) {
//       node.dispose();
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 241, 239, 239), // Dark background to contrast with white text
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const SizedBox(height: 50), // Space for status bar and back button
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Row(
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 15, 15, 15), size: 30),
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Center(
//               child: Container(
//                 width: MediaQuery.of(context).size.width * 0.9,
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.transparent, // Transparent background
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Text(
//                       "Are you sure want to proceed with the donations",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Color.fromARGB(255, 10, 10, 10), // White text
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     const Text(
//                       "Enter code from your email to verify payments",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Color.fromARGB(255, 12, 12, 12), // White text
//                       ),
//                     ),
//                     const SizedBox(height: 30),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: List.generate(
//                         4,
//                         (index) => _buildDigitField(index),
//                       ),
//                     ),
//                     const SizedBox(height: 30),
//                     ElevatedButton(
//                       onPressed: () {
//                         // Handle verification here
//                         String code = _controllers.map((c) => c.text).join();
//                         if (code.length == 4) {
//                           // Show success dialog
//                           _showSuccessDialog(context);
//                         } else {
//                           // Show error snackbar
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text("Please enter a valid 4-digit code"),
//                               backgroundColor: Colors.red,
//                             ),
//                           );
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue, // Blue button
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
//                       ),
//                       child: const Text(
//                         "SUBMIT",
//                         style: TextStyle(
//                           color: Colors.white, // White text
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//                     TextButton(
//                       onPressed: () {
//                         // Handle resend code logic
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text("Verification code resent"),
//                             backgroundColor: Colors.green,
//                           ),
//                         );
//                       },
//                       child: const Text(
//                         "Resend Code",
//                         style: TextStyle(
//                           color: Color.fromARGB(255, 5, 5, 5), // White text
//                           fontWeight: FontWeight.bold,
//                           decoration: TextDecoration.underline,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           const Padding(
//             padding: EdgeInsets.only(bottom: 16.0),
//             child: Text(
//               "© 2024 Real Tennis Projects",
//               style: TextStyle(
//                 fontSize: 12,
//                 fontStyle: FontStyle.italic,
//                 color: Color.fromARGB(255, 12, 12, 12), // White text
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Build individual digit input field
//   Widget _buildDigitField(int index) {
//     return Container(
//       width: 50,
//       height: 50,
//       margin: const EdgeInsets.symmetric(horizontal: 5),
//       decoration: BoxDecoration(
//         color: Colors.grey[200], // Light grey background for input fields
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.grey[400]!), // Light grey border
//       ),
//       child: TextField(
//         controller: _controllers[index],
//         focusNode: _focusNodes[index],
//         textAlign: TextAlign.center,
//         keyboardType: TextInputType.number,
//         maxLength: 1,
//         style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
//         decoration: const InputDecoration(
//           counterText: "",
//           border: InputBorder.none, // No additional border inside
//         ),
//         onChanged: (value) {
//           if (value.isNotEmpty) {
//             // Auto-focus to next field
//             if (index < 3) {
//               _focusNodes[index + 1].requestFocus();
//             } else {
//               // Last digit, hide keyboard
//               FocusScope.of(context).unfocus();
//             }
//           }
//         },
//       ),
//     );
//   }

//   // Show success dialog after verification
//   void _showSuccessDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Icon(
//             Icons.check_circle,
//             color: Colors.green,
//             size: 70,
//           ),
//           content: const Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 "Thank You!",
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 "Your donation has been processed successfully.",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 16),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 // Close dialog and navigate back to home/initial screen
//                 Navigator.of(context).pop();
//                 // You might want to navigate back more than once depending on your app structure
//                 Navigator.of(context).pop();
//                 Navigator.of(context).pop();
//               },
//               child: const Text("Done"),
//             ),
//           ],
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//         );
//       },
//     );
//   }
// }