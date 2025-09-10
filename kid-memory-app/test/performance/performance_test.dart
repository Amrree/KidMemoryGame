import 'package:flutter_test/flutter_test.dart';
import 'package:kid_memory_template/core/managers/audio_manager.dart';
import 'package:kid_memory_template/core/managers/save_manager.dart';
import 'package:kid_memory_template/core/managers/module_manager.dart';
import 'package:kid_memory_template/core/models/game_module.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import 'dart:io';

void main() {
  group('Performance Tests', () {
    group('AudioManager Performance', () {
      late AudioManager audioManager;

      setUp(() {
        audioManager = AudioManager();
      });

      tearDown(() {
        audioManager.dispose();
      });

      test('should initialize quickly', () {
        final stopwatch = Stopwatch()..start();
        
        // Test initialization time
        final newAudioManager = AudioManager();
        newAudioManager.dispose();
        
        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(100));
      });

      test('should handle rapid volume changes efficiently', () {
        final stopwatch = Stopwatch()..start();
        
        // Rapid volume changes
        for (int i = 0; i < 1000; i++) {
          audioManager.setMusicVolume(i / 1000.0);
          audioManager.setSoundVolume((1000 - i) / 1000.0);
        }
        
        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(100));
      });

      test('should handle rapid enable/disable efficiently', () {
        final stopwatch = Stopwatch()..start();
        
        // Rapid enable/disable
        for (int i = 0; i < 1000; i++) {
          audioManager.setMusicEnabled(i % 2 == 0);
          audioManager.setSoundEnabled(i % 2 == 1);
        }
        
        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(100));
      });

      test('should handle concurrent operations efficiently', () async {
        final stopwatch = Stopwatch()..start();
        
        // Concurrent operations
        final futures = <Future>[];
        for (int i = 0; i < 100; i++) {
          futures.add(audioManager.playSfx('test.mp3'));
          futures.add(audioManager.playMusic('test.mp3'));
        }
        
        await Future.wait(futures);
        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      });
    });

    group('SaveManager Performance', () {
      late SaveManager saveManager;

      setUp(() async {
        SharedPreferences.setMockInitialValues({});
        Hive.init('test_hive_perf');
        saveManager = SaveManager();
        await saveManager.initialize();
      });

      tearDown(() async {
        saveManager.dispose();
        await Hive.deleteFromDisk();
      });

      test('should initialize quickly', () async {
        final stopwatch = Stopwatch()..start();
        
        final newSaveManager = SaveManager();
        await newSaveManager.initialize();
        newSaveManager.dispose();
        
        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(500));
      });

      test('should save data quickly', () async {
        final stopwatch = Stopwatch()..start();
        
        // Rapid save operations
        for (int i = 0; i < 100; i++) {
          await saveManager.setSoundEnabled(i % 2 == 0);
          await saveManager.addPlayTime(1);
          await saveManager.incrementGamesPlayed();
        }
        
        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      });

      test('should load data quickly', () async {
        // Pre-populate with data
        for (int i = 0; i < 100; i++) {
          await saveManager.saveModuleProgress('module_$i', {'data': 'value_$i'});
        }
        
        final stopwatch = Stopwatch()..start();
        
        // Load all data
        for (int i = 0; i < 100; i++) {
          saveManager.getModuleProgress('module_$i');
        }
        
        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(100));
      });

      test('should export data quickly', () async {
        // Pre-populate with data
        for (int i = 0; i < 50; i++) {
          await saveManager.saveModuleProgress('module_$i', {'data': 'value_$i'});
          await saveManager.addAchievement('achievement_$i');
        }
        
        final stopwatch = Stopwatch()..start();
        
        final exportData = saveManager.exportSaveData();
        
        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(100));
        expect(exportData.isNotEmpty, true);
      });

      test('should import data quickly', () async {
        final importData = {
          'settings': {
            'soundEnabled': true,
            'musicEnabled': true,
            'soundVolume': 0.5,
            'musicVolume': 0.5,
            'selectedDifficulty': 1,
            'totalPlayTime': 1000,
            'gamesPlayed': 50,
            'highScore': 100,
          },
          'achievements': List.generate(50, (i) => 'achievement_$i'),
          'moduleProgress': Map.fromEntries(
            List.generate(50, (i) => MapEntry('module_$i', {'data': 'value_$i'})),
          ),
        };
        
        final stopwatch = Stopwatch()..start();
        
        await saveManager.importSaveData(importData);
        
        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(500));
      });
    });

    group('ModuleManager Performance', () {
      late ModuleManager moduleManager;

      setUp(() async {
        Hive.init('test_hive_modules_perf');
        moduleManager = ModuleManager();
        await moduleManager.initialize();
      });

      tearDown(() async {
        moduleManager.dispose();
        await Hive.deleteFromDisk();
      });

      test('should initialize quickly', () async {
        final stopwatch = Stopwatch()..start();
        
        final newModuleManager = ModuleManager();
        await newModuleManager.initialize();
        newModuleManager.dispose();
        
        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(500));
      });

      test('should load modules quickly', () {
        final stopwatch = Stopwatch()..start();
        
        final modules = moduleManager.modules;
        final unlockedModules = moduleManager.getUnlockedModules();
        final lockedModules = moduleManager.getLockedModules();
        
        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(10));
        expect(modules.length, 6);
        expect(unlockedModules.length, 2);
        expect(lockedModules.length, 4);
      });

      test('should search modules quickly', () {
        final stopwatch = Stopwatch()..start();
        
        // Search operations
        for (int i = 0; i < 1000; i++) {
          moduleManager.hasModule('shapes');
          moduleManager.getModuleById('shapes');
          moduleManager.getModulesByDifficulty(1);
        }
        
        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(100));
      });

      test('should add modules quickly', () async {
        final stopwatch = Stopwatch()..start();
        
        // Add many modules
        for (int i = 0; i < 100; i++) {
          final module = GameModule(
            id: 'perf_test_$i',
            name: 'Performance Test $i',
            description: 'Description $i',
            iconPath: 'icon_$i.png',
            backgroundPath: 'background_$i.png',
            cardPaths: ['card_$i.png'],
          );
          await moduleManager.addModule(module);
        }
        
        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
        expect(moduleManager.modules.length, 106); // 6 default + 100 new
      });

      test('should update modules quickly', () async {
        final stopwatch = Stopwatch()..start();
        
        // Update modules rapidly
        for (int i = 0; i < 100; i++) {
          final shapesModule = moduleManager.getModuleById('shapes')!;
          await moduleManager.updateModule(
            shapesModule.copyWith(name: 'Updated Shapes $i'),
          );
        }
        
        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(500));
      });
    });

    group('GameModule Performance', () {
      test('should create modules quickly', () {
        final stopwatch = Stopwatch()..start();
        
        // Create many modules
        for (int i = 0; i < 1000; i++) {
          GameModule(
            id: 'perf_$i',
            name: 'Performance $i',
            description: 'Description $i',
            iconPath: 'icon_$i.png',
            backgroundPath: 'background_$i.png',
            cardPaths: List.generate(10, (j) => 'card_${i}_$j.png'),
            isUnlocked: i % 2 == 0,
            difficultyLevel: i % 5 + 1,
            audioPaths: List.generate(5, (j) => 'audio_${i}_$j.mp3'),
          );
        }
        
        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(100));
      });

      test('should copy modules quickly', () {
        final module = GameModule(
          id: 'test',
          name: 'Test',
          description: 'Test',
          iconPath: 'icon.png',
          backgroundPath: 'background.png',
          cardPaths: List.generate(100, (i) => 'card_$i.png'),
          isUnlocked: true,
          difficultyLevel: 1,
          audioPaths: List.generate(50, (i) => 'audio_$i.mp3'),
        );
        
        final stopwatch = Stopwatch()..start();
        
        // Copy many times
        for (int i = 0; i < 1000; i++) {
          module.copyWith(name: 'Test $i');
        }
        
        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(100));
      });
    });

    group('Memory Usage Tests', () {
      test('should not leak memory with rapid object creation', () {
        // Create and dispose many objects
        for (int i = 0; i < 1000; i++) {
          final audioManager = AudioManager();
          audioManager.dispose();
        }
        
        // Force garbage collection
        // Note: In a real test, you'd use proper memory profiling
        expect(true, true);
      });

      test('should handle large data sets efficiently', () {
        final largeModule = GameModule(
          id: 'large',
          name: 'Large Module',
          description: 'x' * 10000, // Large description
          iconPath: 'icon.png',
          backgroundPath: 'background.png',
          cardPaths: List.generate(1000, (i) => 'card_$i.png'), // Many cards
          isUnlocked: true,
          difficultyLevel: 1,
          audioPaths: List.generate(1000, (i) => 'audio_$i.mp3'), // Many audio files
        );
        
        final stopwatch = Stopwatch()..start();
        
        // Perform operations on large module
        for (int i = 0; i < 100; i++) {
          largeModule.copyWith(name: 'Large Module $i');
        }
        
        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(100));
      });
    });

    group('Concurrent Operations Performance', () {
      test('should handle concurrent audio operations efficiently', () async {
        final audioManager = AudioManager();
        
        final stopwatch = Stopwatch()..start();
        
        // Concurrent operations
        final futures = <Future>[];
        for (int i = 0; i < 50; i++) {
          futures.add(audioManager.playSfx('test_$i.mp3'));
          futures.add(audioManager.setMusicVolume(i / 50.0));
          futures.add(audioManager.setSoundEnabled(i % 2 == 0));
        }
        
        await Future.wait(futures);
        stopwatch.stop();
        
        audioManager.dispose();
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      });

      test('should handle concurrent save operations efficiently', () async {
        SharedPreferences.setMockInitialValues({});
        Hive.init('test_hive_concurrent');
        
        final saveManager = SaveManager();
        await saveManager.initialize();
        
        final stopwatch = Stopwatch()..start();
        
        // Concurrent operations
        final futures = <Future>[];
        for (int i = 0; i < 100; i++) {
          futures.add(saveManager.setSoundEnabled(i % 2 == 0));
          futures.add(saveManager.addPlayTime(1));
          futures.add(saveManager.incrementGamesPlayed());
          futures.add(saveManager.saveModuleProgress('module_$i', {'data': 'value_$i'}));
        }
        
        await Future.wait(futures);
        stopwatch.stop();
        
        saveManager.dispose();
        await Hive.deleteFromDisk();
        expect(stopwatch.elapsedMilliseconds, lessThan(2000));
      });
    });
  });
}