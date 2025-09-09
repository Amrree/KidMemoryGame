import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../managers/audio_manager.dart';
import '../managers/save_manager.dart';
import '../managers/module_manager.dart';
import '../managers/analytics_manager.dart';
import '../models/game_module.dart';
import 'game_screen.dart';

class ModuleSelectorScreen extends StatefulWidget {
  const ModuleSelectorScreen({super.key});

  @override
  State<ModuleSelectorScreen> createState() => _ModuleSelectorScreenState();
}

class _ModuleSelectorScreenState extends State<ModuleSelectorScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Choose a Module',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF4CAF50),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            final audioManager = context.read<AudioManager>();
            audioManager.playButtonClick();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4CAF50),
              Color(0xFF2E7D32),
            ],
          ),
        ),
        child: Consumer<ModuleManager>(
          builder: (context, moduleManager, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: moduleManager.modules.length,
                    itemBuilder: (context, index) {
                      final module = moduleManager.modules[index];
                      return AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          final delay = index * 0.1;
                          final animationValue = Curves.easeOutCubic.transform(
                            (_animationController.value - delay).clamp(0.0, 1.0),
                          );
                          
                          return Transform.scale(
                            scale: animationValue,
                            child: Opacity(
                              opacity: animationValue,
                              child: _buildModuleCard(module),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildModuleCard(GameModule module) {
    return Consumer2<AudioManager, SaveManager>(
      builder: (context, audioManager, saveManager, child) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Card(
            elevation: module.isUnlocked ? 12 : 6,
            shadowColor: module.isUnlocked 
                ? const Color(0xFF4CAF50).withOpacity(0.3)
                : Colors.grey.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: InkWell(
              onTap: module.isUnlocked
                  ? () => _selectModule(module)
                  : () => _showLockedDialog(module),
              borderRadius: BorderRadius.circular(20),
              splashColor: const Color(0xFF4CAF50).withOpacity(0.1),
              highlightColor: const Color(0xFF4CAF50).withOpacity(0.05),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: module.isUnlocked
                      ? const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFFFFFFF),
                            Color(0xFFF1F8E9),
                          ],
                        )
                      : LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.grey[300]!,
                            Colors.grey[400]!,
                          ],
                        ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Module icon
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: module.isUnlocked
                              ? const Color(0xFF4CAF50).withOpacity(0.1)
                              : Colors.grey.withOpacity(0.3),
                          border: Border.all(
                            color: module.isUnlocked
                                ? const Color(0xFF4CAF50)
                                : Colors.grey,
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            module.iconPath,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                _getModuleIcon(module.id),
                                size: 30,
                                color: module.isUnlocked
                                    ? const Color(0xFF4CAF50)
                                    : Colors.grey[600],
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Module name
                      Text(
                        module.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: module.isUnlocked
                              ? const Color(0xFF2E7D32)
                              : Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      
                      // Module description
                      Text(
                        module.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: module.isUnlocked
                              ? const Color(0xFF424242)
                              : Colors.grey[500],
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      
                      // Difficulty and stats
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: module.isUnlocked
                                  ? _getDifficultyColor(module.difficultyLevel)
                                  : Colors.grey[400],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              module.difficultyDescription,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          if (module.isUnlocked)
                            Icon(
                              Icons.play_arrow,
                              color: const Color(0xFF4CAF50),
                              size: 20,
                            )
                          else
                            Icon(
                              Icons.lock,
                              color: Colors.grey[600],
                              size: 20,
                            ),
                        ],
                      ),
                      
                      // High score if unlocked
                      if (module.isUnlocked)
                        Consumer<SaveManager>(
                          builder: (context, saveManager, child) {
                            final highScore = saveManager.getModuleHighScore(module.id);
                            if (highScore > 0) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Color(0xFFFFD700),
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'High: $highScore',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF2E7D32),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _getModuleIcon(String moduleId) {
    switch (moduleId) {
      case 'shapes':
        return Icons.crop_square;
      case 'colors':
        return Icons.palette;
      case 'animals':
        return Icons.pets;
      case 'jobs':
        return Icons.work;
      case 'farm':
        return Icons.agriculture;
      case 'family':
        return Icons.family_restroom;
      default:
        return Icons.extension;
    }
  }

  Color _getDifficultyColor(int difficulty) {
    switch (difficulty) {
      case 1:
        return const Color(0xFF4CAF50); // Green for easy
      case 2:
        return const Color(0xFFFF9800); // Orange for medium
      case 3:
        return const Color(0xFFF44336); // Red for hard
      default:
        return const Color(0xFF9E9E9E); // Grey for custom
    }
  }

  void _selectModule(GameModule module) {
    final audioManager = context.read<AudioManager>();
    final analyticsManager = context.read<AnalyticsManager>();
    
    audioManager.playButtonClick();
    analyticsManager.recordUserInteraction('module_selected', {
      'module_id': module.id,
      'module_name': module.name,
    });
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GameScreen(module: module),
      ),
    );
  }

  void _showLockedDialog(GameModule module) {
    final audioManager = context.read<AudioManager>();
    audioManager.playButtonClick();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${module.name} is Locked'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lock,
              size: 48,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 16),
            Text(
              'Complete other modules to unlock ${module.name}!',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Age Range: ${module.ageRangeMin}-${module.ageRangeMax} years',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}