import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for all platforms.
/// Replace the placeholder values with your Firebase project settings.
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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCJucHXbr4USJ2CthAXAZbcwk7Z27Izc9Y',
    appId: '1:410039626889:web:5258ae07465a05071d6a58',
    messagingSenderId: '410039626889',
    projectId: 'quitmate-app-a21a9',
    authDomain: 'quitmate-app-a21a9.firebaseapp.com',
    storageBucket: 'quitmate-app-a21a9.firebasestorage.app',
    measurementId: 'G-V7SG91NTK3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCJucHXbr4USJ2CthAXAZbcwk7Z27Izc9Y',
    appId: '1:410039626889:android:c017ef553404fa961d6a58',
    messagingSenderId: '410039626889',
    projectId: 'quitmate-app-a21a9',
    storageBucket: 'quitmate-app-a21a9.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCJucHXbr4USJ2CthAXAZbcwk7Z27Izc9Y',
    appId: '1:410039626889:ios:0157d4f7b9abef031d6a58',
    messagingSenderId: '410039626889',
    projectId: 'quitmate-app-a21a9',
    storageBucket: 'quitmate-app-a21a9.firebasestorage.app',
    iosBundleId: 'com.example.quitmate',
  );
}
