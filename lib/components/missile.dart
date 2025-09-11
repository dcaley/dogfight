import 'dart:math';

import 'package:dogfight/components/explosion.dart';
import 'package:dogfight/particles/missile_trail_particle.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';

import 'fighter.dart';
import 'flyer.dart';

class Missile extends Flyer{

  final Fighter launcher;
  double flightTime = 0.0;
  final maxFlightTime = 3.0;

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

    // can only kill the fighter we are targeting
    if(other==target){
      target!.kill();
      launcher.missile = null;
      removeFromParent();
      game.world.add(Explosion(position));
    }
  }
  
  @override
  void update(double dt) {
    speed += acceleration;
    speed = min(speed, maxSpeed);

    flightTime += dt;
    // despawn if we exceed our ttl
    if(flightTime>maxFlightTime){
      launcher.missile = null;
      game.world.remove(this);
    }

    super.update(dt);
  }

  @override
  Particle get trailParticle => MissileTrailParticle();
}