import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../managers/audio_manager.dart';
import '../managers/module_manager.dart';
import '../managers/save_manager.dart';
import '../managers/analytics_manager.dart';
import '../managers/parental_gate_manager.dart';
import 'main_menu_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _dotsController;
  late AnimationController _textController;
  
  late Animation<double> _logoAnimation;
  late Animation<double> _dotsAnimation;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Initialize all managers
      final audioManager = context.read<AudioManager>();
      final moduleManager = context.read<ModuleManager>();
      final saveManager = context.read<SaveManager>();
      final analyticsManager = context.read<AnalyticsManager>();
      final parentalGateManager = context.read<ParentalGateManager>();
      
      await Future.wait([
        audioManager.initialize(),
        moduleManager.init(),
        saveManager.init(),
        analyticsManager.init(),
        parentalGateManager.init(),
      ]);
      
      // Wait for minimum loading time for smooth experience
      await Future.delayed(const Duration(milliseconds: 3000));
      
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const MainMenuScreen(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        // Show error screen or retry
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error initializing app: $e'),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: _initializeApp,
            ),
          ),
        );
      }
    }
  }

  void _setupAnimations() {
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _dotsController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _logoAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    );

    _dotsAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _dotsController,
      curve: Curves.easeInOut,
    ));

    _textAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _textController.forward();
      }
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        _dotsController.repeat();
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _dotsController.dispose();
    _textController.dispose();
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated logo
                Expanded(
                  flex: 3,
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _logoAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _logoAnimation.value,
                          child: Transform.rotate(
                            angle: _logoAnimation.value * 0.1,
                            child: Container(
                              width: 150,
                              height: 150,
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
                              child: const Icon(
                                Icons.psychology,
                                size: 80,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                
                // App name
                Expanded(
                  flex: 1,
                  child: AnimatedBuilder(
                    animation: _textAnimation,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _textAnimation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.3),
                            end: Offset.zero,
                          ).animate(_textAnimation),
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
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 3.0,
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
                      );
                    },
                  ),
                ),
                
                // Loading dots
                Expanded(
                  flex: 1,
                  child: AnimatedBuilder(
                    animation: _dotsAnimation,
                    builder: (context, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (index) {
                          final delay = index * 0.2;
                          final animationValue = Curves.easeInOut.transform(
                            (_dotsAnimation.value - delay).clamp(0.0, 1.0),
                          );
                          
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            child: Transform.scale(
                              scale: 0.5 + (animationValue * 0.5),
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.3),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ),
                
                // Loading text
                Expanded(
                  flex: 1,
                  child: AnimatedBuilder(
                    animation: _textAnimation,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _textAnimation,
                        child: const Text(
                          'Loading fun games...',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.0,
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
}