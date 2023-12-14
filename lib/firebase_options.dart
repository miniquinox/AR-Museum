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
    apiKey: 'AIzaSyA7Dn9sZ69Za6fZvf9ilYOqAuMU2dOeJKQ',
    appId: '1:21274265339:web:15047c455a3e399a1c525e',
    messagingSenderId: '21274265339',
    projectId: 'ar-museum-optimiz3d',
    authDomain: 'ar-museum-optimiz3d.firebaseapp.com',
    storageBucket: 'ar-museum-optimiz3d.appspot.com',
    measurementId: 'G-LM843MD5GV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC0-YxjosXdGOQ3Sz8ttxfbQJq7JILv-O8',
    appId: '1:21274265339:android:cd63b93a28eb8bb11c525e',
    messagingSenderId: '21274265339',
    projectId: 'ar-museum-optimiz3d',
    storageBucket: 'ar-museum-optimiz3d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA9X0BEMaeO2xiTU01a_pSGU8Aq14N6jUg',
    appId: '1:21274265339:ios:c7220f7a0b779f3a1c525e',
    messagingSenderId: '21274265339',
    projectId: 'ar-museum-optimiz3d',
    storageBucket: 'ar-museum-optimiz3d.appspot.com',
    iosBundleId: 'com.example.davisProject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA9X0BEMaeO2xiTU01a_pSGU8Aq14N6jUg',
    appId: '1:21274265339:ios:18ef5ff410ea17131c525e',
    messagingSenderId: '21274265339',
    projectId: 'ar-museum-optimiz3d',
    storageBucket: 'ar-museum-optimiz3d.appspot.com',
    iosBundleId: 'com.example.davisProject.RunnerTests',
  );
}