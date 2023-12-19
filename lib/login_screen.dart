// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
// import 'package:firebase_core/firebase_core.dart';

// //
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Artwork Discovery',
//       theme: ThemeData.dark().copyWith(
//         primaryColor: Colors.deepPurple,
//         scaffoldBackgroundColor: const Color(0xFF121212),
//         appBarTheme: const AppBarTheme(
//           color: Colors.deepPurple,
//         ),
//       ),
//       home: const LoginScreen(),
//     );
//   }
// }

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({Key? key}) : super(key: key);

//   // Function to handle Google Sign-In
//   Future<UserCredential> signInWithGoogle() async {
//     // Trigger the Google Sign In process
//     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

//     // Obtain the auth details from the request
//     final GoogleSignInAuthentication? googleAuth =
//         await googleUser?.authentication;

//     // Create a new credential for Firebase
//     final GoogleAuthCredential credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth?.accessToken,
//       idToken: googleAuth?.idToken,
//     );

//     // Sign in to Firebase with the Google user credential
//     return FirebaseAuth.instance.signInWithCredential(credential);
//   }

//   // Function to handle Apple Sign-In
//   Future<UserCredential> signInWithApple() async {
//     // To be implemented: Apple Sign In logic
//     // Requires configuring Apple Developer account and project
//     throw UnimplementedError(
//         'The Apple Sign-In process has not been implemented.');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Please Login'),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () async {
//                 try {
//                   await signInWithGoogle();
//                   // On successful sign-in, navigate to the next screen
//                 } catch (e) {
//                   // Handle error, e.g., show a snackbar/message
//                 }
//               },
//               child: const Text('Sign in with Google'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 try {
//                   await signInWithApple();
//                   // On successful sign-in, navigate to the next screen
//                 } catch (e) {
//                   // Handle error, e.g., show a snackbar/message
//                 }
//               },
//               child: const Text('Sign in with Apple'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
