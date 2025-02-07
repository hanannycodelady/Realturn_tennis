import 'package:flutter/material.dart';
import 'package:realturn_app/Screens/Home_screen.dart';
import 'package:realturn_app/pages/Profile.dart';
import 'package:realturn_app/Screens/auth_screen.dart';
import 'package:realturn_app/Screens/sign_in.dart';
import 'package:realturn_app/Screens/sign_up.dart';
import 'package:realturn_app/Screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Realturn tennis uganda ',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/AuthScreen': (context) => AuthScreen(),
        '/SignUpScreen': (context) => SignUpScreen(),
        '/SignInScreen ': (context) =>  SignInScreen (),
        '/HomeScreen': (context) => HomeScreen(),
        '/EditProfile': (context) => EditProfile(),
      },
    );
  }
}
