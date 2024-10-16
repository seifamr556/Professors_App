import 'package:college_application/screens/home_screen.dart';
import 'package:college_application/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InitialScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream:
          FirebaseAuth.instance.authStateChanges(), // Listen to auth changes
      builder: (context, snapshot) {
        // If the user is logged in, navigate to HomeScreen
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return LoginScreen(); // User not logged in
          } else {
            return HomeScreen(); // User is logged in
          }
        } else {
          // While checking for auth state, show a loading indicator
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
