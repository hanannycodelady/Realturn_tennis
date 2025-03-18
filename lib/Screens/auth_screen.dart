import 'package:flutter/material.dart';
import 'package:realturn_app/Screens/sign_up.dart'; 
import 'package:realturn_app/Screens/sign_in.dart';  
import 'package:realturn_app/Screens/home_screen.dart';
import 'package:realturn_app/Screens/splash_screen.dart';     


class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isSignUpSelected = true;

  void navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpScreen()), 
    );
  }

  void navigateToSignIn() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()), 
    );
  }

  void skipToHome() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()), 
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>SplashScreen())
              );
            
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Nothing comes out of doing nothing',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: navigateToSignUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isSignUpSelected ? const Color(0xFF0867F5) : Colors.white,
                        foregroundColor:
                            isSignUpSelected ? Colors.white : Colors.black,
                        shadowColor: const Color(0xFF0867F5),
                        elevation: 10,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: Color(0xFF0867F5)),
                        ),
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: navigateToSignIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: !isSignUpSelected
                            ? const Color(0xFF0867F5)
                            : Colors.white,
                        foregroundColor:
                            !isSignUpSelected ? Colors.white : Colors.black,
                        shadowColor: const Color(0xFF0867F5),
                        elevation: 10,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: Color(0xFF0867F5)),
                        ),
                      ),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
          Flexible(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: const BoxDecoration(
                  color: Color(0xFF0867F5),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/image/Frame_59-removebg-preview.png',
                        height: 200,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Inspiring people to use available resources to achieve success in whatever they aspire for in life',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: skipToHome,
                      child: const Text(
                        "Skip",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


