import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:airtable/airtable-world.dart';

class AirtableGame extends Game {
  final NinjaWorld world = new NinjaWorld();

  AirtableGame() {
    Flame.util.addGestureRecognizer(createDragRecognizer());
    Flame.util.addGestureRecognizer(createTapRecognizer());
    world.initializeWorld();
  }

  @override
  void render(Canvas canvas) {
    world.render(canvas);
  }

  @override
  void update(double t) {
    world.update(t);
  }

  @override
  void resize(Size size) {
    world.resize(size);
  }

  GestureRecognizer createDragRecognizer() {
    return new ImmediateMultiDragGestureRecognizer()
      ..onStart = (Offset position) => world.handleDrag(position);
  }

  TapGestureRecognizer createTapRecognizer() {
    return new TapGestureRecognizer()
      ..onTapUp = (TapUpDetails details) {
        world.handleTap(details.globalPosition);
      };
  }
}
