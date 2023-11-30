import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cities/nyc.dart';
import 'cities/sanFran.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey,
        scaffoldBackgroundColor: const Color(0xFF343541),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: [
              CityButton(
                imageAsset: 'images/nyc.png',
                label: 'NYC',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NYCScreen()),
                  );
                },
                backgroundColor: const Color(0xFFc197fb),
              ),
              const SizedBox(height: 12),
              CityButton(
                imageAsset: 'images/golden_gate.png',
                label: 'San\nFrancisco',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SanFran()),
                  );
                },
                backgroundColor: const Color(0xFF1fddcd),
              ),
              const SizedBox(height: 12),
              CityButton(
                imageAsset: 'images/madrid.png',
                label: 'Madrid',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NYCScreen()),
                  );
                },
                backgroundColor: const Color(0xFFfbc275),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CityButton extends StatelessWidget {
  final String imageAsset;
  final String label;
  final Color backgroundColor;
  final VoidCallback onPressed; // Added this line for the onPressed callback

  const CityButton({
    super.key,
    required this.imageAsset,
    required this.label,
    required this.backgroundColor,
    required this.onPressed, // Add this line to accept the onPressed parameter
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.all(0),
      ),
      onPressed: onPressed, // Use the passed callback here
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.asset(
                  imageAsset,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: GoogleFonts.dancingScript(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
