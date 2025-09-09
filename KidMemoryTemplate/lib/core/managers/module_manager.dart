import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/game_module.dart';

/// Manages game modules and their availability
class ModuleManager extends ChangeNotifier {
  static const String _boxName = 'modules';
  late Box<GameModule> _modulesBox;
  
  List<GameModule> _modules = [];
  String? _selectedModuleId;

  // Getters
  List<GameModule> get modules => _modules;
  String? get selectedModuleId => _selectedModuleId;
  GameModule? get selectedModule => 
      _selectedModuleId != null 
          ? _modules.firstWhere((m) => m.id == _selectedModuleId)
          : null;

  /// Initialize the module manager
  Future<void> initialize() async {
    _modulesBox = await Hive.openBox<GameModule>(_boxName);
    await _loadModules();
    await _initializeDefaultModules();
  }

  /// Load modules from storage
  Future<void> _loadModules() async {
    _modules = _modulesBox.values.toList();
    notifyListeners();
  }

  /// Initialize default modules if none exist
  Future<void> _initializeDefaultModules() async {
    if (_modules.isEmpty) {
      final defaultModules = [
        GameModule(
          id: 'shapes',
          name: 'Shapes',
          description: 'Learn about different shapes',
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
        ),
        GameModule(
          id: 'colors',
          name: 'Colors',
          description: 'Discover beautiful colors',
          iconPath: 'assets/images/colors/icon.png',
          backgroundPath: 'assets/images/colors/background.png',
          cardPaths: [
            'assets/images/colors/red.png',
            'assets/images/colors/blue.png',
            'assets/images/colors/green.png',
            'assets/images/colors/yellow.png',
            'assets/images/colors/orange.png',
            'assets/images/colors/purple.png',
          ],
          isUnlocked: true, // Second module is unlocked
          difficultyLevel: 1,
          audioPaths: [
            'assets/audio/colors/red.mp3',
            'assets/audio/colors/blue.mp3',
            'assets/audio/colors/green.mp3',
            'assets/audio/colors/yellow.mp3',
            'assets/audio/colors/orange.mp3',
            'assets/audio/colors/purple.mp3',
          ],
        ),
        GameModule(
          id: 'animals',
          name: 'Animals',
          description: 'Meet friendly animals',
          iconPath: 'assets/images/animals/icon.png',
          backgroundPath: 'assets/images/animals/background.png',
          cardPaths: [
            'assets/images/animals/cat.png',
            'assets/images/animals/dog.png',
            'assets/images/animals/bird.png',
            'assets/images/animals/fish.png',
            'assets/images/animals/rabbit.png',
            'assets/images/animals/butterfly.png',
          ],
          isUnlocked: false, // Locked by default
          difficultyLevel: 2,
          audioPaths: [
            'assets/audio/animals/cat.mp3',
            'assets/audio/animals/dog.mp3',
            'assets/audio/animals/bird.mp3',
            'assets/audio/animals/fish.mp3',
            'assets/audio/animals/rabbit.mp3',
            'assets/audio/animals/butterfly.mp3',
          ],
        ),
        GameModule(
          id: 'jobs',
          name: 'Jobs',
          description: 'Learn about different professions',
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
        ),
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
            'assets/images/farm/horse.png',
            'assets/images/farm/sheep.png',
            'assets/images/farm/duck.png',
          ],
          isUnlocked: false,
          difficultyLevel: 3,
          audioPaths: [
            'assets/audio/farm/cow.mp3',
            'assets/audio/farm/pig.mp3',
            'assets/audio/farm/chicken.mp3',
            'assets/audio/farm/horse.mp3',
            'assets/audio/farm/sheep.mp3',
            'assets/audio/farm/duck.mp3',
          ],
        ),
        GameModule(
          id: 'family',
          name: 'Family',
          description: 'Meet the family members',
          iconPath: 'assets/images/family/icon.png',
          backgroundPath: 'assets/images/family/background.png',
          cardPaths: [
            'assets/images/family/mom.png',
            'assets/images/family/dad.png',
            'assets/images/family/grandma.png',
            'assets/images/family/grandpa.png',
            'assets/images/family/sister.png',
            'assets/images/family/brother.png',
          ],
          isUnlocked: false,
          difficultyLevel: 3,
          audioPaths: [
            'assets/audio/family/mom.mp3',
            'assets/audio/family/dad.mp3',
            'assets/audio/family/grandma.mp3',
            'assets/audio/family/grandpa.mp3',
            'assets/audio/family/sister.mp3',
            'assets/audio/family/brother.mp3',
          ],
        ),
      ];

      for (final module in defaultModules) {
        await _modulesBox.put(module.id, module);
      }
      
      _modules = defaultModules;
      notifyListeners();
    }
  }

  /// Select a module
  void selectModule(String moduleId) {
    if (_modules.any((m) => m.id == moduleId && m.isUnlocked)) {
      _selectedModuleId = moduleId;
      notifyListeners();
    }
  }

  /// Unlock a module
  Future<void> unlockModule(String moduleId) async {
    final moduleIndex = _modules.indexWhere((m) => m.id == moduleId);
    if (moduleIndex != -1) {
      final module = _modules[moduleIndex].copyWith(isUnlocked: true);
      _modules[moduleIndex] = module;
      await _modulesBox.put(moduleId, module);
      notifyListeners();
    }
  }

  /// Lock a module
  Future<void> lockModule(String moduleId) async {
    final moduleIndex = _modules.indexWhere((m) => m.id == moduleId);
    if (moduleIndex != -1) {
      final module = _modules[moduleIndex].copyWith(isUnlocked: false);
      _modules[moduleIndex] = module;
      await _modulesBox.put(moduleId, module);
      notifyListeners();
    }
  }

  /// Get unlocked modules
  List<GameModule> getUnlockedModules() {
    return _modules.where((m) => m.isUnlocked).toList();
  }

  /// Get locked modules
  List<GameModule> getLockedModules() {
    return _modules.where((m) => !m.isUnlocked).toList();
  }

  /// Get modules by difficulty level
  List<GameModule> getModulesByDifficulty(int level) {
    return _modules.where((m) => m.difficultyLevel == level).toList();
  }

  /// Add a custom module
  Future<void> addModule(GameModule module) async {
    await _modulesBox.put(module.id, module);
    _modules.add(module);
    notifyListeners();
  }

  /// Remove a module
  Future<void> removeModule(String moduleId) async {
    await _modulesBox.delete(moduleId);
    _modules.removeWhere((m) => m.id == moduleId);
    if (_selectedModuleId == moduleId) {
      _selectedModuleId = null;
    }
    notifyListeners();
  }

  /// Update a module
  Future<void> updateModule(GameModule module) async {
    await _modulesBox.put(module.id, module);
    final index = _modules.indexWhere((m) => m.id == module.id);
    if (index != -1) {
      _modules[index] = module;
    } else {
      _modules.add(module);
    }
    notifyListeners();
  }

  /// Check if a module exists
  bool hasModule(String moduleId) {
    return _modules.any((m) => m.id == moduleId);
  }

  /// Get module by ID
  GameModule? getModuleById(String moduleId) {
    try {
      return _modules.firstWhere((m) => m.id == moduleId);
    } catch (e) {
      return null;
    }
  }

  /// Reset all modules to default state
  Future<void> resetModules() async {
    await _modulesBox.clear();
    _modules.clear();
    _selectedModuleId = null;
    await _initializeDefaultModules();
  }

  @override
  void dispose() {
    _modulesBox.close();
    super.dispose();
  }
}