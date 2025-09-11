import 'dart:math';

import 'package:dogfight/particles/explosion_particle.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';

class Explosion extends ParticleSystemComponent{

  Explosion(Vector2 position) : super(
    position: position.clone(),
    particle: Particle.generate(
      count: 20,
      generator: (p) => ExplosionParticle().translated(Vector2(Random().nextDouble()*40, 0)).rotated(Random().nextDouble()*2*pi),
    ),
  );
}