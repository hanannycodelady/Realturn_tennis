import 'package:flutter/material.dart';
import 'package:realturn_app/Screens/sign_up.dart'; 
import 'package:realturn_app/Screens/sign_in.dart';  
import 'package:realturn_app/Screens/home_screen.dart';
import 'package:realturn_app/Screens/splash_screen.dart';     

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isSignUpSelected = true;

  void navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpScreen()), 
    );
  }

  void navigateToSignIn() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen()), 
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
          icon: Icon(Icons.arrow_back),
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
                Text(
                  'Nothing comes out of doing nothing',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: navigateToSignUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isSignUpSelected ? Color(0xFF0867F5) : Colors.white,
                        foregroundColor:
                            isSignUpSelected ? Colors.white : Colors.black,
                        shadowColor: Color(0xFF0867F5),
                        elevation: 10,
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Color(0xFF0867F5)),
                        ),
                      ),
                      child: Text(
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
                            ? Color(0xFF0867F5)
                            : Colors.white,
                        foregroundColor:
                            !isSignUpSelected ? Colors.white : Colors.black,
                        shadowColor: Color(0xFF0867F5),
                        elevation: 10,
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Color(0xFF0867F5)),
                        ),
                      ),
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25),
              ],
            ),
          ),
          Flexible(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
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
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
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
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: skipToHome,
                      child: Text(
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


