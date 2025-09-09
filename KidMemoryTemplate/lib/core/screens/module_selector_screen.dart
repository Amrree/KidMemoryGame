import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../managers/audio_manager.dart';
import '../managers/module_manager.dart';
import '../managers/save_manager.dart';
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
      duration: const Duration(milliseconds: 800),
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
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
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
        title: const Text('Choose a Module'),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.read<AudioManager>().playButtonClick();
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
                      return _buildModuleCard(module);
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
            elevation: module.isUnlocked ? 8 : 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              onTap: module.isUnlocked
                  ? () => _selectModule(module)
                  : () => _showLockedDialog(module),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: module.isUnlocked
                      ? const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF81C784),
                            Color(0xFF4CAF50),
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
                child: Stack(
                  children: [
                    // Module icon
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.9),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
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
                          Text(
                            module.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: module.isUnlocked
                                  ? Colors.white
                                  : Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            module.description,
                            style: TextStyle(
                              fontSize: 12,
                              color: module.isUnlocked
                                  ? Colors.white70
                                  : Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // Lock icon for locked modules
                    if (!module.isUnlocked)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.lock,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),

                    // Difficulty indicator
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            3,
                            (index) => Icon(
                              Icons.star,
                              size: 12,
                              color: index < module.difficultyLevel
                                  ? Colors.amber
                                  : Colors.grey[400],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Last played indicator
                    if (module.isUnlocked &&
                        saveManager.lastPlayedModule == module.id)
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 12,
                          ),
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

  void _selectModule(GameModule module) {
    final audioManager = context.read<AudioManager>();
    final saveManager = context.read<SaveManager>();
    
    audioManager.playButtonClick();
    saveManager.setLastPlayedModule(module.id);
    
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
        content: Text(
          'Complete previous modules to unlock ${module.name}.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              audioManager.playButtonClick();
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}