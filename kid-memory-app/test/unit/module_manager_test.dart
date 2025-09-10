import 'package:flutter_test/flutter_test.dart';
import 'package:kid_memory_template/core/managers/module_manager.dart';
import 'package:kid_memory_template/core/models/game_module.dart';
import 'package:hive/hive.dart';

void main() {
  group('ModuleManager Tests', () {
    late ModuleManager moduleManager;

    setUp(() async {
      // Initialize Hive for testing
      Hive.init('test_hive');
      
      moduleManager = ModuleManager();
      await moduleManager.initialize();
    });

    tearDown(() async {
      moduleManager.dispose();
      await Hive.deleteFromDisk();
    });

    test('should initialize with default modules', () {
      expect(moduleManager.modules.length, 6);
      expect(moduleManager.modules.any((m) => m.id == 'shapes'), true);
      expect(moduleManager.modules.any((m) => m.id == 'colors'), true);
      expect(moduleManager.modules.any((m) => m.id == 'animals'), true);
      expect(moduleManager.modules.any((m) => m.id == 'jobs'), true);
      expect(moduleManager.modules.any((m) => m.id == 'farm'), true);
      expect(moduleManager.modules.any((m) => m.id == 'family'), true);
    });

    test('should have shapes and colors unlocked by default', () {
      final unlockedModules = moduleManager.getUnlockedModules();
      expect(unlockedModules.length, 2);
      expect(unlockedModules.any((m) => m.id == 'shapes'), true);
      expect(unlockedModules.any((m) => m.id == 'colors'), true);
    });

    test('should have other modules locked by default', () {
      final lockedModules = moduleManager.getLockedModules();
      expect(lockedModules.length, 4);
      expect(lockedModules.any((m) => m.id == 'animals'), true);
      expect(lockedModules.any((m) => m.id == 'jobs'), true);
      expect(lockedModules.any((m) => m.id == 'farm'), true);
      expect(lockedModules.any((m) => m.id == 'family'), true);
    });

    test('should select unlocked module', () {
      moduleManager.selectModule('shapes');
      expect(moduleManager.selectedModuleId, 'shapes');
      expect(moduleManager.selectedModule?.id, 'shapes');
    });

    test('should not select locked module', () {
      moduleManager.selectModule('animals');
      expect(moduleManager.selectedModuleId, null);
      expect(moduleManager.selectedModule, null);
    });

    test('should unlock module', () async {
      await moduleManager.unlockModule('animals');
      expect(moduleManager.getModuleById('animals')?.isUnlocked, true);
      
      // Should be able to select after unlocking
      moduleManager.selectModule('animals');
      expect(moduleManager.selectedModuleId, 'animals');
    });

    test('should lock module', () async {
      // First unlock
      await moduleManager.unlockModule('animals');
      expect(moduleManager.getModuleById('animals')?.isUnlocked, true);
      
      // Then lock
      await moduleManager.lockModule('animals');
      expect(moduleManager.getModuleById('animals')?.isUnlocked, false);
    });

    test('should get modules by difficulty level', () {
      final level1Modules = moduleManager.getModulesByDifficulty(1);
      expect(level1Modules.length, 2);
      expect(level1Modules.any((m) => m.id == 'shapes'), true);
      expect(level1Modules.any((m) => m.id == 'colors'), true);

      final level2Modules = moduleManager.getModulesByDifficulty(2);
      expect(level2Modules.length, 2);
      expect(level2Modules.any((m) => m.id == 'animals'), true);
      expect(level2Modules.any((m) => m.id == 'jobs'), true);

      final level3Modules = moduleManager.getModulesByDifficulty(3);
      expect(level3Modules.length, 2);
      expect(level3Modules.any((m) => m.id == 'farm'), true);
      expect(level3Modules.any((m) => m.id == 'family'), true);
    });

    test('should add custom module', () async {
      final customModule = GameModule(
        id: 'custom',
        name: 'Custom Module',
        description: 'A custom test module',
        iconPath: 'assets/custom/icon.png',
        backgroundPath: 'assets/custom/background.png',
        cardPaths: ['card1.png', 'card2.png'],
        isUnlocked: true,
        difficultyLevel: 1,
        audioPaths: ['audio1.mp3'],
      );

      await moduleManager.addModule(customModule);
      expect(moduleManager.modules.length, 7);
      expect(moduleManager.hasModule('custom'), true);
      expect(moduleManager.getModuleById('custom'), customModule);
    });

    test('should remove module', () async {
      await moduleManager.removeModule('shapes');
      expect(moduleManager.modules.length, 5);
      expect(moduleManager.hasModule('shapes'), false);
      expect(moduleManager.getModuleById('shapes'), null);
    });

    test('should update module', () async {
      final shapesModule = moduleManager.getModuleById('shapes')!;
      final updatedModule = shapesModule.copyWith(
        name: 'Updated Shapes',
        difficultyLevel: 2,
      );

      await moduleManager.updateModule(updatedModule);
      
      final retrievedModule = moduleManager.getModuleById('shapes');
      expect(retrievedModule?.name, 'Updated Shapes');
      expect(retrievedModule?.difficultyLevel, 2);
    });

    test('should handle non-existent module operations gracefully', () {
      expect(moduleManager.hasModule('non_existent'), false);
      expect(moduleManager.getModuleById('non_existent'), null);
    });

    test('should reset modules to default state', () async {
      // Add a custom module
      final customModule = GameModule(
        id: 'custom',
        name: 'Custom',
        description: 'Custom',
        iconPath: 'icon.png',
        backgroundPath: 'background.png',
        cardPaths: ['card.png'],
      );
      await moduleManager.addModule(customModule);
      expect(moduleManager.modules.length, 7);

      // Reset
      await moduleManager.resetModules();
      expect(moduleManager.modules.length, 6);
      expect(moduleManager.hasModule('custom'), false);
      expect(moduleManager.selectedModuleId, null);
    });

    test('should clear selected module when removed', () async {
      moduleManager.selectModule('shapes');
      expect(moduleManager.selectedModuleId, 'shapes');

      await moduleManager.removeModule('shapes');
      expect(moduleManager.selectedModuleId, null);
    });

    test('should handle module selection edge cases', () {
      // Try to select non-existent module
      moduleManager.selectModule('non_existent');
      expect(moduleManager.selectedModuleId, null);

      // Try to select locked module
      moduleManager.selectModule('animals');
      expect(moduleManager.selectedModuleId, null);
    });

    test('should maintain module order after operations', () async {
      final originalOrder = moduleManager.modules.map((m) => m.id).toList();
      
      // Unlock a module
      await moduleManager.unlockModule('animals');
      
      // Order should be maintained
      final newOrder = moduleManager.modules.map((m) => m.id).toList();
      expect(newOrder, originalOrder);
    });
  });
}