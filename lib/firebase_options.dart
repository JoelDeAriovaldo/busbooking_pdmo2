// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyDXojM7SweVTxrFN5ZfZj7MfWCRrVCPjo8',
    appId: '1:524298801068:web:dba6ad24fdd6330ace7409',
    messagingSenderId: '524298801068',
    projectId: 'busbooking-pdmo',
    authDomain: 'busbooking-pdmo.firebaseapp.com',
    storageBucket: 'busbooking-pdmo.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBUxamP14NcdkKd4JRq2oOKAtT6U_bH1sQ',
    appId: '1:524298801068:android:66789fcc8d2b1d85ce7409',
    messagingSenderId: '524298801068',
    projectId: 'busbooking-pdmo',
    storageBucket: 'busbooking-pdmo.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB7He8s3uieZWFRVFZxrSF2FAnZN7LdWoA',
    appId: '1:524298801068:ios:ac728a6776451975ce7409',
    messagingSenderId: '524298801068',
    projectId: 'busbooking-pdmo',
    storageBucket: 'busbooking-pdmo.appspot.com',
    iosBundleId: 'com.example.busbookingPdmo',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB7He8s3uieZWFRVFZxrSF2FAnZN7LdWoA',
    appId: '1:524298801068:ios:ac728a6776451975ce7409',
    messagingSenderId: '524298801068',
    projectId: 'busbooking-pdmo',
    storageBucket: 'busbooking-pdmo.appspot.com',
    iosBundleId: 'com.example.busbookingPdmo',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDXojM7SweVTxrFN5ZfZj7MfWCRrVCPjo8',
    appId: '1:524298801068:web:cf98b0705a9c8b29ce7409',
    messagingSenderId: '524298801068',
    projectId: 'busbooking-pdmo',
    authDomain: 'busbooking-pdmo.firebaseapp.com',
    storageBucket: 'busbooking-pdmo.appspot.com',
  );
}
