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
    apiKey: 'AIzaSyBX07Wo1-jWub7H1x_RxZXg7GETF9HvWII',
    appId: '1:280513985105:web:8f372cbd90beccb912d670',
    messagingSenderId: '280513985105',
    projectId: 'melbourne-tourist-app',
    authDomain: 'melbourne-tourist-app.firebaseapp.com',
    storageBucket: 'melbourne-tourist-app.appspot.com',
    measurementId: 'G-B8EXDL2EE7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAPZAKssBZO6g1aKq79XbPiCTubrBrl8FY',
    appId: '1:280513985105:android:872498a3d6b836af12d670',
    messagingSenderId: '280513985105',
    projectId: 'melbourne-tourist-app',
    storageBucket: 'melbourne-tourist-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAIdg2CaFd6hlHcSuzEjOgY7QjiNYhHVVo',
    appId: '1:280513985105:ios:110ddb9bf36c81eb12d670',
    messagingSenderId: '280513985105',
    projectId: 'melbourne-tourist-app',
    storageBucket: 'melbourne-tourist-app.appspot.com',
    iosBundleId: 'com.example.tourist',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAIdg2CaFd6hlHcSuzEjOgY7QjiNYhHVVo',
    appId: '1:280513985105:ios:110ddb9bf36c81eb12d670',
    messagingSenderId: '280513985105',
    projectId: 'melbourne-tourist-app',
    storageBucket: 'melbourne-tourist-app.appspot.com',
    iosBundleId: 'com.example.tourist',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBX07Wo1-jWub7H1x_RxZXg7GETF9HvWII',
    appId: '1:280513985105:web:1580253b655c823e12d670',
    messagingSenderId: '280513985105',
    projectId: 'melbourne-tourist-app',
    authDomain: 'melbourne-tourist-app.firebaseapp.com',
    storageBucket: 'melbourne-tourist-app.appspot.com',
    measurementId: 'G-SFW0GHWJJQ',
  );
}
