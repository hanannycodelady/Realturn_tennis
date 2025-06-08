import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA4YeeQvlK82OjJH0XcoeSrMcaPqIQnJFM',
    appId: '1:348748402867:web:8737adb605e6d98546a0c6',
    messagingSenderId: '348748402867',
    projectId: 'kias-4c883',
    authDomain: 'kias-4c883.firebaseapp.com',
    databaseURL: 'https://kias-4c883-default-rtdb.firebaseio.com',
    storageBucket: 'kias-4c883.appspot.com',
    measurementId: 'G-0X2LDDFTZ3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY',
    appId: 'YOUR_ANDROID_APP_ID',
    messagingSenderId: '348748402867',
    projectId: 'kias-4c883',
    databaseURL: 'https://kias-4c883-default-rtdb.firebaseio.com',
    storageBucket: 'kias-4c883.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: '348748402867',
    projectId: 'kias-4c883',
    databaseURL: 'https://kias-4c883-default-rtdb.firebaseio.com',
    storageBucket: 'kias-4c883.appspot.com',
    iosClientId: 'YOUR_IOS_CLIENT_ID',
    iosBundleId: 'com.example.realturnApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'YOUR_MACOS_API_KEY',
    appId: 'YOUR_MACOS_APP_ID',
    messagingSenderId: '348748402867',
    projectId: 'kias-4c883',
    databaseURL: 'https://kias-4c883-default-rtdb.firebaseio.com',
    storageBucket: 'kias-4c883.appspot.com',
    iosClientId: 'YOUR_MACOS_CLIENT_ID',
    iosBundleId: 'com.example.realturnApp',
  );
}