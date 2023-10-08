import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback onRegistrationSuccess;

  RegisterPage({required this.onRegistrationSuccess});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Text('Register Page'),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter an email';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter a password';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  _registerWithEmailAndPassword();
                }
              },
              child: Text('Register'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                  (route) => false,
                );
              },
              child: const Text("Return to Log in"),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _registerWithEmailAndPassword() async {
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      // Register the user with Firebase Authentication
      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the user ID
      final String userId = userCredential.user!.uid;

      // Save user data to Firestore
      final CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('User');

      await usersCollection.doc(userId).set({
        'email': email,
        'type': 'user'
        // Add additional user data as needed
      });

      widget
          .onRegistrationSuccess(); // Call the callback on registration success
    } catch (e) {
      // Handle registration error here
      print('Registration Error: $e');

      showDialog(
        context: context,
        builder: (_) => _buildErrorDialog(),
      );
    }
  }

  Widget _buildErrorDialog() {
    return AlertDialog(
      title: Text('Registration Error'),
      content: Text('Failed to register. Email Already exists.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}
