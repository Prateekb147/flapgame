import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'bird.dart';
import 'dart:math';
import 'package:minigame/gameworld/obstacles/walls.dart';
import 'package:flutter/material.dart';
import 'package:minigame/gameworld/cloud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FlopGame extends FlameGame with TapCallbacks {
  // Add this variable
  int score = 0;
  int highScore = 0;

  late Bird bird;
  bool gameOver = false;
  final Random random = Random();

  double timeSinceStart = 0;
  double baseSpeed = 200;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _loadHighScore();

    for (int i = 0; i < 5; i++) {
    add(Cloud(
      position: Vector2(random.nextDouble() * size.x, random.nextDouble() * 200),
      speed: 20 + random.nextDouble() * 20,
    ));
  }

    bird = Bird();
    add(bird);

    add(
      TimerComponent(
        period: 2,
        repeat : true,
        onTick: spawnLine,
      ),);
  }

  @override
  void update(double dt) {
  super.update(dt);
  if (gameOver) return;

  timeSinceStart += dt;

  for (final child in children) {
    if (child is LineObstacle) {
      if (bird.toRect().overlaps(child.toRect())) {
        endGame();
        break;
      }

      //Score Logic:
      //If the wall passes the bird's X position and hasn't been counted yet
      if (!child.isScored && bird.position.x > child.position.x + child.size.x) {
      score++;
      child.isScored = true;
      print('Score: $score');
       }
    }
  }
}

  void spawnLine() {
    if (gameOver) return;

  final double currentSpeed = baseSpeed + (timeSinceStart * 5);
    // 1. The "Gap" is the space the bird flies through.
    // We keep it consistent so it's never "too easy" or "impossible".
     const double gapHeight = 160.0; 
     const double minWallHeight = 50.0; // Walls will never be smaller than this

  // 2. Calculate the available area for the gap to appear
  // size.y is the total screen height
  final double availableRange = size.y - gapHeight - (minWallHeight * 2);
  
  // 3. Determine where the top wall ends
  final double topWallHeight = minWallHeight + random.nextDouble() * availableRange;

  // 4. Add TOP Wall
  add(
    LineObstacle(
      position: Vector2(size.x, 0),
      size: Vector2(40, topWallHeight),
      speed: currentSpeed,
      allowScoring: false,
    ),
  );

    // 5. Add BOTTOM Wall
    add(
      LineObstacle(
        position: Vector2(size.x, topWallHeight + gapHeight),
        size: Vector2(40, size.y - (topWallHeight + gapHeight)),
        speed: currentSpeed,
        allowScoring: true,
      )
    );

    add(
      LineObstacle(
        position: Vector2(size.x, topWallHeight + gapHeight),
        size: Vector2(40, size.y - (topWallHeight + gapHeight)),
        speed: currentSpeed,
      ),
    );
  }

  Future<void> _loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    highScore = prefs.getInt('highScore') ?? 0;
  }

  Future<void> _updateHighScore() async {
    if (score > highScore) {
      highScore = score;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('highScore', highScore);
    }
  }

  void endGame() async {
    gameOver = true;
    await _updateHighScore();  //Check and save high score before pausing
    pauseEngine();
    overlays.add('GameOverMenu');
  }

  void restart() {
    gameOver = false;
    score = 0;
    timeSinceStart = 0;
    overlays.remove('GameOverMenu');

    removeAll(children.where((c) => 
    c is Bird || c is LineObstacle || c is TimerComponent
  ).toList());

      bird = Bird();
      add(bird);

      add(
        TimerComponent(
          period: 2,
          repeat: true,
          onTick: spawnLine,
        )
      );

     resumeEngine();
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (gameOver) return;

    if (!bird.started) bird.start();
    bird.flap();
  }

  @override
  Color backgroundColor() => const Color(0x00000000);
}