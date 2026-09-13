import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'dart:io' show Platform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (Platform.isAndroid) {
      return android;
    } else if (Platform.isIOS) {
      return ios;
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  // Android Firebase Configuration
  // Generated from: google-services.json
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyACxG96OQJW2o7mSCArOV-A-DAj-iCQeZ0',
    appId: '1:482545009297:android:213651267204881b5db530',
    messagingSenderId: '482545009297',
    projectId: 'connectcall-project',
    databaseURL: 'https://connectcall-project.firebaseio.com',
    storageBucket: 'connectcall-project.firebasestorage.app',
  );

  // iOS Firebase Configuration
  // Generated from: GoogleService-Info.plist
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBAZOMWUhZ2HO1wK1PZRIEKOi6aKuOte1I',
    appId: '1:482545009297:ios:a673b8992bef2c695db530',
    messagingSenderId: '482545009297',
    projectId: 'connectcall-project',
    databaseURL: 'https://connectcall-project.firebaseio.com',
    storageBucket: 'connectcall-project.firebasestorage.app',
    iosBundleId: 'com.connectcall.app',
  );
}

// Firebase Configuration Status: ✅ READY TO USE
// 
// Android: google-services.json in android/app/
// iOS: GoogleService-Info.plist in ios/Runner/
//
// Next steps:
// 1. Ensure google-services.json is in: android/app/google-services.json
// 2. Ensure GoogleService-Info.plist is in: ios/Runner/GoogleService-Info.plist (add via Xcode)
// 3. Run: flutter pub get
// 4. Run: flutter run -d android (or flutter run -d ios)
//
// Firebase Services Enabled:
// ✅ Authentication (Email/Password)
// ✅ Firestore Database
// ✅ Cloud Storage
// ✅ Cloud Messaging (Push Notifications)
