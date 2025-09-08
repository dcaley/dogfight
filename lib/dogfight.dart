import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';

import 'fighter.dart';

class Dogfight extends FlameGame with HasCollisionDetection{

  final teamSize = 10;
  List<Fighter> fighters = [];
  late Parallax parallax;

  @override
  Future<void> onLoad() async {

    for (int i = 0; i < teamSize*2; i++) {
      final team = i%2;
      fighters.add(Fighter(team: team));
    }

    parallax = await loadParallax(
      [
        ParallaxImageData('stars_0.png'),
        ParallaxImageData('stars_1.png'),
        ParallaxImageData('stars_2.png'),
      ],
      repeat: ImageRepeat.repeat,
      velocityMultiplierDelta: Vector2(3, 3),
    );
    add(ParallaxComponent(parallax: parallax));

    world.addAll(fighters);

    camera.follow(fighters.first);
  }

  @override
  void update(double dt) {
    super.update(dt);
    parallax.baseVelocity.setFrom(fighters.first.velocity);
  }
}

class Reticle extends PositionComponent with HasGameReference<Dogfight>{

  double range;

  Reticle(this.range);

  final paint = Paint()
    ..color = Colors.white
    ..strokeWidth = 3
    ..style = PaintingStyle.stroke;

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(Offset(0, -range), 20, paint);
  }
}