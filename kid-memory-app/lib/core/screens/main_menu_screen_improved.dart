import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../managers/audio_manager_improved.dart';
import '../managers/save_manager_improved.dart';
import '../managers/module_manager.dart';
import '../managers/analytics_manager.dart';
import 'module_selector_screen.dart';
import 'settings_screen.dart';
import 'parental_gate_screen.dart';

class MainMenuScreenImproved extends StatefulWidget {
  const MainMenuScreenImproved({super.key});

  @override
  State<MainMenuScreenImproved> createState() => _MainMenuScreenImprovedState();
}

class _MainMenuScreenImprovedState extends State<MainMenuScreenImproved>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _buttonController;
  late Animation<double> _logoAnimation;
  late Animation<double> _buttonAnimation;
  
  // Error tracking
  int _errorCount = 0;
  static const int _maxErrors = 5;
  
  // Performance tracking
  DateTime? _screenStartTime;
  int _buttonPressCount = 0;

  @override
  void initState() {
    super.initState();
    _screenStartTime = DateTime.now();
    _setupAnimations();
    _playBackgroundMusic();
  }

  void _setupAnimations() {
    try {
      _logoController = AnimationController(
        duration: const Duration(milliseconds: 1500),
        vsync: this,
      );
      
      _buttonController = AnimationController(
        duration: const Duration(milliseconds: 800),
        vsync: this,
      );

      _logoAnimation = CurvedAnimation(
        parent: _logoController,
        curve: Curves.elasticOut,
      );

      _buttonAnimation = CurvedAnimation(
        parent: _buttonController,
        curve: Curves.easeOutBack,
      );

      _logoController.forward();
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _buttonController.forward();
        }
      });
    } catch (e) {
      _handleError('Error setting up animations', e);
    }
  }

  void _playBackgroundMusic() {
    try {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          final audioManager = context.read<AudioManagerImproved>();
          audioManager.playMainMenuMusic();
        }
      });
    } catch (e) {
      _handleError('Error playing background music', e);
    }
  }

  @override
  void dispose() {
    try {
      _logoController.dispose();
      _buttonController.dispose();
    } catch (e) {
      _handleError('Error disposing controllers', e);
    }
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
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.psychology,
                            size: 60,
                            color: Color(0xFF4CAF50),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      FadeTransition(
                        opacity: _logoAnimation,
                        child: const Text(
                          'Kid Memory',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      FadeTransition(
                        opacity: _logoAnimation,
                        child: const Text(
                          'Educational Memory Game',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Menu buttons
                Expanded(
                  flex: 3,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 1),
                      end: Offset.zero,
                    ).animate(_buttonAnimation),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildMenuButton(
                          'Play Game',
                          Icons.play_arrow,
                          () => _navigateToModuleSelector(),
                        ),
                        const SizedBox(height: 16),
                        _buildMenuButton(
                          'Settings',
                          Icons.settings,
                          () => _navigateToSettings(),
                        ),
                        const SizedBox(height: 16),
                        _buildMenuButton(
                          'Parental Gate',
                          Icons.lock,
                          () => _navigateToParentalGate(),
                        ),
                        const SizedBox(height: 16),
                        _buildMenuButton(
                          'Statistics',
                          Icons.analytics,
                          () => _showStatistics(),
                        ),
                      ],
                    ),
                  ),
                ),

                // Footer with version info and error indicator
                FadeTransition(
                  opacity: _buttonAnimation,
                  child: Column(
                    children: [
                      Text(
                        'Version 1.0.0',
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 12,
                        ),
                      ),
                      if (_errorCount > 0)
                        Text(
                          'Errors: $_errorCount',
                          style: TextStyle(
                            color: Colors.red.shade300,
                            fontSize: 10,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(String text, IconData icon, VoidCallback onTap) {
    return Consumer<AudioManagerImproved>(
      builder: (context, audioManager, child) {
        return Container(
          width: double.infinity,
          height: 60,
          margin: const EdgeInsets.symmetric(horizontal: 32),
          child: ElevatedButton(
            onPressed: () {
              try {
                _buttonPressCount++;
                audioManager.playButtonClick();
                onTap();
              } catch (e) {
                _handleError('Error handling button press: $text', e);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF4CAF50),
              elevation: 8,
              shadowColor: Colors.black.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 24),
                const SizedBox(width: 12),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToModuleSelector() {
    try {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ModuleSelectorScreen(),
        ),
      );
    } catch (e) {
      _handleError('Error navigating to module selector', e);
    }
  }

  void _navigateToSettings() {
    try {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const SettingsScreen(),
        ),
      );
    } catch (e) {
      _handleError('Error navigating to settings', e);
    }
  }

  void _navigateToParentalGate() {
    try {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ParentalGateScreen(),
        ),
      );
    } catch (e) {
      _handleError('Error navigating to parental gate', e);
    }
  }

  void _showStatistics() {
    try {
      final audioManager = context.read<AudioManagerImproved>();
      final saveManager = context.read<SaveManagerImproved>();
      
      final audioStats = audioManager.getAudioStats();
      final saveStats = saveManager.getPlayerStats();
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Game Statistics'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Games Played: ${saveStats['gamesPlayed']}'),
                Text('Total Play Time: ${saveStats['totalPlayTime']} seconds'),
                Text('High Score: ${saveStats['highScore']}'),
                Text('Button Presses: $_buttonPressCount'),
                Text('Screen Time: ${_getScreenTime()} seconds'),
                Text('Audio Errors: ${audioStats['errorCount']}'),
                Text('Save Errors: ${saveStats['errorCount'] ?? 0}'),
                Text('UI Errors: $_errorCount'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } catch (e) {
      _handleError('Error showing statistics', e);
    }
  }

  String _getScreenTime() {
    if (_screenStartTime == null) return '0';
    final duration = DateTime.now().difference(_screenStartTime!);
    return duration.inSeconds.toString();
  }

  /// Handle errors with improved logging
  void _handleError(String message, dynamic error) {
    _errorCount++;
    
    if (error != null) {
      print('MainMenuScreen Error: $message - $error');
    } else {
      print('MainMenuScreen Error: $message');
    }
    
    // Show error to user if too many errors
    if (_errorCount >= _maxErrors) {
      _showErrorDialog();
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text('Too many errors occurred ($_errorCount). Please restart the app.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Could implement app restart here
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}