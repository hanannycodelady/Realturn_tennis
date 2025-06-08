import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Add Firebase Core
import 'package:realturn_app/Screens/Home_screen.dart';
import 'package:realturn_app/Screens/contact.dart';
import 'package:realturn_app/Screens/forgot_password.dart';
import 'package:realturn_app/Screens/notification.dart';
import 'package:realturn_app/pages/Profile.dart';
import 'package:realturn_app/Screens/auth_screen.dart';
import 'package:realturn_app/Screens/sign_in.dart';
import 'package:realturn_app/Screens/sign_up.dart';
import 'package:realturn_app/Screens/splash_screen.dart';
import 'package:app_links/app_links.dart';
import 'dart:io';
import 'firebase_options.dart'; // Import generated Firebase options

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Uses firebase_options.dart
  );
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

// Rest of your code remains unchanged
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    initDeepLinks();
  }

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();
    try {
      final initialUri = await _appLinks.getInitialAppLink();
      if (initialUri != null) {
        _handleDeepLink(initialUri);
      }
    } catch (e) {
      debugPrint('Error getting initial link: $e');
    }
    _linkSubscription =
        _appLinks.uriLinkStream.listen(_handleDeepLink, onError: (err) {
      debugPrint('Error in link stream: $err');
    });
  }

  void _handleDeepLink(Uri uri) {
    if (uri.scheme == 'realturn' && uri.path == '/reset-password') {
      final email = uri.queryParameters['email'];
      final token = uri.queryParameters['token'];
      if (email != null && token != null && mounted) {
        Navigator.pushNamed(
          context,
          '/ForgotPasswordScreen',
          arguments: {'email': email, 'token': token},
        );
      }
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Realturn Tennis Uganda',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/AuthScreen': (context) => const AuthScreen(),
        '/SignUpScreen': (context) => const SignUpScreen(),
        '/SignInScreen': (context) => const SignInScreen(),
        '/HomeScreen': (context) => const HomeScreen(),
        '/EditProfile': (context) => const EditProfile(),
        '/NotificationScreen': (context) => NotificationScreen(),
        '/ContactUsPage': (context) => const ContactUsScreen(),
        '/ForgotPasswordScreen': (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          if (args == null || args['email'] == null || args['token'] == null) {
            return const SignInScreen();
          }
          return ForgotPasswordScreen(
            email: args['email'],
            token: args['token'],
          );
        },
      },
    );
  }
}