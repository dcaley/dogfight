import 'dart:math';

import 'package:dogfight/fighter_trail_particle.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

import 'flyer.dart';
import 'missile.dart';

class Fighter extends Flyer{

  double range = 300;
  Missile? missile;
  bool alive = true;
  double deathTimer = 0;

  Fighter({required super.team}) : super(
    maxSpeed: 10,
    minSpeed: 1,
    speed: 10,
    acceleration: 0.1,
    spriteName: team==1 ? "blueships1.png" : "redfighter0006.png",
    turnRate: pi/100,
    size: Vector2(50, 50),
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
    reset();
  }

  @override
  void update(double dt) {

    if(alive) {
      target ??= pickTarget();

      if (locked && missile == null) {
        missile = Missile(team: team,
            position: position.clone(),
            speed: speed,
            angle: angle,
            launcher: this,
            target: target);
        game.world.add(missile!);
      }

      if (target != null) {
        if (distance(target!) > range) {
          speed += acceleration;
          speed = min(speed, maxSpeed);
        }
        else {
          speed -= acceleration;
          speed = max(speed, minSpeed);
        }
      }
    }
    else{
      deathTimer += dt;
      if(deathTimer>2){
        reset();
      }
    }
    
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if(this==game.fighters.first.target){
      canvas.save();
      canvas.translate(width/2, height/2);
      canvas.rotate(-angle);
      final p = Paint()
        ..color = Colors.green
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke;

      for(int i=0; i<4; i++) {
        canvas.save();
        canvas.rotate(i*pi/2);
        canvas.translate(-width/2, -height/2);
        canvas.drawLine(Offset(0, 0), Offset(0, 10), p);
        canvas.drawLine(Offset(0, 0), Offset(10, 0), p);
        canvas.restore();
      }

      canvas.restore();
    }
    else if(this==game.fighters.first) {
      canvas.drawCircle(Offset(width/2, height/2 - range), 20, Paint()
        ..color = locked ? Colors.red : Colors.white
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke);
    }
  }

  kill(){
    deathTimer = 0;
    alive = false;
    target = null;
    // any fighters targeting us need to pick a new target
    game.fighters.where((f) => f.target == this).forEach((f) => f.target = null);
  }

  // pick a random, live target
  Fighter pickTarget(){
    final otherTeam = game.fighters.where((p) => p.alive && p.team!=team).toList();
    return otherTeam[Random().nextInt(otherTeam.length)];
  }

  // is our target in the reticle?
  bool get locked{

    if(target==null){
      return false;
    }

    // would it be better to do this with with collision detection?
    return Circle(Vector2(absolutePosition.x+range*sin(angle), absolutePosition.y-range*cos(angle)), 20)
        .containsPoint(target!.absolutePosition);
  }

  // put us at a random angle 2000px from the origin
  reset(){
    alive = true;
    angle = Random().nextDouble()*2*pi;
    x = 2000*sin(angle);
    y = 2000*cos(angle);
  }

  @override
  Particle get trailParticle => FighterTrailParticle(alive: alive);
}