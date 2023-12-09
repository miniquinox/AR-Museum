import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'SF.dart'; // Ensure this matches the file name of your San Francisco screen
import 'Signup.dart'; // Ensure this matches the file name of your Signup screen
import 'LumaAIModelScreen.dart'; // Ensure this matches the file name of your Luma AI screen
import 'pricing.dart';
import 'particles.dart'; // Import your particles.dart file
import 'splash.dart'; // Import your splash.dart file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Artwork Discovery',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          color: Color(0xFF121212),
        ),
      ),
      home: SplashScreen(), // Use SplashScreen from splash.dart
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: ParticleWidget()), // Particle effect
          _buildShineEffect(), // Shine of light effect
          Column(
            // Ensures that the app bar and content are on top of the effects
            children: [
              _buildCustomAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SizedBox(
                          height:
                              20), // Adjust the space for the custom app bar if needed
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Explore Nearby Artworks',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height: 8),
                      ArtworkCarousel(),
                      SizedBox(height: 8),
                      CreateArtCard(),
                      LumaAIModelCard(),
                      PricingOptionCard(),
                      // Add more widgets here
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildCustomAppBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Center(
          // Center the title text
          child: const Text(
            'Augmented Reality Museum',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShineEffect() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-0.8, -0.8), // Position of the light source
            radius: 1.0, // Radius of the effect
            colors: [
              Colors.white.withOpacity(0.3), // Brightness of the shine
              Colors.transparent,
            ],
            stops: [0.0, 0.6], // Spread of the shine
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: BottomNavigationBar(
          backgroundColor: Colors.black.withOpacity(0.5),
          unselectedItemColor: Colors.white70,
          selectedItemColor: Colors.white,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
          ],
        ),
      ),
    );
  }
}

class CreateArtCard extends StatelessWidget {
  const CreateArtCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignupScreen()),
      ),
      child: frostedGlassCard(
        child: const ListTile(
          title: Text('Submit Your Own Art',
              style: TextStyle(color: Colors.white)),
          subtitle: Text('Tap here to get started!',
              style: TextStyle(color: Colors.white70)),
          leading: Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}

class LumaAIModelCard extends StatelessWidget {
  const LumaAIModelCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LumaAIModelScreen()),
      ),
      child: frostedGlassCard(
        child: const ListTile(
          title: Text('View AI 3D Map', style: TextStyle(color: Colors.white)),
          subtitle: Text('Find Artwork nearby!',
              style: TextStyle(color: Colors.white70)),
          leading: Icon(Icons.threed_rotation, color: Colors.white),
        ),
      ),
    );
  }
}

Widget frostedGlassCard({required Widget child}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.2),
                Colors.deepPurple.shade400.withOpacity(0.25),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.0,
            ),
          ),
          child: child,
        ),
      ),
    ),
  );
}

class ArtworkCarousel extends StatelessWidget {
  const ArtworkCarousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          CityArtworkCard(
            imagePath: 'images/golden_gate.jpeg',
            cityName: 'San Francisco',
            subtitle: 'Explore maps',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SanFranciscoScreen()),
              );
            },
          ),
          CityArtworkCard(
            imagePath: 'images/central_park.jpeg',
            cityName: 'New York',
            subtitle: 'Explore maps',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SanFranciscoScreen()),
              );
            },
          ),
          // ... other CityArtworkCards ...
        ],
      ),
    );
  }
}

class CityArtworkCard extends StatelessWidget {
  final String imagePath;
  final String cityName;
  final String subtitle;
  final VoidCallback onTap;

  const CityArtworkCard({
    Key? key,
    required this.imagePath,
    required this.cityName,
    required this.subtitle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cityName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PricingOptionCard extends StatelessWidget {
  const PricingOptionCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PricingScreen()),
      ),
      child: frostedGlassCard(
        child: const ListTile(
          title: Text('Explore Pricing Plans',
              style: TextStyle(color: Colors.white)),
          subtitle: Text('Find the best plan for your experience!',
              style: TextStyle(color: Colors.white70)),
          leading: Icon(Icons.monetization_on, color: Colors.white),
        ),
      ),
    );
  }
}
