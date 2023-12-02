import 'dart:ui';
import 'package:flutter/material.dart';
import 'SF.dart'; // Ensure this matches the file name of your San Francisco screen
import 'Signup.dart'; // Ensure this matches the file name of your Signup screen
import 'LumaAIModelScreen.dart'; // Ensure this matches the file name of your Luma AI screen
// import 'package:my_flutter_project/login_screen.dart';

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
          color: Colors.deepPurple,
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover vibrant art and landmarks'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Padding(
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
            const SizedBox(height: 8),
            const ArtworkCarousel(),
            const SizedBox(height: 8),
            CreateArtCard(), // New card for signup screen
            // const SizedBox(height: 8),
            LumaAIModelCard(), // New card for Luma AI model screen
            // const SizedBox(height: 8),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
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
        child: ListTile(
          title: const Text('Create Your Own Art',
              style: TextStyle(color: Colors.white)),
          subtitle: const Text('Tap here to get started!',
              style: TextStyle(color: Colors.white70)),
          leading: const Icon(Icons.add, color: Colors.white),
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
        child: ListTile(
          title: const Text('View AI 3D Map',
              style: TextStyle(color: Colors.white)),
          subtitle: const Text('Find Artwork nearby!',
              style: TextStyle(color: Colors.white70)),
          leading: const Icon(Icons.threed_rotation, color: Colors.white),
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
