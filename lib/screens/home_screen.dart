import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Hub'),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                GoogleSignIn().signOut();
              },
              icon: const Icon(Icons.exit_to_app_outlined))
        ],
      ),
      body: const Center(
        child: Text(
          "Welcome to the Home Screen",
          style: TextStyle(
            fontSize: 40,
          ),
        ),
      ),
    );
  }
}
