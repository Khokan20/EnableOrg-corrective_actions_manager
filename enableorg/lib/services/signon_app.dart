import 'package:firebase_core/firebase_core.dart';

class FirebaseSecondaryApp {
  // Singleton
  static FirebaseApp? _secondaryApp;

  static Future<FirebaseApp?> get secondaryApp async {
    if (_secondaryApp != null) {
      return _secondaryApp;
    }

    _secondaryApp = await Firebase.initializeApp(
      name: 'SecondaryApp',
      options: Firebase.app().options,
    );
    return _secondaryApp;
  }
}
