import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:minigame/flop_game.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MainGamePage(),
  ));
}

class MainGamePage extends StatefulWidget {
  const MainGamePage({super.key});

  @override
  State<MainGamePage> createState() => _MainGamePageState();
}

class _MainGamePageState extends State<MainGamePage> {
  // Creating the game instance here ensures it lives as long as the app is open
  late final FlopGame _game;

  @override
  void initState() {
    super.initState();
    _game = FlopGame();
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold provides the "Material" look and removes the yellow underlines
    return Scaffold(
      body: Stack(
        children: [
          // Background Sky
          Container(color: const Color(0xFF87CEEB)),

          // The Game
          GameWidget<FlopGame>(
            game: _game,
            overlayBuilderMap: {
              'GameOverMenu': (context, game) => _buildGameOver(game),
            },
          ),

          // THE SCORE (Positioned on top of the game)
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: StreamBuilder(
              // This rebuilds this small Text widget every 100ms
              stream: Stream.periodic(const Duration(milliseconds: 100)),
              builder: (context, snapshot) {
                return Material( // Added Material here as a safety for underlines
                  color: Colors.transparent,
                  child: Text(
                    '${_game.score}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameOver(FlopGame game) {
    return Center(
      child: Material( // Material prevents underlines in the overlay
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white24, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('GAME OVER', style: TextStyle(color: Colors.white, fontSize: 32)),
              Text('Score: ${game.score}', style: const TextStyle(color: Colors.yellow, fontSize: 24)),
              const SizedBox(height: 10),
              // Display High Score
              Text('High Score: ${game.highScore}', style: const TextStyle(color: Colors.orange, fontSize: 20)),

              //High Score Display Ends Here
              Text(
              'Best: ${game.highScore}',
              style: const TextStyle(fontSize: 22, color: Colors.yellowAccent)),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                onPressed: () => game.restart(), child: const Text('Restart')),
            ],
          ),
        ),
      ),
    );
  }
}