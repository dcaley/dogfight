import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';

import 'fighter.dart';

class Dogfight extends FlameGame with HasCollisionDetection{

  final teamSize = 10;
  final fighters = <Fighter>[];
  late Parallax parallax;
  late Fighter follow;

  @override
  Future<void> onLoad() async {

    populateTeam(0, "blueships1.png");
    populateTeam(1, "redfighter0006.png");

    parallax = await loadParallax(
      [ParallaxImageData('stars_0.png'), ParallaxImageData('stars_1.png'), ParallaxImageData('stars_2.png')],
      repeat: ImageRepeat.repeat,
      velocityMultiplierDelta: Vector2(3, 3),
    );
    add(ParallaxComponent(parallax: parallax));

    world.addAll(fighters);

    follow = fighters.first;
    camera.follow(follow);
  }

  followNew(){
    follow = fighters.where((f) => f.alive).toList().random();
    camera.follow(follow, snap: false, maxSpeed: 1000);
  }

  populateTeam(int team, String sprite){
    for (int i=0; i<teamSize; i++) {
      fighters.add(Fighter(team: team, spriteName: sprite));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    parallax.baseVelocity.setFrom(follow.velocity);

    // when the death animation is almost done, pan to and follow a different fighter
    if(!follow.alive && follow.deathTimer>follow.maxDeathTimer*0.75){
      followNew();
    }
  }
}