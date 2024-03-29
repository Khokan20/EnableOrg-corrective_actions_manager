import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enableorg/services/auth_state.dart';
import 'package:enableorg/ui/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:enableorg/models/user.dart' as model;

class UserLoginPage extends StatefulWidget {
  final Function(model.User) onLoginSuccess;
  final AuthState authState;

  UserLoginPage({required this.onLoginSuccess, required this.authState});

  @override
  State<UserLoginPage> createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  width: 600,
                  height: 196,
                  child: Image.asset('logo.png'),
                ),
                const SizedBox(height: 20),
                Text(
                  'User Login ',
                  style: TextStyle(
                    color: Color.fromARGB(255, 5, 36, 83),
                    fontSize: 20,
                    fontFamily: 'Cormorant Garamond',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Container(
                    width: 360.0,
                    height: 41.0,
                    decoration: BoxDecoration(color: Color(0xFFF0F0F0)),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 6, 3, 26), width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 1, 2, 14),
                              width: 0.0), // Bottom Border when focused
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 7, 5, 26), width: 0.0),
                          // Left Border when not focused
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.orange,
                              width: 0.0), // Right Border on error
                        ),
                        hintText: 'Email',
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter an email';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    width: 360.0,
                    height: 41.0,
                    decoration: BoxDecoration(color: Color(0xFFF0F0F0)),
                    child: TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 1, 2, 14),
                              width: 0.0), // Bottom Border when focused
                        ),
                        hintText: 'Password',
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: SizedBox(
                    width: 183.0,
                    height: 58.0,
                    child: CustomButton(
                      text: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontFamily: 'Cormorant Garamond',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          _loginWithEmailAndPassword();
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/manager/login');
                  },
                  child: Text('Manager Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _loginWithEmailAndPassword() async {
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      final UserCredential? userCredential =
          await widget.authState.signInWithEmailAndPassword(email, password);

      if (userCredential != null) {
        final User? firebaseUser = userCredential.user;

        if (firebaseUser != null) {
          final uid = firebaseUser.uid;

          final DocumentSnapshot userDocument = await FirebaseFirestore.instance
              .collection('User')
              .doc(uid)
              .get();

          final currentUser = model.User.fromDocumentSnapshot(userDocument);

          widget.onLoginSuccess(currentUser);
        }
      } else {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Login Error'),
            content: Text('Failed to log in. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('Login Error: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Login Error'),
          content: Text('Failed to log in. Please try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
