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
    apiKey: 'AIzaSyAcyRafTpmz_H2jdpGOS9WxSxxBvAhyxSs',
    appId: '1:1065931345822:web:11adbf9f5b93914181908f',
    messagingSenderId: '1065931345822',
    projectId: 'your-self-laff',
    authDomain: 'your-self-laff.firebaseapp.com',
    storageBucket: 'your-self-laff.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB6xlT2_XFud5ebiRxklJMWo9whde18QFA',
    appId: '1:1065931345822:android:b691e263306ae31d81908f',
    messagingSenderId: '1065931345822',
    projectId: 'your-self-laff',
    storageBucket: 'your-self-laff.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC8nzdOZ3R3glKizPO5FMzNxfL6eZ31B_U',
    appId: '1:1065931345822:ios:c66d55165373d21781908f',
    messagingSenderId: '1065931345822',
    projectId: 'your-self-laff',
    storageBucket: 'your-self-laff.appspot.com',
    iosClientId: '1065931345822-o8g1u4q2d9amj78rk2ks5645vg37t59q.apps.googleusercontent.com',
    iosBundleId: 'com.example.studyWithFront',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC8nzdOZ3R3glKizPO5FMzNxfL6eZ31B_U',
    appId: '1:1065931345822:ios:c66d55165373d21781908f',
    messagingSenderId: '1065931345822',
    projectId: 'your-self-laff',
    storageBucket: 'your-self-laff.appspot.com',
    iosClientId: '1065931345822-o8g1u4q2d9amj78rk2ks5645vg37t59q.apps.googleusercontent.com',
    iosBundleId: 'com.example.studyWithFront',
  );
}