import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/game_module.dart';

/// Manages game modules, their registration, and unlock status
class ModuleManager extends ChangeNotifier {
  static final ModuleManager _instance = ModuleManager._internal();
  factory ModuleManager() => _instance;
  ModuleManager._internal();

  late Box<GameModule> _moduleBox;
  final List<GameModule> _modules = [];
  GameModule? _currentModule;

  // Getters
  List<GameModule> get modules => List.unmodifiable(_modules);
  GameModule? get currentModule => _currentModule;
  List<GameModule> get unlockedModules => _modules.where((m) => m.isUnlocked).toList();
  List<GameModule> get lockedModules => _modules.where((m) => !m.isUnlocked).toList();

  /// Initialize the module manager
  Future<void> init() async {
    try {
      _moduleBox = await Hive.openBox<GameModule>('modules');
      await _loadModules();
      await _initializeDefaultModules();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing ModuleManager: $e');
      }
    }
  }

  /// Load modules from storage
  Future<void> _loadModules() async {
    _modules.clear();
    for (final module in _moduleBox.values) {
      _modules.add(module);
    }
  }

  /// Initialize default modules if none exist
  Future<void> _initializeDefaultModules() async {
    if (_modules.isEmpty) {
      final defaultModules = [
        // Shapes Module
        GameModule(
          id: 'shapes',
          name: 'Shapes',
          description: 'Learn about different shapes and patterns',
          iconPath: 'assets/images/shapes/icon.png',
          backgroundPath: 'assets/images/shapes/background.png',
          cardPaths: [
            'assets/images/shapes/circle.png',
            'assets/images/shapes/square.png',
            'assets/images/shapes/triangle.png',
            'assets/images/shapes/rectangle.png',
            'assets/images/shapes/star.png',
            'assets/images/shapes/heart.png',
          ],
          isUnlocked: true, // First module is always unlocked
          difficultyLevel: 1,
          audioPaths: [
            'assets/audio/shapes/circle.mp3',
            'assets/audio/shapes/square.mp3',
            'assets/audio/shapes/triangle.mp3',
            'assets/audio/shapes/rectangle.mp3',
            'assets/audio/shapes/star.mp3',
            'assets/audio/shapes/heart.mp3',
          ],
          category: 'Learning',
          ageRangeMin: 2,
          ageRangeMax: 5,
        ),
        
        // Colors Module
        GameModule(
          id: 'colors',
          name: 'Colors',
          description: 'Discover the world of colors',
          iconPath: 'assets/images/colors/icon.png',
          backgroundPath: 'assets/images/colors/background.png',
          cardPaths: [
            'assets/images/colors/red.png',
            'assets/images/colors/blue.png',
            'assets/images/colors/green.png',
            'assets/images/colors/yellow.png',
            'assets/images/colors/purple.png',
            'assets/images/colors/orange.png',
          ],
          isUnlocked: true,
          difficultyLevel: 1,
          audioPaths: [
            'assets/audio/colors/red.mp3',
            'assets/audio/colors/blue.mp3',
            'assets/audio/colors/green.mp3',
            'assets/audio/colors/yellow.mp3',
            'assets/audio/colors/purple.mp3',
            'assets/audio/colors/orange.mp3',
          ],
          category: 'Learning',
          ageRangeMin: 2,
          ageRangeMax: 5,
        ),
        
        // Animals Module
        GameModule(
          id: 'animals',
          name: 'Animals',
          description: 'Meet friendly animals from around the world',
          iconPath: 'assets/images/animals/icon.png',
          backgroundPath: 'assets/images/animals/background.png',
          cardPaths: [
            'assets/images/animals/cat.png',
            'assets/images/animals/dog.png',
            'assets/images/animals/bird.png',
            'assets/images/animals/fish.png',
            'assets/images/animals/rabbit.png',
            'assets/images/animals/bear.png',
          ],
          isUnlocked: false,
          difficultyLevel: 2,
          audioPaths: [
            'assets/audio/animals/cat.mp3',
            'assets/audio/animals/dog.mp3',
            'assets/audio/animals/bird.mp3',
            'assets/audio/animals/fish.mp3',
            'assets/audio/animals/rabbit.mp3',
            'assets/audio/animals/bear.mp3',
          ],
          category: 'Nature',
          ageRangeMin: 3,
          ageRangeMax: 7,
        ),
        
        // Jobs Module
        GameModule(
          id: 'jobs',
          name: 'Jobs',
          description: 'Explore different professions and careers',
          iconPath: 'assets/images/jobs/icon.png',
          backgroundPath: 'assets/images/jobs/background.png',
          cardPaths: [
            'assets/images/jobs/doctor.png',
            'assets/images/jobs/teacher.png',
            'assets/images/jobs/firefighter.png',
            'assets/images/jobs/chef.png',
            'assets/images/jobs/police.png',
            'assets/images/jobs/artist.png',
          ],
          isUnlocked: false,
          difficultyLevel: 2,
          audioPaths: [
            'assets/audio/jobs/doctor.mp3',
            'assets/audio/jobs/teacher.mp3',
            'assets/audio/jobs/firefighter.mp3',
            'assets/audio/jobs/chef.mp3',
            'assets/audio/jobs/police.mp3',
            'assets/audio/jobs/artist.mp3',
          ],
          category: 'Social',
          ageRangeMin: 4,
          ageRangeMax: 8,
        ),
        
        // Farm Module
        GameModule(
          id: 'farm',
          name: 'Farm',
          description: 'Visit the farm and meet farm animals',
          iconPath: 'assets/images/farm/icon.png',
          backgroundPath: 'assets/images/farm/background.png',
          cardPaths: [
            'assets/images/farm/cow.png',
            'assets/images/farm/pig.png',
            'assets/images/farm/chicken.png',
            'assets/images/farm/sheep.png',
            'assets/images/farm/horse.png',
            'assets/images/farm/duck.png',
          ],
          isUnlocked: false,
          difficultyLevel: 2,
          audioPaths: [
            'assets/audio/farm/cow.mp3',
            'assets/audio/farm/pig.mp3',
            'assets/audio/farm/chicken.mp3',
            'assets/audio/farm/sheep.mp3',
            'assets/audio/farm/horse.mp3',
            'assets/audio/farm/duck.mp3',
          ],
          category: 'Nature',
          ageRangeMin: 3,
          ageRangeMax: 6,
        ),
        
        // Family Module
        GameModule(
          id: 'family',
          name: 'Family',
          description: 'Learn about family members and relationships',
          iconPath: 'assets/images/family/icon.png',
          backgroundPath: 'assets/images/family/background.png',
          cardPaths: [
            'assets/images/family/mom.png',
            'assets/images/family/dad.png',
            'assets/images/family/sister.png',
            'assets/images/family/brother.png',
            'assets/images/family/grandma.png',
            'assets/images/family/grandpa.png',
          ],
          isUnlocked: false,
          difficultyLevel: 1,
          audioPaths: [
            'assets/audio/family/mom.mp3',
            'assets/audio/family/dad.mp3',
            'assets/audio/family/sister.mp3',
            'assets/audio/family/brother.mp3',
            'assets/audio/family/grandma.mp3',
            'assets/audio/family/grandpa.mp3',
          ],
          category: 'Social',
          ageRangeMin: 2,
          ageRangeMax: 6,
        ),
      ];

      // Save default modules
      for (final module in defaultModules) {
        await _moduleBox.put(module.id, module);
        _modules.add(module);
      }
    }
  }

  /// Register a new module
  Future<void> registerModule(GameModule module) async {
    try {
      await _moduleBox.put(module.id, module);
      _modules.add(module);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error registering module: $e');
      }
    }
  }

  /// Unlock a module
  Future<void> unlockModule(String moduleId) async {
    final module = _modules.firstWhere(
      (m) => m.id == moduleId,
      orElse: () => throw Exception('Module not found: $moduleId'),
    );
    
    final updatedModule = module.copyWith(isUnlocked: true);
    await _moduleBox.put(moduleId, updatedModule);
    
    final index = _modules.indexWhere((m) => m.id == moduleId);
    if (index != -1) {
      _modules[index] = updatedModule;
      notifyListeners();
    }
  }

  /// Lock a module
  Future<void> lockModule(String moduleId) async {
    final module = _modules.firstWhere(
      (m) => m.id == moduleId,
      orElse: () => throw Exception('Module not found: $moduleId'),
    );
    
    final updatedModule = module.copyWith(isUnlocked: false);
    await _moduleBox.put(moduleId, updatedModule);
    
    final index = _modules.indexWhere((m) => m.id == moduleId);
    if (index != -1) {
      _modules[index] = updatedModule;
      notifyListeners();
    }
  }

  /// Set the current module
  void setCurrentModule(GameModule? module) {
    _currentModule = module;
    notifyListeners();
  }

  /// Get module by ID
  GameModule? getModuleById(String id) {
    try {
      return _modules.firstWhere((m) => m.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get modules by category
  List<GameModule> getModulesByCategory(String category) {
    return _modules.where((m) => m.category == category).toList();
  }

  /// Get modules appropriate for age
  List<GameModule> getModulesForAge(int age) {
    return _modules.where((m) => m.isAppropriateForAge(age)).toList();
  }

  /// Get modules by difficulty level
  List<GameModule> getModulesByDifficulty(int difficulty) {
    return _modules.where((m) => m.difficultyLevel == difficulty).toList();
  }

  /// Update module data
  Future<void> updateModule(String moduleId, Map<String, dynamic> updates) async {
    final module = getModuleById(moduleId);
    if (module == null) return;

    final updatedModule = module.copyWith(
      name: updates['name'] as String?,
      description: updates['description'] as String?,
      difficultyLevel: updates['difficultyLevel'] as int?,
      isUnlocked: updates['isUnlocked'] as bool?,
    );

    await _moduleBox.put(moduleId, updatedModule);
    
    final index = _modules.indexWhere((m) => m.id == moduleId);
    if (index != -1) {
      _modules[index] = updatedModule;
      notifyListeners();
    }
  }

  /// Clear all modules (for testing)
  Future<void> clearAllModules() async {
    await _moduleBox.clear();
    _modules.clear();
    _currentModule = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _moduleBox.close();
    super.dispose();
  }
}