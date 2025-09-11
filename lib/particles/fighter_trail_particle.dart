import 'dart:math';

import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

class FighterTrailParticle extends CircleParticle{

  bool alive;

  FighterTrailParticle({this.alive = true}) : super(
    paint: Paint()..color = alive ? (Colors.grey[Random().nextBool() ? 500 : 600]!) : (Random().nextBool() ? Colors.red : Colors.orange),
    lifespan: 1,
    radius: 8,
  );

  @override
  void update(double dt) {
    super.update(dt);
    paint.color = paint.color.withAlpha((1-(255*progress)).toInt());
  }
}