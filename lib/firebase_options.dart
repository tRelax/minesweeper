// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
    apiKey: 'AIzaSyBaqTGkRujVfVrccbtuebiCZlk2NqkwnN8',
    appId: '1:893953208039:web:e7ea7e3a446e2af31cbc42',
    messagingSenderId: '893953208039',
    projectId: 'minesweeper-a95dd',
    authDomain: 'minesweeper-a95dd.firebaseapp.com',
    storageBucket: 'minesweeper-a95dd.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBmXQqaTkOcRK1o6K6YIGwzH5_BuiCrKaQ',
    appId: '1:893953208039:android:0dde4979176d44561cbc42',
    messagingSenderId: '893953208039',
    projectId: 'minesweeper-a95dd',
    storageBucket: 'minesweeper-a95dd.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCSVOODVfLawsTWpVtD4ajZnfYDn3jUq2g',
    appId: '1:893953208039:ios:b74862309030df631cbc42',
    messagingSenderId: '893953208039',
    projectId: 'minesweeper-a95dd',
    storageBucket: 'minesweeper-a95dd.appspot.com',
    iosBundleId: 'com.example.minesweeper',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCSVOODVfLawsTWpVtD4ajZnfYDn3jUq2g',
    appId: '1:893953208039:ios:754777f7a884e8591cbc42',
    messagingSenderId: '893953208039',
    projectId: 'minesweeper-a95dd',
    storageBucket: 'minesweeper-a95dd.appspot.com',
    iosBundleId: 'com.example.minesweeper.RunnerTests',
  );
}