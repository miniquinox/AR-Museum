import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animated Pricing Cards',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.purple,
      ),
      home: const PricingScreen(),
    );
  }
}

class PricingScreen extends StatelessWidget {
  const PricingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pricing Plans'),
      ),
      body: ListView(
        children: <Widget>[
          PricingCard(
            planType: 'Basic',
            price: '\$5',
            features: ['5 Artworks', '1 AR Experience', 'Community Support'],
            particleCount: 5,
          ),
          PricingCard(
            planType: 'Premium',
            price: '\$7',
            features: ['20 Artworks', '5 AR Experiences', 'Priority Support'],
            particleCount: 10,
          ),
          PricingCard(
            planType: 'Unlimited',
            price: '\$10',
            features: ['Unlimited Artworks', 'Unlimited AR', '24/7 Support'],
            particleCount: 30,
          ),
        ],
      ),
    );
  }
}

class PricingCard extends StatefulWidget {
  final String planType;
  final String price;
  final List<String> features;
  final int particleCount;

  const PricingCard({
    Key? key,
    required this.planType,
    required this.price,
    required this.features,
    required this.particleCount,
  }) : super(key: key);

  @override
  _PricingCardState createState() => _PricingCardState();
}

class _PricingCardState extends State<PricingCard>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<Particle> _particles;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 10))
          ..repeat();
    _particles =
        List.generate(widget.particleCount, (index) => Particle.random());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: const [0.6, 0.9],
          colors: [
            Colors.black,
            widget.planType == 'Basic'
                ? Colors.purple
                : widget.planType == 'Premium'
                    ? Colors.deepPurple
                    : Colors.deepPurpleAccent,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              widget.planType,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              widget.price,
              style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w300,
                  color: Colors.white),
            ),
            const Divider(color: Colors.white54),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex:
                        3, // Adjust flex to give more space to the feature list if needed
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.features
                          .map((feature) => Text(feature,
                              style: const TextStyle(color: Colors.white)))
                          .toList(),
                    ),
                  ),
                  const VerticalDivider(
                      color: Colors.white54, thickness: 1, width: 20),
                  Expanded(
                    flex:
                        2, // Adjust flex to allocate space for the particle column
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (_, __) => CustomPaint(
                        size: const Size(100,
                            50), // Adjust size to control the space for particles
                        painter: ParticlePainter(_particles),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.planType == 'Basic'
                    ? Colors.purple
                    : widget.planType == 'Premium'
                        ? Colors.deepPurple
                        : Colors.deepPurpleAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text('Choose Plan',
                  style: TextStyle(color: Colors.white)),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}

class Particle {
  Offset position;
  Offset velocity;
  double angle;
  static final _random = Random();

  Particle(this.position, this.velocity, this.angle);

  // Create a Particle with initial random position and velocity
  factory Particle.random() {
    return Particle(
      Offset(_random.nextDouble(), _random.nextDouble()),
      Offset((_random.nextDouble() - 0.5) * 0.002,
          (_random.nextDouble() - 0.5) * 0.002),
      _random.nextDouble() * 2 * pi,
    );
  }

  // Update particle position with smooth sinusoidal motion
  void update() {
    angle += 0.01; // Adjust this value to change the speed of the motion
    position +=
        Offset(sin(angle) * 0.002, cos(angle) * 0.002); // Sinusoidal motion
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    for (final particle in particles) {
      particle.update();
      canvas.drawCircle(
          particle.position.scale(size.width, size.height), 2.0, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) => true;
}
