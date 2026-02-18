import 'package:firebase_core/firebase_core.dart';

import 'app_environment.dart';

class FirebaseBootstrap {
  static Future<FirebaseApp> initialize(AppEnvironment environment) {
    // Integrate generated `firebase_options.dart` here. Example:
    // return Firebase.initializeApp(
    //   options: environment.isProduction
    //       ? DefaultFirebaseOptions.currentPlatformProd
    //       : DefaultFirebaseOptions.currentPlatformDev,
    // );

    // For starter mode, default init is used.
    return Firebase.initializeApp();
  }
}
