import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class Particle {
  Offset position;
  Offset velocity;
  static final Random _random = Random();

  Particle(this.position, this.velocity);

  // Create a Particle with a random position and velocity
  factory Particle.random() {
    return Particle(
      Offset(_random.nextDouble(), _random.nextDouble()),
      Offset((_random.nextDouble() - 0.5) * 0.004,
          (_random.nextDouble() - 0.5) * 0.004),
    );
  }

  // Update the particle's position
  void update() {
    position += velocity;
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

    // Draw the particles
    for (final particle in particles) {
      particle.update();
      canvas.drawCircle(
          particle.position.scale(size.width, size.height), 3.0, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) => true;
}
