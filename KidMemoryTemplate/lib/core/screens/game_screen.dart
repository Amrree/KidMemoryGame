import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flame/game.dart';
import '../managers/audio_manager.dart';
import '../managers/analytics_manager.dart';
import '../managers/save_manager.dart';
import '../models/game_module.dart';
import '../../game/memory_game.dart';
import 'celebration_screen.dart';

class GameScreen extends StatefulWidget {
  final GameModule module;

  const GameScreen({
    super.key,
    required this.module,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with TickerProviderStateMixin {
  late MemoryGame _game;
  late AnimationController _overlayController;
  late Animation<double> _overlayAnimation;
  
  bool _showPauseMenu = false;
  bool _showWinDialog = false;
  int _score = 0;
  int _moves = 0;
  int _matches = 0;
  DateTime? _gameStartTime;

  @override
  void initState() {
    super.initState();
    _setupGame();
    _setupAnimations();
    _startGameSession();
  }

  void _setupGame() {
    _game = MemoryGame(
      module: widget.module,
      onCardFlipped: _onCardFlipped,
      onMatch: _onMatch,
      onMismatch: _onMismatch,
      onGameWon: _onGameWon,
    );
  }

  void _setupAnimations() {
    _overlayController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _overlayAnimation = CurvedAnimation(
      parent: _overlayController,
      curve: Curves.easeInOut,
    );
  }

  void _startGameSession() {
    _gameStartTime = DateTime.now();
    final analyticsManager = context.read<AnalyticsManager>();
    analyticsManager.startSession(widget.module.id);
  }

  void _onCardFlipped() {
    final audioManager = context.read<AudioManager>();
    audioManager.playCardFlip();
    setState(() {
      _moves++;
    });
  }

  void _onMatch() {
    final audioManager = context.read<AudioManager>();
    final analyticsManager = context.read<AnalyticsManager>();
    
    audioManager.playMatch();
    analyticsManager.recordCorrectMatch();
    
    setState(() {
      _matches++;
      _score += 10;
    });
  }

  void _onMismatch() {
    final audioManager = context.read<AudioManager>();
    final analyticsManager = context.read<AnalyticsManager>();
    
    audioManager.playMismatch();
    analyticsManager.recordIncorrectMatch();
    
    setState(() {
      _score = (_score - 2).clamp(0, double.infinity).toInt();
    });
  }

  void _onGameWon() {
    final audioManager = context.read<AudioManager>();
    final analyticsManager = context.read<AnalyticsManager>();
    final saveManager = context.read<SaveManager>();
    
    audioManager.playWin();
    analyticsManager.endSession();
    saveManager.incrementGamesPlayed();
    saveManager.updateHighScore(_score);
    
    final timeTaken = _gameStartTime != null 
        ? DateTime.now().difference(_gameStartTime!).inSeconds
        : 0;
    
    // Show celebration screen instead of dialog
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => CelebrationScreen(
          moduleName: widget.module.name,
          score: _score,
          timeTaken: timeTaken,
          onContinue: () {
            Navigator.of(context).pop(); // Go back to module selector
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _overlayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Game view with background
          Stack(
            children: [
              // Background image with fade-in animation
              if (widget.module.backgroundPath.isNotEmpty)
                AnimatedOpacity(
                  opacity: 1.0,
                  duration: const Duration(milliseconds: 1000),
                  child: Positioned.fill(
                    child: Image.asset(
                      widget.module.backgroundPath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              // Game widget with scale animation
              AnimatedScale(
                scale: 1.0,
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutBack,
                child: GameWidget(game: _game),
              ),
            ],
          ),
          
          // UI overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back button
                    IconButton(
                      onPressed: _showPauseMenuDialog,
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    
                    // Score and stats
                    Column(
                      children: [
                        Text(
                          'Score: $_score',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Moves: $_moves',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Matches: $_matches',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    
                    // Pause button
                    IconButton(
                      onPressed: _showPauseMenuDialog,
                      icon: const Icon(
                        Icons.pause,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Pause menu overlay
          if (_showPauseMenu)
            FadeTransition(
              opacity: _overlayAnimation,
              child: Container(
                color: Colors.black.withOpacity(0.8),
                child: Center(
                  child: _buildPauseMenu(),
                ),
              ),
            ),
          
          // Win dialog
          if (_showWinDialog)
            FadeTransition(
              opacity: _overlayAnimation,
              child: Container(
                color: Colors.black.withOpacity(0.8),
                child: Center(
                  child: _buildWinDialog(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPauseMenu() {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Game Paused',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          _buildMenuButton(
            'Resume',
            Icons.play_arrow,
            () => _resumeGame(),
          ),
          const SizedBox(height: 12),
          
          _buildMenuButton(
            'Restart',
            Icons.refresh,
            () => _restartGame(),
          ),
          const SizedBox(height: 12),
          
          _buildMenuButton(
            'Main Menu',
            Icons.home,
            () => _goToMainMenu(),
          ),
        ],
      ),
    );
  }

  Widget _buildWinDialog() {
    return Container(
      width: 350,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.celebration,
            size: 64,
            color: Color(0xFF4CAF50),
          ),
          const SizedBox(height: 16),
          
          const Text(
            'Congratulations!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4CAF50),
            ),
          ),
          const SizedBox(height: 8),
          
          Text(
            'You completed ${widget.module.name}!',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          
          // Stats
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildStatRow('Final Score', '$_score'),
                _buildStatRow('Total Moves', '$_moves'),
                _buildStatRow('Matches Found', '$_matches'),
                _buildStatRow('Accuracy', '${(_matches / _moves * 100).toStringAsFixed(1)}%'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          Row(
            children: [
              Expanded(
                child: _buildMenuButton(
                  'Play Again',
                  Icons.refresh,
                  () => _restartGame(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMenuButton(
                  'Main Menu',
                  Icons.home,
                  () => _goToMainMenu(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4CAF50),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(String text, IconData icon, VoidCallback onTap) {
    return Consumer<AudioManager>(
      builder: (context, audioManager, child) {
        return ElevatedButton(
          onPressed: () {
            audioManager.playButtonClick();
            onTap();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4CAF50),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: 8),
              Text(text),
            ],
          ),
        );
      },
    );
  }

  void _showPauseMenuDialog() {
    setState(() {
      _showPauseMenu = true;
    });
    _overlayController.forward();
  }

  void _resumeGame() {
    setState(() {
      _showPauseMenu = false;
    });
    _overlayController.reverse();
  }

  void _restartGame() {
    setState(() {
      _showPauseMenu = false;
      _showWinDialog = false;
      _score = 0;
      _moves = 0;
      _matches = 0;
    });
    _overlayController.reset();
    _game.restart();
  }

  void _goToMainMenu() {
    Navigator.of(context).pop();
  }
}