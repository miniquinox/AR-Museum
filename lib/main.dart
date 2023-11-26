import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cities/nyc.dart';
import 'cities/sanFran.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey,
        scaffoldBackgroundColor: Color(0xFF343541),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
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
                    MaterialPageRoute(builder: (context) => NYCScreen()),
                  );
                },
                backgroundColor: Color(0xFFc197fb),
              ),
              SizedBox(height: 12),
              CityButton(
                imageAsset: 'images/golden_gate.png',
                label: 'San\nFrancisco',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SanFran()),
                  );
                },
                backgroundColor: Color(0xFF1fddcd),
              ),
              SizedBox(height: 12),
              CityButton(
                imageAsset: 'images/madrid.png',
                label: 'Madrid',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NYCScreen()),
                  );
                },
                backgroundColor: Color(0xFFfbc275),
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

  CityButton({
    required this.imageAsset,
    required this.label,
    required this.backgroundColor,
    required this.onPressed, // Add this line to accept the onPressed parameter
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: backgroundColor,
        onPrimary: Colors.white,
        padding: EdgeInsets.all(0),
      ),
      onPressed: onPressed, // Use the passed callback here
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.all(16),
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
