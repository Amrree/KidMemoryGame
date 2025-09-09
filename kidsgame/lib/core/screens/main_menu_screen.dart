import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../managers/audio_manager.dart';
import '../managers/save_manager.dart';
import '../managers/analytics_manager.dart';
import 'module_selector_screen.dart';
import 'settings_screen.dart';
import 'parental_gate_screen.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _buttonController;
  late Animation<double> _logoAnimation;
  late Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _playBackgroundMusic();
  }

  void _setupAnimations() {
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );
    
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _logoAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    );

    _buttonAnimation = CurvedAnimation(
      parent: _buttonController,
      curve: Curves.bounceOut,
    );

    // Super fun staggered animation sequence
    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        _buttonController.forward();
      }
    });
    
    // Add continuous bouncy animation for logo
    _logoController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 2000), () {
          if (mounted) {
            _logoController.repeat(reverse: true);
          }
        });
      }
    });
  }

  void _playBackgroundMusic() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final audioManager = context.read<AudioManager>();
      audioManager.playMainMenuMusic();
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4CAF50),
              Color(0xFF2E7D32),
              Color(0xFF1B5E20),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Header with logo and title
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ScaleTransition(
                        scale: _logoAnimation,
                        child: Transform.rotate(
                          angle: _logoAnimation.value * 0.1, // Gentle rotation
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFFFFD700),
                                  Color(0xFFFFA500),
                                  Color(0xFFFF6B35),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFFD700).withOpacity(0.6),
                                  blurRadius: 30,
                                  offset: const Offset(0, 15),
                                  spreadRadius: 8,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/common/app_icon.png',
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.psychology,
                                      size: 60,
                                      color: Colors.white,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      FadeTransition(
                        opacity: _logoAnimation,
                        child: Transform.scale(
                          scale: 1.0 + (_logoAnimation.value * 0.1), // Bouncy scale
                          child: ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [
                                Color(0xFFFFD700),
                                Color(0xFFFF6B35),
                                Color(0xFFE91E63),
                              ],
                            ).createShader(bounds),
                            child: const Text(
                              'Kids Game',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 2.0,
                                shadows: [
                                  Shadow(
                                    color: Colors.black,
                                    offset: Offset(3, 3),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      FadeTransition(
                        opacity: _logoAnimation,
                        child: const Text(
                          'Educational Memory Games',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.0,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                offset: Offset(1, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Menu buttons
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildMenuButton(
                        'Play Game',
                        Icons.play_arrow,
                        _navigateToModuleSelector,
                      ),
                      const SizedBox(height: 16),
                      _buildMenuButton(
                        'Settings',
                        Icons.settings,
                        _navigateToSettings,
                      ),
                      const SizedBox(height: 16),
                      _buildMenuButton(
                        'Parental Controls',
                        Icons.security,
                        _navigateToParentalGate,
                      ),
                    ],
                  ),
                ),
                
                // Footer with stats
                Expanded(
                  flex: 1,
                  child: Consumer<SaveManager>(
                    builder: (context, saveManager, child) {
                      return FadeTransition(
                        opacity: _buttonAnimation,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem(
                                'Games Played',
                                '${saveManager.totalGamesPlayed}',
                                Icons.games,
                              ),
                              _buildStatItem(
                                'High Score',
                                '${saveManager.highScore}',
                                Icons.star,
                              ),
                              _buildStatItem(
                                'Modules',
                                '${saveManager.unlockedModules.length}',
                                Icons.extension,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuButton(String text, IconData icon, VoidCallback onTap) {
    return Consumer<AudioManager>(
      builder: (context, audioManager, child) {
        return AnimatedBuilder(
          animation: _buttonAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _buttonAnimation.value,
              child: Container(
                width: double.infinity,
                height: 70,
                margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: ElevatedButton(
                    onPressed: () {
                      audioManager.playButtonClick();
                      onTap();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF4CAF50),
                      elevation: 15,
                      shadowColor: const Color(0xFFFF6B35).withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                      ),
                      animationDuration: const Duration(milliseconds: 200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedRotation(
                          turns: _buttonAnimation.value * 0.2,
                          duration: const Duration(milliseconds: 500),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6B35).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(icon, size: 28, color: const Color(0xFFFF6B35)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          text,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _navigateToModuleSelector() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ModuleSelectorScreen(),
      ),
    );
  }

  void _navigateToSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }

  void _navigateToParentalGate() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ParentalGateScreen(),
      ),
    );
  }
}