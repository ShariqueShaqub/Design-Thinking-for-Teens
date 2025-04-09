import 'package:design_thinking/Home/Home.dart';
import 'package:design_thinking/onboard_screens/s1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream:
          FirebaseAuth.instance.authStateChanges(), // Listen for auth changes
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()), // Show loading
          );
        } else if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text("Something went wrong. Please try again."),
            ),
          );
        } else if (snapshot.hasData) {
          // User is logged in, navigate to HomeScreen
          return const Home();
        } else {
          // No user logged in, show LoginScreen
          return const S1();
        }
      },
    );
  }
}
