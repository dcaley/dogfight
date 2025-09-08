import 'dart:math';

import 'package:dogfight/flyer.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';

import 'fighter.dart';
import 'missile_trail_particle.dart';

class Missile extends Flyer{

  Fighter launcher;

  Missile({
    required super.team,
    required super.speed,
    required super.position,
    required super.angle,
    required super.target,
    required this.launcher,
  }) : super(
    minSpeed: 0,
    maxSpeed: 20,
    acceleration: 0.2,
    spriteName: "missile.png",
    turnRate: pi/50,
    size: Vector2(10, 25),
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox(collisionType: CollisionType.passive));
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if(other==target){
      target!.kill();
      launcher.missile = null;
      removeFromParent();
    }
  }

  double time = 0;

  @override
  void update(double dt) {
    speed += acceleration;
    speed = min(speed, maxSpeed);

    time += dt;
    if(time>2){
      launcher.missile = null;
      game.world.remove(this);
    }

    super.update(dt);
  }

  @override
  Particle get trailParticle => MissileTrailParticle();
}