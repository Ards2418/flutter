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
    apiKey: 'AIzaSyALCqlKvEoQNHtPmkJfMAgcOqDdRl3heGA',
    appId: '1:909983381447:web:a6bbce1e49542c2eaacbe2',
    messagingSenderId: '909983381447',
    projectId: 'riskband-7551a',
    authDomain: 'riskband-7551a.firebaseapp.com',
    databaseURL: 'https://riskband-7551a-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'riskband-7551a.firebasestorage.app',
    measurementId: 'G-0B1SHDN9L4',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA9sFfgiOetBAVGeuj10KcCWFzCxjXxRQc',
    appId: '1:909983381447:android:0142498f041fa03eaacbe2',
    messagingSenderId: '909983381447',
    projectId: 'riskband-7551a',
    databaseURL: 'https://riskband-7551a-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'riskband-7551a.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD3R3viieiRO2VWvN7_cEDvrMSdIQLR3ok',
    appId: '1:909983381447:ios:8d9d2f7634a688dbaacbe2',
    messagingSenderId: '909983381447',
    projectId: 'riskband-7551a',
    databaseURL: 'https://riskband-7551a-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'riskband-7551a.firebasestorage.app',
    iosBundleId: 'com.example.wristband',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD3R3viieiRO2VWvN7_cEDvrMSdIQLR3ok',
    appId: '1:909983381447:ios:8d9d2f7634a688dbaacbe2',
    messagingSenderId: '909983381447',
    projectId: 'riskband-7551a',
    databaseURL: 'https://riskband-7551a-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'riskband-7551a.firebasestorage.app',
    iosBundleId: 'com.example.wristband',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyALCqlKvEoQNHtPmkJfMAgcOqDdRl3heGA',
    appId: '1:909983381447:web:8740a274d0487e42aacbe2',
    messagingSenderId: '909983381447',
    projectId: 'riskband-7551a',
    authDomain: 'riskband-7551a.firebaseapp.com',
    databaseURL: 'https://riskband-7551a-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'riskband-7551a.firebasestorage.app',
    measurementId: 'G-NY66XL7JRJ',
  );
}
