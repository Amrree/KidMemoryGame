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
    analyticsManager.recordMatch('card1', 'card2', true);
    
    setState(() {
      _matches++;
      _score += 10; // Award points for match
    });
  }

  void _onMismatch() {
    final audioManager = context.read<AudioManager>();
    final analyticsManager = context.read<AnalyticsManager>();
    
    audioManager.playMismatch();
    analyticsManager.recordMatch('card1', 'card2', false);
    
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
    saveManager.updateModuleHighScore(widget.module.id, _score);
    
    final timeTaken = _gameStartTime != null 
        ? DateTime.now().difference(_gameStartTime!).inSeconds
        : 0;
    
    // Save game session
    final session = GameSession(
      moduleId: widget.module.id,
      startTime: _gameStartTime!,
      endTime: DateTime.now(),
      score: _score,
      moves: _moves,
      correctMatches: _matches,
      incorrectMatches: _moves - _matches,
      completed: true,
    );
    saveManager.saveGameSession(session);
    
    // Show celebration screen
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
                      onPressed: () {
                        final audioManager = context.read<AudioManager>();
                        audioManager.playButtonClick();
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    
                    // Score and stats
                    Row(
                      children: [
                        _buildStatChip(
                          Icons.star,
                          '$_score',
                          const Color(0xFFFFD700),
                        ),
                        const SizedBox(width: 8),
                        _buildStatChip(
                          Icons.touch_app,
                          '$_moves',
                          const Color(0xFF4CAF50),
                        ),
                        const SizedBox(width: 8),
                        _buildStatChip(
                          Icons.check_circle,
                          '$_matches',
                          const Color(0xFF2196F3),
                        ),
                      ],
                    ),
                    
                    // Pause button
                    IconButton(
                      onPressed: () {
                        final audioManager = context.read<AudioManager>();
                        audioManager.playButtonClick();
                        setState(() {
                          _showPauseMenu = true;
                        });
                        _overlayController.forward();
                      },
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
            AnimatedBuilder(
              animation: _overlayAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _overlayAnimation.value,
                  child: Container(
                    color: Colors.black.withOpacity(0.8),
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.all(32),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
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
                            const Text(
                              'Game Paused',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            // Current stats
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F8E9),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      _buildPauseStat('Score', '$_score'),
                                      _buildPauseStat('Moves', '$_moves'),
                                      _buildPauseStat('Matches', '$_matches'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            // Action buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    final audioManager = context.read<AudioManager>();
                                    audioManager.playButtonClick();
                                    setState(() {
                                      _showPauseMenu = false;
                                    });
                                    _overlayController.reverse();
                                  },
                                  icon: const Icon(Icons.play_arrow),
                                  label: const Text('Resume'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4CAF50),
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    final audioManager = context.read<AudioManager>();
                                    audioManager.playButtonClick();
                                    Navigator.of(context).pop();
                                  },
                                  icon: const Icon(Icons.home),
                                  label: const Text('Home'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2196F3),
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPauseStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D32),
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF424242),
          ),
        ),
      ],
    );
  }
}