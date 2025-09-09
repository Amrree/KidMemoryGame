import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kidsgame/core/managers/module_manager.dart';
import 'package:kidsgame/core/models/game_module.dart';

void main() {
  group('ModuleManager Unit Tests', () {
    late ModuleManager moduleManager;

    setUp(() async {
      // Initialize Hive for testing
      await Hive.initFlutter();
      Hive.registerAdapter(GameModuleAdapter());
      moduleManager = ModuleManager();
    });

    tearDown(() async {
      await moduleManager.dispose();
      await Hive.deleteFromDisk();
    });

    test('should initialize with default modules', () async {
      await moduleManager.init();
      
      expect(moduleManager.modules.length, 6);
      expect(moduleManager.modules.any((m) => m.id == 'shapes'), true);
      expect(moduleManager.modules.any((m) => m.id == 'colors'), true);
      expect(moduleManager.modules.any((m) => m.id == 'animals'), true);
      expect(moduleManager.modules.any((m) => m.id == 'jobs'), true);
      expect(moduleManager.modules.any((m) => m.id == 'farm'), true);
      expect(moduleManager.modules.any((m) => m.id == 'family'), true);
    });

    test('should have shapes and colors unlocked by default', () async {
      await moduleManager.init();
      
      final shapesModule = moduleManager.modules.firstWhere((m) => m.id == 'shapes');
      final colorsModule = moduleManager.modules.firstWhere((m) => m.id == 'colors');
      
      expect(shapesModule.isUnlocked, true);
      expect(colorsModule.isUnlocked, true);
    });

    test('should have other modules locked by default', () async {
      await moduleManager.init();
      
      final animalsModule = moduleManager.modules.firstWhere((m) => m.id == 'animals');
      final jobsModule = moduleManager.modules.firstWhere((m) => m.id == 'jobs');
      final farmModule = moduleManager.modules.firstWhere((m) => m.id == 'farm');
      final familyModule = moduleManager.modules.firstWhere((m) => m.id == 'family');
      
      expect(animalsModule.isUnlocked, false);
      expect(jobsModule.isUnlocked, false);
      expect(farmModule.isUnlocked, false);
      expect(familyModule.isUnlocked, false);
    });

    test('should unlock module successfully', () async {
      await moduleManager.init();
      
      await moduleManager.unlockModule('animals');
      
      final animalsModule = moduleManager.modules.firstWhere((m) => m.id == 'animals');
      expect(animalsModule.isUnlocked, true);
    });

    test('should lock module successfully', () async {
      await moduleManager.init();
      
      // First unlock a module
      await moduleManager.unlockModule('animals');
      expect(moduleManager.modules.firstWhere((m) => m.id == 'animals').isUnlocked, true);
      
      // Then lock it
      await moduleManager.lockModule('animals');
      expect(moduleManager.modules.firstWhere((m) => m.id == 'animals').isUnlocked, false);
    });

    test('should throw exception when unlocking non-existent module', () async {
      await moduleManager.init();
      
      expect(
        () => moduleManager.unlockModule('nonexistent'),
        throwsException,
      );
    });

    test('should throw exception when locking non-existent module', () async {
      await moduleManager.init();
      
      expect(
        () => moduleManager.lockModule('nonexistent'),
        throwsException,
      );
    });

    test('should set current module', () async {
      await moduleManager.init();
      
      final shapesModule = moduleManager.modules.firstWhere((m) => m.id == 'shapes');
      moduleManager.setCurrentModule(shapesModule);
      
      expect(moduleManager.currentModule, shapesModule);
    });

    test('should clear current module', () async {
      await moduleManager.init();
      
      final shapesModule = moduleManager.modules.firstWhere((m) => m.id == 'shapes');
      moduleManager.setCurrentModule(shapesModule);
      expect(moduleManager.currentModule, shapesModule);
      
      moduleManager.setCurrentModule(null);
      expect(moduleManager.currentModule, null);
    });

    test('should get module by ID', () async {
      await moduleManager.init();
      
      final shapesModule = moduleManager.getModuleById('shapes');
      expect(shapesModule, isNotNull);
      expect(shapesModule!.id, 'shapes');
      
      final nonexistentModule = moduleManager.getModuleById('nonexistent');
      expect(nonexistentModule, isNull);
    });

    test('should get unlocked modules', () async {
      await moduleManager.init();
      
      final unlockedModules = moduleManager.unlockedModules;
      expect(unlockedModules.length, 2); // shapes and colors
      expect(unlockedModules.any((m) => m.id == 'shapes'), true);
      expect(unlockedModules.any((m) => m.id == 'colors'), true);
    });

    test('should get locked modules', () async {
      await moduleManager.init();
      
      final lockedModules = moduleManager.lockedModules;
      expect(lockedModules.length, 4); // animals, jobs, farm, family
      expect(lockedModules.any((m) => m.id == 'animals'), true);
      expect(lockedModules.any((m) => m.id == 'jobs'), true);
      expect(lockedModules.any((m) => m.id == 'farm'), true);
      expect(lockedModules.any((m) => m.id == 'family'), true);
    });

    test('should get modules by category', () async {
      await moduleManager.init();
      
      final learningModules = moduleManager.getModulesByCategory('Learning');
      expect(learningModules.length, 2);
      expect(learningModules.any((m) => m.id == 'shapes'), true);
      expect(learningModules.any((m) => m.id == 'colors'), true);
      
      final natureModules = moduleManager.getModulesByCategory('Nature');
      expect(natureModules.length, 2);
      expect(natureModules.any((m) => m.id == 'animals'), true);
      expect(natureModules.any((m) => m.id == 'farm'), true);
      
      final socialModules = moduleManager.getModulesByCategory('Social');
      expect(socialModules.length, 2);
      expect(socialModules.any((m) => m.id == 'jobs'), true);
      expect(socialModules.any((m) => m.id == 'family'), true);
    });

    test('should get modules for specific age', () async {
      await moduleManager.init();
      
      final toddlerModules = moduleManager.getModulesForAge(3);
      expect(toddlerModules.length, 4); // shapes, colors, farm, family
      expect(toddlerModules.any((m) => m.id == 'shapes'), true);
      expect(toddlerModules.any((m) => m.id == 'colors'), true);
      expect(toddlerModules.any((m) => m.id == 'farm'), true);
      expect(toddlerModules.any((m) => m.id == 'family'), true);
      
      final preschoolModules = moduleManager.getModulesForAge(5);
      expect(preschoolModules.length, 6); // all modules
    });

    test('should get modules by difficulty level', () async {
      await moduleManager.init();
      
      final easyModules = moduleManager.getModulesByDifficulty(1);
      expect(easyModules.length, 3); // shapes, colors, family
      expect(easyModules.any((m) => m.id == 'shapes'), true);
      expect(easyModules.any((m) => m.id == 'colors'), true);
      expect(easyModules.any((m) => m.id == 'family'), true);
      
      final mediumModules = moduleManager.getModulesByDifficulty(2);
      expect(mediumModules.length, 3); // animals, jobs, farm
      expect(mediumModules.any((m) => m.id == 'animals'), true);
      expect(mediumModules.any((m) => m.id == 'jobs'), true);
      expect(mediumModules.any((m) => m.id == 'farm'), true);
    });

    test('should update module data', () async {
      await moduleManager.init();
      
      final updates = {
        'name': 'Updated Shapes',
        'description': 'Updated description',
        'difficultyLevel': 2,
        'isUnlocked': true,
      };
      
      await moduleManager.updateModule('shapes', updates);
      
      final updatedModule = moduleManager.getModuleById('shapes');
      expect(updatedModule!.name, 'Updated Shapes');
      expect(updatedModule.description, 'Updated description');
      expect(updatedModule.difficultyLevel, 2);
      expect(updatedModule.isUnlocked, true);
    });

    test('should register new module', () async {
      await moduleManager.init();
      
      final newModule = GameModule(
        id: 'test_module',
        name: 'Test Module',
        description: 'A test module',
        iconPath: 'test_icon.png',
        backgroundPath: 'test_background.png',
        cardPaths: ['card1.png', 'card2.png'],
        isUnlocked: false,
        difficultyLevel: 1,
        audioPaths: ['audio1.mp3'],
        category: 'Test',
        ageRangeMin: 3,
        ageRangeMax: 6,
      );
      
      await moduleManager.registerModule(newModule);
      
      expect(moduleManager.modules.length, 7);
      expect(moduleManager.getModuleById('test_module'), isNotNull);
    });

    test('should clear all modules', () async {
      await moduleManager.init();
      expect(moduleManager.modules.length, 6);
      
      await moduleManager.clearAllModules();
      
      expect(moduleManager.modules.length, 0);
      expect(moduleManager.currentModule, null);
    });

    test('should handle rapid module operations', () async {
      await moduleManager.init();
      
      // Rapid unlock/lock operations
      for (int i = 0; i < 10; i++) {
        await moduleManager.unlockModule('animals');
        await moduleManager.lockModule('animals');
      }
      
      final animalsModule = moduleManager.getModuleById('animals');
      expect(animalsModule!.isUnlocked, false); // Final state should be locked
    });

    test('should maintain module order after operations', () async {
      await moduleManager.init();
      
      final originalOrder = moduleManager.modules.map((m) => m.id).toList();
      
      await moduleManager.unlockModule('animals');
      await moduleManager.lockModule('animals');
      
      final newOrder = moduleManager.modules.map((m) => m.id).toList();
      expect(newOrder, originalOrder);
    });
  });
}