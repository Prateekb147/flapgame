import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Cloud extends PositionComponent with HasGameRef {
  final double speed;

  Cloud({required Vector2 position, required this.speed}) 
      : super(position: position, size: Vector2(100, 40));

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.white.withOpacity(0.6);
    // Draw a "minimalist" cloud using three overlapping rectangles
    canvas.drawRect(Rect.fromLTWH(20, 10, 60, 20), paint);
    canvas.drawRect(Rect.fromLTWH(40, 0, 30, 15), paint);
    canvas.drawRect(Rect.fromLTWH(10, 15, 40, 15), paint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= speed * dt;

    // If the cloud goes off screen, wrap it back to the other side
    if (position.x + size.x < 0) {
      position.x = gameRef.size.x;
    }
  }
}