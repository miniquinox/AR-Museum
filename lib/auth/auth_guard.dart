import 'dart:async';

import 'package:davis_project/main.dart';
import 'package:davis_project/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// This is the first page that the app loads.
/// It checks if the user is logged in or not, and navigates to splash or login page accordingly.

class AuthGaurdPage extends StatefulWidget {
  const AuthGaurdPage({super.key});

  @override
  State<AuthGaurdPage> createState() => _AuthGaurdPageState();
}

class _AuthGaurdPageState extends State<AuthGaurdPage> {
  late StreamSubscription _authSubscription;

  @override
  void initState() {
    GoogleSignIn().signOut();
    GoogleSignIn().disconnect();
    FirebaseAuth.instance.signOut();
    _authSubscription =
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SplashScreen(),
          ),
        );
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MainScreen(),
            ));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
