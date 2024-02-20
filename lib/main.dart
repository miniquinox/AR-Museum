import 'dart:ui';
import 'package:flutter/material.dart';
import 'dataManager.dart'; // Ensure this file is updated as previously described.
import 'particles.dart'; // Assuming this is a custom widget you've defined.
import 'city.dart'; // Ensure this file is updated as previously described.
import 'LumaAIModelScreen.dart';
import 'package:davis_project/auth/auth_guard.dart';
import 'package:davis_project/auth/auth_service.dart';
import 'package:davis_project/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Signup.dart';
import 'package:provider/provider.dart';
import 'timer_service.dart';
import 'pricing.dart';

final timerService = TimerService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  AuthService.instance;
  runApp(
    ChangeNotifierProvider(
      create: (context) => TimerService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      home: const AuthGaurdPage(), // Use SplashScreen from splash.dart
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    _buildShineEffect(); // Shine of light effect
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: ParticleWidget()), // Particle effect
          Column(
            children: [
              _buildCustomAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      _buildExhibitionsCarousel(),
                      const SizedBox(height: 16), // Space between sections
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Public City-Sponsored Exhibitions',
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
                      // const SizedBox(height: 8),
                      const LumaAIModelCard(),
                      // const SizedBox(height: 8),
                      const CreateArtCard(),
                      const PricingOptionCard(),
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
            // Add more items if needed
          ],
        ),
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return const SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Center(
          child: Text(
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

  Widget _buildExhibitionsCarousel() {
    // Placeholder for exhibitions data
    List<Exhibition> exhibitions = [
      Exhibition(
        imagePath: 'images/starry_night.png',
        title: "It's Pablo-matic",
        dateRange: 'Jan 1st - Feb 28th',
        description: 'Picasso According to Hannah Gadsby',
        category: 'Painting',
        buttonColor: Colors.blue // Specify the color here
        ,
      ),
      Exhibition(
        imagePath: 'images/monalisa.png',
        title: "Terminator Monalisa",
        dateRange: 'Mar 1st - Apr 30th',
        description: 'Monalisa According to Arnold Schwarzenegger',
        category: 'Sculpture',
        buttonColor: Colors.orange // Specify the color here
        ,
      ),
      Exhibition(
        imagePath: 'images/transformer.png',
        title: "Real Sized Transformer",
        dateRange: 'May 2nd - May 28th',
        description: 'Optimus Prime in the flesh',
        category: 'Gallery',
        buttonColor: Colors.purple // Specify the color here
        ,
      ),
      // Add more exhibitions here
    ];

    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: exhibitions.length,
        itemBuilder: (context, index) {
          return ExhibitionCard(exhibition: exhibitions[index]);
        },
      ),
    );
  }

  Widget _buildShineEffect() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(-0.8, -0.8),
            radius: 1.0,
            colors: [
              Colors.white.withOpacity(0.3),
              Colors.transparent,
            ],
            stops: const [0.0, 0.6],
          ),
        ),
      ),
    );
  }
}

class LumaAIModelCard extends StatelessWidget {
  const LumaAIModelCard({super.key});

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

class PricingOptionCard extends StatelessWidget {
  const PricingOptionCard({super.key});

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

class CreateArtCard extends StatelessWidget {
  const CreateArtCard({super.key});

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

class ExhibitionCard extends StatelessWidget {
  final Exhibition exhibition;

  const ExhibitionCard({
    super.key,
    required this.exhibition,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 11.0),
            child: Stack(
              alignment: Alignment.topLeft,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Image.asset(
                    exhibition.imagePath,
                    width: 110,
                    height: 110,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 5,
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.center,
                    child: _categoryButton(
                        exhibition.category, exhibition.buttonColor),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    exhibition.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    exhibition.description,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    exhibition.dateRange,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryButton(String category, Color color) {
    // Accept the color as a parameter
    return Container(
      decoration: BoxDecoration(
        color: color, // Use the color for the button background
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Text(
        category.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

class Exhibition {
  final String imagePath;
  final String title;
  final String dateRange;
  final String description;
  final String category;
  final Color buttonColor;

  Exhibition({
    required this.imagePath,
    required this.title,
    required this.dateRange,
    required this.description,
    required this.category,
    required this.buttonColor,
  });
}

class ArtworkCarousel extends StatelessWidget {
  const ArtworkCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Artwork>>(
      future: loadArtworks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final List<Artwork> artworks = snapshot.data!;
          return SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: artworks.length,
              itemBuilder: (context, index) {
                final artwork = artworks[index];
                return ArtworkCard(
                  artwork: artwork,
                );
              },
            ),
          );
        } else {
          return const Center(child: Text('No artworks found'));
        }
      },
    );
  }
}

class ArtworkCard extends StatelessWidget {
  final Artwork artwork;

  const ArtworkCard({
    super.key,
    required this.artwork,
  });

  @override
  Widget build(BuildContext context) {
    // Verify if the URL is valid
    final Uri artworkUri = Uri.tryParse(artwork.frontImageUrl) ?? Uri();
    final bool isValidUrl = artworkUri.isAbsolute &&
        (artworkUri.scheme == 'http' || artworkUri.scheme == 'https');

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArtworkDetailScreen(artwork: artwork),
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: 150, // Set a fixed height for the image
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                image: isValidUrl
                    ? DecorationImage(
                        image: NetworkImage(artwork.frontImageUrl),
                        fit: BoxFit
                            .cover, // Ensure the image covers the area without stretching
                      )
                    : null,
              ),
              child: isValidUrl
                  ? null
                  : const Placeholder(), // Show a placeholder if URL is not valid
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
                    artwork.artName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'Explore ${artwork.artName}',
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
