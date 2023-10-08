import 'package:enableorg/ui/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enableorg/models/user.dart' as model;
import 'package:enableorg/services/auth_state.dart';

class ManagerLoginPage extends StatefulWidget {
  final Function(model.User) onLoginSuccess;
  final AuthState authState;

  ManagerLoginPage({required this.onLoginSuccess, required this.authState});

  @override
  State<ManagerLoginPage> createState() => _ManagerLoginPageState();
}

class _ManagerLoginPageState extends State<ManagerLoginPage> {
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
        child: Container(
          width: 581,
          height: 680,
          padding: const EdgeInsets.all(30),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            shadows: [
              BoxShadow(
                color: Color(0x0C000000),
                blurRadius: 16,
                offset: Offset(0, 0),
                spreadRadius: 0,
              )
            ],
          ),
          child: Form(
            key: _formKey, // Set the form key here
            child: Column(
              children: [
                SizedBox(
                  width: 600,
                  height: 196,
                  child: Image.asset('logo.png'),
                ),
                const SizedBox(height: 20),
                Text(
                  'Manager Login ',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.20000000298023224),
                    fontSize: 24,
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
                          border: const UnderlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 1, 2, 14),
                                width: 0.0), // Bottom Border when focused
                          ),
                          hintText: 'Email',
                          // The MaterialStateProperty's value is a text style that is orange
                          // by default, but the theme's error color if the input decorator
                          // is in its error state.
                          labelStyle: MaterialStateTextStyle.resolveWith(
                            (Set<MaterialState> states) {
                              final Color color =
                                  states.contains(MaterialState.error)
                                      ? Theme.of(context).colorScheme.error
                                      : Color.fromARGB(255, 5, 2, 17);
                              return TextStyle(
                                  color: color,
                                  letterSpacing: 1.3,
                                  height: 41.0);
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Enter Email';
                          }
                          return null;
                        },
                        //  autovalidateMode: AutovalidateMode.always,
                      )),
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
                        //border: const UnderlineInputBorder(),
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
                    Navigator.pushNamed(context, '/user/login');
                  },
                  child: Text('User Login'),
                ),
                const SizedBox(height: 16),
                Text(
                  'Forgot your password?',
                  style: TextStyle(
                    color: Color(0xFF161D58),
                    fontSize: 16,
                    fontFamily: 'Cormorant Garamond',
                    fontWeight: FontWeight.w400,
                  ),
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

          if (!currentUser.isManager) {
            throw ErrorDescription("User does not exist");
          }

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
