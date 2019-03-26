import 'dart:ui';

import 'package:flame/box2d/box2d_component.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/painting.dart';

import 'objects/disc.dart';
import 'levels/demo.dart';

class AirtableWorld extends Box2DComponent {
  DiscComponent disc;

  AirtableWorld() : super(scale: 100.0, gravity: 0.0);

  void initializeWorld() {
    // add(new GroundComponent(this));
    addAll(new DemoLevel(this).bodies);
    add(disc = new DiscComponent(this));
  }

  @override
  void update(t) {
    super.update(t);
    // cameraFollow(ninja, horizontal: 0.4, vertical: 0.4);
  }

  void handleTap(Offset position) {
    disc.stop();
  }

  Drag handleDrag(Offset position) {
    return disc.handleDrag(position);
  }
}
