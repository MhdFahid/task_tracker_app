

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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDFP_K3OSp0Sa6clK8Q3EaiUrTTwxejNOQ',
    appId: '1:578883173574:android:fae6b556469815a2d6ebc7',
    messagingSenderId: '578883173574',
    projectId: 'tasktrackerapp-7dccb',
    storageBucket: 'tasktrackerapp-7dccb.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB0K1JhFsD6u7l7lL9giQmVBk5ORHNHOEo',
    appId: '1:578883173574:ios:f93e9312be374825d6ebc7',
    messagingSenderId: '578883173574',
    projectId: 'tasktrackerapp-7dccb',
    storageBucket: 'tasktrackerapp-7dccb.appspot.com',
    iosBundleId: 'com.example.taskTrackerApp',
  );
}
