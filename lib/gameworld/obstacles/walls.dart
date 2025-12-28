import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class LineObstacle extends PositionComponent {
  final double speed;
  bool isScored = false;
  final bool allowScoring;

  LineObstacle({
    required Vector2 position,
    required Vector2 size,
    required this.speed,
    this.allowScoring = true,
  }) {
    this.position = position;
    this.size = size;
  }

  @override
  void update(double dt) {
    position.x -= speed * dt;

    // remove when off screen
    if (position.x + size.x < 0) {
      removeFromParent();
    }
  }

  @override
void render(Canvas canvas) {
  // 1. Draw the "Grout" (the lines between bricks)
  final groutPaint = Paint()..color = const Color(0xFF424242); // Dark grey
  canvas.drawRect(size.toRect(), groutPaint);

  final brickPaint = Paint()..color = const Color(0xFFB71C1C); // Deep red
  
  double brickWidth = 20.0;
  double brickHeight = 10.0;
  double spacing = 2.0; // The gap between bricks

  // 2. Loop through the height and width of the component to draw bricks
  for (double y = 0; y < size.y; y += brickHeight + spacing) {
    // Offset every second row to create a brick pattern
    bool isEvenRow = (y / (brickHeight + spacing)).round() % 2 == 0;
    double xOffset = isEvenRow ? 0 : -(brickWidth / 2);

    for (double x = xOffset; x < size.x; x += brickWidth + spacing) {
      // Create a rectangle for a single brick
      // We use Rect.intersect to make sure bricks don't bleed outside the wall size
      final brickRect = Rect.fromLTWH(x, y, brickWidth, brickHeight);
      
      // Only draw if the brick is at least partially visible within the wall bounds
      if (brickRect.right > 0 && brickRect.left < size.x) {
        // Clamp the brick to the wall boundaries
        final clampedRect = brickRect.intersect(size.toRect());
        canvas.drawRect(clampedRect, brickPaint);
      }
     }
   }
 }
}