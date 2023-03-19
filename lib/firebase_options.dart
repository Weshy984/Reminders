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
    apiKey: 'AIzaSyDXsf1BZiTR_LOLvYYjLmrzyy0U3HlYZaQ',
    appId: '1:137397697275:web:ea3bbd80f7e1fbac2c0e5e',
    messagingSenderId: '137397697275',
    projectId: 'reminder-mobx',
    authDomain: 'reminder-mobx.firebaseapp.com',
    storageBucket: 'reminder-mobx.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA31xv52HtXcHJFJGFHGOa3smqaAegy6Fk',
    appId: '1:137397697275:android:7312d0a3ffd257a62c0e5e',
    messagingSenderId: '137397697275',
    projectId: 'reminder-mobx',
    storageBucket: 'reminder-mobx.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDz_Ybkli5i99rXVwfqkKez9EilGXhjXeA',
    appId: '1:137397697275:ios:c2338e9c6dd3a1022c0e5e',
    messagingSenderId: '137397697275',
    projectId: 'reminder-mobx',
    storageBucket: 'reminder-mobx.appspot.com',
    iosClientId: '137397697275-j8hj005qhh1svgqfbvm5vddvaqblv32f.apps.googleusercontent.com',
    iosBundleId: 'com.example.sample',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDz_Ybkli5i99rXVwfqkKez9EilGXhjXeA',
    appId: '1:137397697275:ios:c2338e9c6dd3a1022c0e5e',
    messagingSenderId: '137397697275',
    projectId: 'reminder-mobx',
    storageBucket: 'reminder-mobx.appspot.com',
    iosClientId: '137397697275-j8hj005qhh1svgqfbvm5vddvaqblv32f.apps.googleusercontent.com',
    iosBundleId: 'com.example.sample',
  );
}
