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
          iconPath: 'images/shapes/icon.png',
          backgroundPath: 'images/shapes/background.png',
          cardPaths: [
            'images/shapes/circle.png',
            'images/shapes/square.png',
            'images/shapes/triangle.png',
            'images/shapes/rectangle.png',
            'images/shapes/star.png',
            'images/shapes/heart.png',
          ],
          isUnlocked: true, // First module is always unlocked
          difficultyLevel: 1,
          audioPaths: [
            'audio/shapes/circle.mp3',
            'audio/shapes/square.mp3',
            'audio/shapes/triangle.mp3',
            'audio/shapes/rectangle.mp3',
            'audio/shapes/star.mp3',
            'audio/shapes/heart.mp3',
          ],
        ),
        GameModule(
          id: 'colors',
          name: 'Colors',
          description: 'Discover beautiful colors',
          iconPath: 'images/colors/icon.png',
          backgroundPath: 'images/colors/background.png',
          cardPaths: [
            'images/colors/red.png',
            'images/colors/blue.png',
            'images/colors/green.png',
            'images/colors/yellow.png',
            'images/colors/orange.png',
            'images/colors/purple.png',
          ],
          isUnlocked: true, // Second module is unlocked
          difficultyLevel: 1,
          audioPaths: [
            'audio/colors/red.mp3',
            'audio/colors/blue.mp3',
            'audio/colors/green.mp3',
            'audio/colors/yellow.mp3',
            'audio/colors/orange.mp3',
            'audio/colors/purple.mp3',
          ],
        ),
        GameModule(
          id: 'animals',
          name: 'Animals',
          description: 'Meet friendly animals',
          iconPath: 'images/animals/icon.png',
          backgroundPath: 'images/animals/background.png',
          cardPaths: [
            'images/animals/cat.png',
            'images/animals/dog.png',
            'images/animals/bird.png',
            'images/animals/fish.png',
            'images/animals/rabbit.png',
            'images/animals/butterfly.png',
          ],
          isUnlocked: false, // Locked by default
          difficultyLevel: 2,
          audioPaths: [
            'audio/animals/cat.mp3',
            'audio/animals/dog.mp3',
            'audio/animals/bird.mp3',
            'audio/animals/fish.mp3',
            'audio/animals/rabbit.mp3',
            'audio/animals/butterfly.mp3',
          ],
        ),
        GameModule(
          id: 'jobs',
          name: 'Jobs',
          description: 'Learn about different professions',
          iconPath: 'images/jobs/icon.png',
          backgroundPath: 'images/jobs/background.png',
          cardPaths: [
            'images/jobs/doctor.png',
            'images/jobs/teacher.png',
            'images/jobs/firefighter.png',
            'images/jobs/chef.png',
            'images/jobs/police.png',
            'images/jobs/artist.png',
          ],
          isUnlocked: false,
          difficultyLevel: 2,
          audioPaths: [
            'audio/jobs/doctor.mp3',
            'audio/jobs/teacher.mp3',
            'audio/jobs/firefighter.mp3',
            'audio/jobs/chef.mp3',
            'audio/jobs/police.mp3',
            'audio/jobs/artist.mp3',
          ],
        ),
        GameModule(
          id: 'farm',
          name: 'Farm',
          description: 'Visit the farm and meet farm animals',
          iconPath: 'images/farm/icon.png',
          backgroundPath: 'images/farm/background.png',
          cardPaths: [
            'images/farm/cow.png',
            'images/farm/pig.png',
            'images/farm/chicken.png',
            'images/farm/horse.png',
            'images/farm/sheep.png',
            'images/farm/duck.png',
          ],
          isUnlocked: false,
          difficultyLevel: 3,
          audioPaths: [
            'audio/farm/cow.mp3',
            'audio/farm/pig.mp3',
            'audio/farm/chicken.mp3',
            'audio/farm/horse.mp3',
            'audio/farm/sheep.mp3',
            'audio/farm/duck.mp3',
          ],
        ),
        GameModule(
          id: 'family',
          name: 'Family',
          description: 'Meet the family members',
          iconPath: 'images/family/icon.png',
          backgroundPath: 'images/family/background.png',
          cardPaths: [
            'images/family/mom.png',
            'images/family/dad.png',
            'images/family/grandma.png',
            'images/family/grandpa.png',
            'images/family/sister.png',
            'images/family/brother.png',
          ],
          isUnlocked: false,
          difficultyLevel: 3,
          audioPaths: [
            'audio/family/mom.mp3',
            'audio/family/dad.mp3',
            'audio/family/grandma.mp3',
            'audio/family/grandpa.mp3',
            'audio/family/sister.mp3',
            'audio/family/brother.mp3',
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