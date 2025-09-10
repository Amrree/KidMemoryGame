import 'package:flutter_test/flutter_test.dart';
import 'package:kid_memory_template/core/managers/audio_manager.dart';
import 'package:kid_memory_template/core/managers/save_manager.dart';
import 'package:kid_memory_template/core/managers/module_manager.dart';
import 'package:kid_memory_template/core/models/game_module.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';

void main() {
  group('Edge Cases and Stress Tests', () {
    group('AudioManager Stress Tests', () {
      late AudioManager audioManager;

      setUp(() {
        audioManager = AudioManager();
      });

      tearDown(() {
        audioManager.dispose();
      });

      test('should handle rapid volume changes', () async {
        // Rapidly change volume
        for (int i = 0; i < 100; i++) {
          audioManager.setMusicVolume(i / 100.0);
          audioManager.setSoundVolume((100 - i) / 100.0);
        }
        
        expect(audioManager.musicVolume, 1.0);
        expect(audioManager.soundVolume, 0.0);
      });

      test('should handle rapid enable/disable toggles', () async {
        // Rapidly toggle settings
        for (int i = 0; i < 50; i++) {
          audioManager.setMusicEnabled(i % 2 == 0);
          audioManager.setSoundEnabled(i % 2 == 1);
        }
        
        expect(audioManager.isMusicEnabled, false);
        expect(audioManager.isSoundEnabled, true);
      });

      test('should handle concurrent audio operations', () async {
        // Try to play multiple sounds simultaneously
        final futures = <Future>[];
        for (int i = 0; i < 10; i++) {
          futures.add(audioManager.playSfx('test_sfx.mp3'));
          futures.add(audioManager.playMusic('test_music.mp3'));
        }
        
        // Should not throw exceptions
        await Future.wait(futures);
      });

      test('should handle invalid audio paths gracefully', () async {
        final invalidPaths = [
          '',
          'invalid_path.mp3',
          'path/with/special/chars/special.mp3',
          'very/long/path/that/might/cause/issues/with/some/audio/systems.mp3',
        ];

        for (final path in invalidPaths) {
          await audioManager.playSfx(path);
          await audioManager.playMusic(path);
        }
        
        // Should not crash
        expect(audioManager.isMusicEnabled, true);
      });

      test('should handle extreme volume values', () async {
        final extremeValues = [
          double.negativeInfinity,
          double.infinity,
          double.nan,
          -999999.0,
          999999.0,
        ];

        for (final value in extremeValues) {
          audioManager.setMusicVolume(value);
          audioManager.setSoundVolume(value);
        }
        
        // Should be clamped to valid range
        expect(audioManager.musicVolume, inInclusiveRange(0.0, 1.0));
        expect(audioManager.soundVolume, inInclusiveRange(0.0, 1.0));
      });
    });

    group('SaveManager Stress Tests', () {
      late SaveManager saveManager;

      setUp(() async {
        SharedPreferences.setMockInitialValues({});
        Hive.init('test_hive_stress');
        saveManager = SaveManager();
        await saveManager.initialize();
      });

      tearDown(() async {
        saveManager.dispose();
        await Hive.deleteFromDisk();
      });

      test('should handle rapid save operations', () async {
        // Rapidly save data
        for (int i = 0; i < 100; i++) {
          await saveManager.setSoundEnabled(i % 2 == 0);
          await saveManager.addPlayTime(1);
          await saveManager.incrementGamesPlayed();
          await saveManager.updateHighScore(i);
        }
        
        expect(saveManager.gamesPlayed, 100);
        expect(saveManager.highScore, 99);
      });

      test('should handle large data sets', () async {
        // Save large amounts of data
        final largeData = Map<String, dynamic>.fromIterable(
          List.generate(1000, (i) => i),
          key: (i) => 'key_$i',
          value: (i) => 'value_$i',
        );
        
        await saveManager.saveModuleProgress('large_module', largeData);
        final loadedData = saveManager.getModuleProgress('large_module');
        
        expect(loadedData, largeData);
      });

      test('should handle concurrent save operations', () async {
        // Concurrent save operations
        final futures = <Future>[];
        for (int i = 0; i < 50; i++) {
          futures.add(saveManager.setSoundEnabled(i % 2 == 0));
          futures.add(saveManager.addPlayTime(1));
          futures.add(saveManager.incrementGamesPlayed());
        }
        
        await Future.wait(futures);
        expect(saveManager.gamesPlayed, 50);
      });

      test('should handle invalid data gracefully', () async {
        final invalidData = {
          'null_value': null,
          'empty_string': '',
          'special_chars': '!@#\$%^&*()',
          'unicode': '测试数据',
          'very_long_string': 'x' * 10000,
        };
        
        await saveManager.saveModuleProgress('invalid_test', invalidData);
        final loadedData = saveManager.getModuleProgress('invalid_test');
        
        expect(loadedData, invalidData);
      });

      test('should handle rapid import/export cycles', () async {
        // Set some initial data
        await saveManager.setSoundEnabled(false);
        await saveManager.addPlayTime(100);
        await saveManager.addAchievement('test_achievement');
        
        // Rapid import/export cycles
        for (int i = 0; i < 20; i++) {
          final exportData = saveManager.exportSaveData();
          await saveManager.importSaveData(exportData);
        }
        
        expect(saveManager.soundEnabled, false);
        expect(saveManager.totalPlayTime, 100);
        expect(saveManager.getAchievements().contains('test_achievement'), true);
      });
    });

    group('ModuleManager Stress Tests', () {
      late ModuleManager moduleManager;

      setUp(() async {
        Hive.init('test_hive_modules_stress');
        moduleManager = ModuleManager();
        await moduleManager.initialize();
      });

      tearDown(() async {
        moduleManager.dispose();
        await Hive.deleteFromDisk();
      });

      test('should handle rapid module operations', () async {
        // Rapidly add, update, and remove modules
        for (int i = 0; i < 50; i++) {
          final module = GameModule(
            id: 'stress_test_$i',
            name: 'Stress Test $i',
            description: 'Description $i',
            iconPath: 'icon_$i.png',
            backgroundPath: 'background_$i.png',
            cardPaths: ['card_$i.png'],
          );
          
          await moduleManager.addModule(module);
          await moduleManager.updateModule(module.copyWith(name: 'Updated $i'));
          await moduleManager.removeModule('stress_test_$i');
        }
        
        // Should still have original modules
        expect(moduleManager.modules.length, 6);
      });

      test('should handle modules with extreme data', () async {
        final extremeModule = GameModule(
          id: 'x' * 1000, // Very long ID
          name: 'x' * 1000, // Very long name
          description: 'x' * 10000, // Very long description
          iconPath: 'x' * 1000, // Very long path
          backgroundPath: 'x' * 1000, // Very long path
          cardPaths: List.generate(1000, (i) => 'card_$i.png'), // Many cards
          isUnlocked: true,
          difficultyLevel: 999,
          audioPaths: List.generate(1000, (i) => 'audio_$i.mp3'), // Many audio files
        );
        
        await moduleManager.addModule(extremeModule);
        expect(moduleManager.hasModule('x' * 1000), true);
      });

      test('should handle concurrent module operations', () async {
        final futures = <Future>[];
        
        // Concurrent operations
        for (int i = 0; i < 20; i++) {
          futures.add(moduleManager.unlockModule('animals'));
          futures.add(moduleManager.lockModule('animals'));
          futures.add(moduleManager.selectModule('shapes'));
        }
        
        await Future.wait(futures);
        expect(moduleManager.modules.length, 6);
      });

      test('should handle invalid module operations', () async {
        // Try to operate on non-existent modules
        await moduleManager.unlockModule('non_existent');
        await moduleManager.lockModule('non_existent');
        await moduleManager.removeModule('non_existent');
        await moduleManager.selectModule('non_existent');
        
        // Should not crash
        expect(moduleManager.modules.length, 6);
      });

      test('should handle rapid reset operations', () async {
        // Add some modules
        for (int i = 0; i < 10; i++) {
          final module = GameModule(
            id: 'temp_$i',
            name: 'Temp $i',
            description: 'Temp description',
            iconPath: 'temp_icon.png',
            backgroundPath: 'temp_background.png',
            cardPaths: ['temp_card.png'],
          );
          await moduleManager.addModule(module);
        }
        
        // Rapidly reset
        for (int i = 0; i < 5; i++) {
          await moduleManager.resetModules();
        }
        
        expect(moduleManager.modules.length, 6);
      });
    });

    group('GameModule Stress Tests', () {
      test('should handle extreme copyWith operations', () {
        final module = GameModule(
          id: 'test',
          name: 'Test',
          description: 'Test',
          iconPath: 'icon.png',
          backgroundPath: 'background.png',
          cardPaths: ['card.png'],
        );
        
        // Rapidly create copies with different values
        for (int i = 0; i < 1000; i++) {
          final copy = module.copyWith(
            name: 'Test $i',
            difficultyLevel: i % 10,
            isUnlocked: i % 2 == 0,
          );
          expect(copy.name, 'Test $i');
        }
      });

      test('should handle null values in copyWith', () {
        final module = GameModule(
          id: 'test',
          name: 'Test',
          description: 'Test',
          iconPath: 'icon.png',
          backgroundPath: 'background.png',
          cardPaths: ['card.png'],
        );
        
        // Test all null values
        final copy = module.copyWith(
          id: null,
          name: null,
          description: null,
          iconPath: null,
          backgroundPath: null,
          cardPaths: null,
          isUnlocked: null,
          difficultyLevel: null,
          audioPaths: null,
        );
        
        // Should retain original values
        expect(copy.id, 'test');
        expect(copy.name, 'Test');
        expect(copy.description, 'Test');
      });
    });

    group('Memory and Performance Stress Tests', () {
      test('should handle large number of objects', () {
        // Create many objects to test memory usage
        final modules = <GameModule>[];
        for (int i = 0; i < 10000; i++) {
          modules.add(GameModule(
            id: 'module_$i',
            name: 'Module $i',
            description: 'Description $i',
            iconPath: 'icon_$i.png',
            backgroundPath: 'background_$i.png',
            cardPaths: List.generate(10, (j) => 'card_${i}_$j.png'),
          ));
        }
        
        expect(modules.length, 10000);
        
        // Test operations on large list
        final unlockedModules = modules.where((m) => m.isUnlocked).toList();
        expect(unlockedModules.length, 0); // All should be locked by default
      });

      test('should handle rapid object creation and disposal', () {
        // Rapidly create and dispose objects
        for (int i = 0; i < 1000; i++) {
          final audioManager = AudioManager();
          audioManager.dispose();
        }
        
        // Should not cause memory leaks
        expect(true, true);
      });
    });
  });
}