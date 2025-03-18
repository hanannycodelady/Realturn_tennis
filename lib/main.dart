import 'package:flutter/material.dart';
import 'package:realturn_app/Screens/Home_screen.dart';
import 'package:realturn_app/Screens/contact.dart';
import 'package:realturn_app/Screens/notification.dart';
import 'package:realturn_app/pages/Profile.dart';
import 'package:realturn_app/Screens/auth_screen.dart';
import 'package:realturn_app/Screens/sign_in.dart';
import 'package:realturn_app/Screens/sign_up.dart';
import 'package:realturn_app/Screens/splash_screen.dart';
//import 'package:dio/dio.dart';
import 'dart:io';

void main() {
  HttpOverrides.global = MyHttpOverrides(); // Allow self-signed certificates
  runApp(MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Realturn Tennis Uganda',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/AuthScreen': (context) => AuthScreen(),
        '/SignUpScreen': (context) => const SignUpScreen(),
        '/SignInScreen': (context) => const SignInScreen(),
        '/HomeScreen': (context) => HomeScreen(),
        '/EditProfile': (context) => EditProfile(),
        '/NotificationScreen': (context) => NotificationScreen(),
        '/ContactUsPage': (context) => ContactUsScreen(),
      },
    );
  }
}