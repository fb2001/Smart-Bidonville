import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
            'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAsrIi1LrFikrWkcqsbMfCauBBpAVCA6Z0',
    appId: '1:709314346120:android:77dab2944811eb36d9b33d',
    messagingSenderId: '709314346120',
    projectId: 'smart-bidonville',
    storageBucket: 'smart-bidonville.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDV_AawMtatFi4sRU5ghZb2wtIXHc0GfYk',
    appId: '1:709314346120:ios:c9a78d5fcfc7a87dd9b33d',
    messagingSenderId: '709314346120',
    projectId: 'smart-bidonville',
    storageBucket: 'smart-bidonville.firebasestorage.app',
    iosBundleId: 'com.example.smartBidonville',
  );

  // Pour macOS, si tu veux tester sur macOS, tu peux réutiliser la config iOS :
  static const FirebaseOptions macos = ios;
}
