import 'dart:ui';

import 'package:box2d_flame/box2d.dart';
import 'package:flame/box2d/box2d_component.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/painting.dart';

import '../utils.dart';
import '../levels/demo.dart';

class NinjaComponent extends BodyComponent {
  static const num NINJA_RADIUS = 8.0;

  ImagesLoader images = new ImagesLoader();

  bool idle;

  bool forward;

  bool jumping;

  NinjaComponent(box2d) : super(box2d) {
    _loadImages();
    _createBody();
  }

  void _loadImages() {
    for (int i = 0; i < 10; i++) {
      images.load("run-${i}", "ninja/run-00${i}.png");
      images.load("idle-${i}", "ninja/idle-00${i}.png");
      images.load("jump-${i}", "ninja/jump-00${i}.png");
      images.load("glide-${i}", "ninja/glide-00${i}.png");
    }
  }

  @override
  void update(double t) {
    this.idle =
        body.linearVelocity.x.abs() < 0.1 && body.linearVelocity.y.abs() < 0.1;
    if (this.idle) {
      stop();
    }
    this.forward = body.linearVelocity.x >= 0.0;
    this.jumping = body.getContactList() == null;
    this.jumping = true;
    var contact = body.getContactList();
    do {
      if (contact == null) {
        break;
      }
      print(contact.other.runtimeType.toString());
      // var other = contact.other as WallBody;
      // if (other.type == 'ground') {
      //   this.jumping = false;
      //   break;
      // }
      contact = contact.next;
    } while (true);
  }

  @override
  void renderCircle(Canvas canvas, Offset center, double radius) {
    if (images.isLoading) {
      return;
    }

    var image = this.jumping
        ? images.get("glide-0")
        : this.idle ? images.get("idle-0") : images.get("run-0");

    paintImage(
        canvas: canvas,
        image: image,
        rect: new Rect.fromCircle(center: center, radius: radius),
        flipHorizontally: !this.forward,
        fit: BoxFit.contain);
  }

  void _createBody() {
    final shape = new CircleShape();
    shape.radius = NinjaComponent.NINJA_RADIUS;
    shape.p.x = 0.0;

    final activeFixtureDef = new FixtureDef();
    activeFixtureDef.shape = shape;
    activeFixtureDef.restitution = 0.0;
    activeFixtureDef.density = 0.05;
    activeFixtureDef.friction = 0.2;
    FixtureDef fixtureDef = activeFixtureDef;
    final activeBodyDef = new BodyDef();
    activeBodyDef.linearVelocity = new Vector2(0.0, 0.0);
    activeBodyDef.position = new Vector2(0.0, 15.0);
    activeBodyDef.type = BodyType.DYNAMIC;
    activeBodyDef.bullet = true;
    BodyDef bodyDef = activeBodyDef;

    this.body = world.createBody(bodyDef)
      ..createFixtureFromFixtureDef(fixtureDef);
  }

  void input(Offset position) {
    Vector2 force =
        position.dx < 250 ? new Vector2(-1.0, 0.0) : new Vector2(1.0, 0.0);
    body.applyForce(force..scale(10000.0), center);
  }

  Drag handleDrag(Offset position) {
    return new HandleNinjaDrag(this);
  }

  void stop() {
    body.linearVelocity = new Vector2(0.0, 0.0);
    body.angularVelocity = 0.0;
  }
}

class HandleNinjaDrag extends Drag {
  NinjaComponent ninja;

  HandleNinjaDrag(this.ninja);

  @override
  void update(DragUpdateDetails details) {
    impulse(details.delta);
  }

  @override
  void end(DragEndDetails details) {
    impulse(details.velocity.pixelsPerSecond);
  }

  void impulse(Offset velocity) {
    Vector2 force = new Vector2(velocity.dx, -velocity.dy)..scale(100.0);
    ninja.body.applyLinearImpulse(force, ninja.center, true);
  }
}
