import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enableorg/commonpages/manager_login.dart';
import 'package:enableorg/commonpages/user_login.dart';
import 'package:enableorg/controller/login_controller.dart';
import 'package:enableorg/pages/manager/manager_home_page.dart';
import 'package:enableorg/pages/user/user_home_page.dart';
import 'package:enableorg/register.dart';
import 'package:enableorg/services/signon_app.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:enableorg/models/user.dart';
import 'package:enableorg/services/auth_state.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseSecondaryApp.secondaryApp; // Initialize the SecondaryApp

  final AuthState authState = AuthState(); // Create an instance of AuthState
  initializeDateFormatting('en', null).then((_) {
    runApp(MyApp(authState: authState));
  });
}

class MyApp extends StatefulWidget {
  final AuthState authState;

  MyApp({required this.authState, Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final LoginController loginController = LoginController();

  @override
  void initState() {
    super.initState();
    mapAuthentication(); // Map authenticated user to local user model
  }

  Future<User?> mapAuthentication() async {
    final auth.User? firebaseUser = widget.authState.getCurrentUser();
    if (firebaseUser != null) {
      final userDocument = await FirebaseFirestore.instance
          .collection('User')
          .doc(firebaseUser.uid)
          .get();
      final currentUser = User.fromDocumentSnapshot(userDocument);
      loginController.onLoginSuccess(currentUser);
      return currentUser;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EnableOrg',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      initialRoute: '/manager/home',
      routes: {
        '/manager/home': (context) {
          return FutureBuilder<User?>(
            future: mapAuthentication(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(); // Return a placeholder widget while waiting
              } else if (snapshot.hasError ||
                  snapshot.data == null ||
                  !snapshot.data!.isManager) {
                Future.delayed(Duration.zero, () {
                  Navigator.pushNamed(context, '/manager/login');
                });
                return Container(); // Return a fallback widget if the user is not authenticated or not a manager
              } else {
                return ManagerHomePage(user: snapshot.data!);
              }
            },
          );
        },
        '/user/home': (context) {
          return FutureBuilder<User?>(
            future: mapAuthentication(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(); // Return a placeholder widget while waiting
              } else if (snapshot.hasError || snapshot.data == null) {
                Future.delayed(Duration.zero, () {
                  Navigator.pushNamed(context, '/user/login');
                });
                return Container(); // Return a fallback widget if the user is not authenticated or is a manager
              } else {
                return UserHomePage(user: snapshot.data!);
              }
            },
          );
        },
        '/manager/login': (context) => ManagerLoginPage(
              authState: widget.authState,
              onLoginSuccess: (user) {
                loginController.onLoginSuccess(user);
                Navigator.pushNamed(context, '/manager/home');
              },
            ),
        '/user/login': (context) => UserLoginPage(
              authState: widget.authState,
              onLoginSuccess: (user) {
                loginController.onLoginSuccess(user);
                Navigator.pushNamed(context, '/user/home');
              },
            ),
        '/register': (context) => RegisterPage(
              onRegistrationSuccess: () {
                Navigator.pushNamed(
                    context, '/user/home'); // Register will not be required
              },
            ),
        // '/test': (context) => CustomSlider(),
      },
    );
  }
}
