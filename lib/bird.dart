import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Bird extends PositionComponent {
  bool started = false;
  double velocityY = 0;
  final double gravity = 800;
  final double jumpForce = -300;

  double animationTime = 0;
  bool wingsUp = false;

  //YoungYelllowBird
  //Bird() : super(size:Vector2(40, 30),
      //position: Vector2(100, 300));

  //GreyEagleBird
  Bird() : super(size:Vector2(60, 40),
      position: Vector2(100, 300));

  void start() => started = true;
  void flap() { if (started) velocityY = jumpForce; }

  @override
  void update(double dt) {
    super.update(dt);
    if (!started) return;

    velocityY += gravity * dt;
    position.y += velocityY * dt;

    // Toggle wings every 0.15 seconds
    animationTime += dt;
    if (animationTime > 0.12) {
      wingsUp = !wingsUp;
      animationTime = 0;
    }
    
    // Keep bird on screen
    if (position.y < 0) position.y = 0;
  }

  @override
  //YoungYellowBird
  //void render(Canvas canvas) {
    //final bodyPaint = Paint()..color = Colors.yellow;
    //final eyePaint = Paint()..color = Colors.white;
    //final pupilPaint = Paint()..color = Colors.black;
    //final beakPaint = Paint()..color = Colors.orange;
    //final wingPaint = Paint()..color = Colors.yellow.shade700;


    //EagleBird
    void render(Canvas canvas) {
    final bodyPaint = Paint()..color = const Color(0xFF2B1B17); // Dark Brown
    final headPaint = Paint()..color = Colors.white;
    final beakPaint = Paint()..color = const Color(0xFFFFD700); // Gold
    final wingPaint = Paint()..color = const Color(0xFF1A100E); // Near Black
    final eyePaint = Paint()..color = Colors.black;

    //YoungYellowBirdBody
    // 1. Draw Body (Main Block)
    //canvas.drawRect(Rect.fromLTWH(5, 5, 25, 20), bodyPaint);

    // 2. Draw Eye
    //canvas.drawRect(Rect.fromLTWH(22, 8, 8, 8), eyePaint);
    //canvas.drawRect(Rect.fromLTWH(26, 10, 4, 4), pupilPaint);

    // 3. Draw Beak
    //canvas.drawRect(Rect.fromLTWH(30, 15, 10, 8), beakPaint);

    // 4. Draw Flapping Wing
    // The Y position of the wing changes based on 'wingsUp'
    //double wingY = wingsUp ? 8 : 15;
    //canvas.drawRect(Rect.fromLTWH(2, wingY, 15, 10), wingPaint);

    //EagleBirdBody
    // 1. POINTY TAIL (Stair-stepped for a sharp look)
     canvas.drawRect(Rect.fromLTWH(4, 18, 8, 4), headPaint); // White tail tip
     canvas.drawRect(Rect.fromLTWH(0, 20, 6, 2), headPaint); 

    // 2. SLEEK BODY
     canvas.drawRect(Rect.fromLTWH(10, 14, 30, 14), bodyPaint);
     canvas.drawRect(Rect.fromLTWH(15, 28, 20, 4), bodyPaint); // Underbelly

     // 3. HIGH ALIGN HEAD (Avoids the "hunched" vulture look)
     canvas.drawRect(Rect.fromLTWH(35, 4, 16, 14), headPaint); 
     canvas.drawRect(Rect.fromLTWH(48, 6, 2, 2), eyePaint); // Single pixel eye

     // 4. POINTY HOOKED BEAK (Using 3 small rects to "fake" a triangle)
     canvas.drawRect(Rect.fromLTWH(51, 8, 8, 4), beakPaint);  // Bridge
     canvas.drawRect(Rect.fromLTWH(55, 12, 4, 4), beakPaint); // Middle
     canvas.drawRect(Rect.fromLTWH(57, 16, 2, 2), beakPaint); // The "Point"

     // 5. MINIMALIST POINTY WINGS
     if (wingsUp) {
    // Wing angled back
       canvas.drawRect(Rect.fromLTWH(20, 2, 6, 12), wingPaint);
       canvas.drawRect(Rect.fromLTWH(16, -2, 4, 10), wingPaint);
       canvas.drawRect(Rect.fromLTWH(12, -6, 4, 8), wingPaint); // Pointy tip
    } else {
    // Wing angled down
       canvas.drawRect(Rect.fromLTWH(20, 16, 8, 14), wingPaint);
       canvas.drawRect(Rect.fromLTWH(16, 22, 4, 12), wingPaint);
       canvas.drawRect(Rect.fromLTWH(12, 28, 4, 10), wingPaint); // Pointy tip
   }
  }
}