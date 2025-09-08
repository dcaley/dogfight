import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';

import 'dogfight.dart';
import 'fighter.dart';

abstract class Flyer extends SpriteComponent with HasGameReference<Dogfight>, CollisionCallbacks{

  double speed;
  Fighter? target;
  final int team;
  final double maxSpeed;
  final double minSpeed;
  final double acceleration;
  final double turnRate;
  final String spriteName;

  Flyer({
    super.position,
    super.angle,
    required this.team,
    required this.maxSpeed,
    required this.minSpeed,
    required this.speed,
    required this.acceleration,
    required this.turnRate,
    required this.spriteName,
    required super.size,
    this.target,
  }) : super(anchor: Anchor.center, priority: 1);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await game.loadSprite(spriteName);
  }

  @override
  void update(double dt) {

    if(target!=null) {
      final angleToTarget = angleTo(target!.position);
      if(angleToTarget>0){
        angle += min(turnRate, angleToTarget);
      }
      else if(angleToTarget<0){
        angle -= min(turnRate, -angleToTarget);
      }
    }

    game.world.add(
      ParticleSystemComponent(
        position: position.clone(),
        particle: trailParticle,
        priority: 0,
      ),
    );

    position += velocity;
  }

  Vector2 get velocity => Vector2(speed*sin(angle), -speed*cos(angle));

  Particle get trailParticle;
}