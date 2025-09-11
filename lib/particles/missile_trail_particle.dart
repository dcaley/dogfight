import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

class MissileTrailParticle extends CircleParticle{

  MissileTrailParticle() : super(paint: Paint()..color = Colors.orange, lifespan: 1, radius: 5);

  @override
  void update(double dt) {
    super.update(dt);

    paint.color = paint.color.withAlpha((1-(255*progress)).toInt());
  }
}