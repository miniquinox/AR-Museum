import 'package:flutter/material.dart';

class PricingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pricing Plans'),
        backgroundColor:
            const Color(0xFF121212), // Match with the main.dart theme
      ),
      body: Container(
        color: const Color(
            0xFF121212), // Match with the main.dart background color
        child: ListView(
          children: <Widget>[
            PerksCard(),
            Row(
              children: const <Widget>[
                Expanded(
                  child: PricingCard(
                    planType: 'Basic',
                    price: '\$5',
                    features: ['5 Artworks', '1 AR Experience', '1-day Access'],
                    backgroundColor: Colors.black, // Changed to a darker shade
                    buttonColor:
                        Colors.deepPurple, // Adjusted to a purple accent
                  ),
                ),
                Expanded(
                  child: PricingCard(
                    planType: 'Premium',
                    price: '\$7',
                    features: [
                      '10 Artworks',
                      '2 AR Experiences',
                      '3-day Access'
                    ],
                    backgroundColor: Colors.black, // Changed to a darker shade
                    buttonColor: Color.fromARGB(
                        255, 158, 58, 183), // Adjusted to a purple accent
                  ),
                ),
              ],
            ),
            // Third card
            const PricingCard(
              planType: 'Unlimited',
              price: '\$10',
              features: [
                'Unlimited Artworks',
                'Unlimited AR',
                '1-month Access'
              ],
              backgroundColor: Colors.black, // Changed to a darker shade
              buttonColor: Color.fromARGB(
                  255, 58, 141, 183), // Adjusted to a purple accent
            ),
          ],
        ),
      ),
    );
  }
}

class PerksCard extends StatelessWidget {
  const PerksCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.6, 0.9],
          colors: [
            Colors.orange,
            Colors.yellow,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.orangeAccent.withOpacity(0.5),
            offset: const Offset(0, 8),
            blurRadius: 20,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Explore Art Like Never Before',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const PerkItem(
              icon: Icons.map, // Replace with your own icon
              title: 'Interactive 3D Map',
              description: 'Navigate and discover art in iconic US locations.',
            ),
            const PerkItem(
              icon: Icons.search, // Replace with your own icon
              title: 'Scavenger Hunt',
              description:
                  'Engage in a thrilling hunt for augmented reality artworks.',
            ),
            const PerkItem(
              icon: Icons.art_track, // Replace with your own icon
              title: 'Exclusive Artwork',
              description:
                  'Access specially curated art selections with each package.',
            ),
            const PerkItem(
              icon: Icons.vrpano, // Replace with your own icon
              title: 'Immersive Experience',
              description:
                  'Experience art coming to life in augmented reality.',
            ),
          ],
        ),
      ),
    );
  }
}

class PerkItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const PerkItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PricingCard extends StatelessWidget {
  final String planType;
  final String price;
  final List<String> features;
  final Color backgroundColor;
  final Color buttonColor;

  const PricingCard({
    Key? key,
    required this.planType,
    required this.price,
    required this.features,
    required this.backgroundColor,
    required this.buttonColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.6, 0.9],
          colors: [
            Colors.black,
            buttonColor,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: buttonColor.withOpacity(0.5),
            offset: const Offset(0, 8),
            blurRadius: 20,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              planType,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              price,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w300,
                color: Colors.white,
              ),
            ),
            const Divider(color: Colors.white54),
            ...features.map(
              (feature) => Text(
                feature,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary:
                    buttonColor, // Deprecated, use backgroundColor instead.
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Choose Plan',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                // Handle plan selection
              },
            )
          ],
        ),
      ),
    );
  }
}
