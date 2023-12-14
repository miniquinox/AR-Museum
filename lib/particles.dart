import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class Particle {
  Offset position;
  Offset velocity;
  double radius;
  Color color;

  Particle({
    required this.position,
    required this.velocity,
    required this.radius,
    required this.color,
  });

  void move(Size size) {
    // Move particle
    position += velocity;

    // Wrap around the screen
    if (position.dx > size.width) {
      position = Offset(0, position.dy);
    } else if (position.dx < 0) {
      position = Offset(size.width, position.dy);
    }
    if (position.dy > size.height) {
      position = Offset(position.dx, 0);
    } else if (position.dy < 0) {
      position = Offset(position.dx, size.height);
    }
  }
}

class ParticleWidget extends StatefulWidget {
  const ParticleWidget({Key? key}) : super(key: key);

  @override
  _ParticleWidgetState createState() => _ParticleWidgetState();
}

class _ParticleWidgetState extends State<ParticleWidget>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  List<Particle> particles = [];
  final int numberOfParticles = 100; // Set the number of particles

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 10), // Animation duration
      vsync: this,
    );

    animation = Tween<double>(begin: 0, end: 1).animate(controller)
      ..addListener(() {
        setState(() {
          for (var particle in particles) {
            particle.move(MediaQuery.of(context).size);
          }
        });
      });

    controller.repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initParticles();
  }

  void _initParticles() {
    var random = Random();
    Size size = MediaQuery.of(context).size;
    // Define a list of colors for the particles.
    List<Color> colors = [
      Colors.white,
      const Color.fromARGB(255, 97, 237, 255),
      const Color.fromARGB(255, 234, 112, 255)
    ];
    particles = List.generate(numberOfParticles, (index) {
      double brightness = random.nextDouble(); // Random brightness value
      Color color =
          colors[random.nextInt(colors.length)]; // Randomly pick a color
      return Particle(
        position: Offset(random.nextDouble() * size.width,
            random.nextDouble() * size.height),
        velocity: Offset(
          (random.nextDouble() * 0.5 - 0.1) * 2, // Random horizontal velocity
          (random.nextDouble() * 0.5 - 0.1) * 2, // Random vertical velocity
        ),
        radius: random.nextDouble() * 0.5 +
            0.5, // Smaller radius between 1.0 to 2.0
        color: color.withOpacity(
            brightness * 0.5 + 0.5), // Apply brightness to the color
      );
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ParticlePainter(particles, MediaQuery.of(context).size),
      child: Container(),
    );
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final Size size;

  ParticlePainter(this.particles, this.size);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      var paint = Paint()..color = particle.color;
      canvas.drawCircle(particle.position, particle.radius, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
