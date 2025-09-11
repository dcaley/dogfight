import 'dart:math';

import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

class ExplosionParticle extends CircleParticle{

  ExplosionParticle() : super(
    paint: Paint()..color = Random().nextBool() ? Colors.yellow : Colors.red,
    lifespan: 1,
    radius: Random().nextDouble()*25,
  );

  @override
  void update(double dt) {
    super.update(dt);

    paint.color = paint.color.withAlpha((1-(255*progress)).toInt());
  }
}