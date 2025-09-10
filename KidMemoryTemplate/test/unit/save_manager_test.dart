import 'package:flutter_test/flutter_test.dart';
import 'package:kid_memory_template/core/managers/save_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';

void main() {
  group('SaveManager Tests', () {
    late SaveManager saveManager;

    setUp(() async {
      // Mock SharedPreferences
      SharedPreferences.setMockInitialValues({});
      
      // Initialize Hive for testing
      Hive.init('test_hive');
      
      saveManager = SaveManager();
      await saveManager.initialize();
    });

    tearDown(() async {
      saveManager.dispose();
      await Hive.deleteFromDisk();
    });

    test('should initialize with default values', () {
      expect(saveManager.soundEnabled, true);
      expect(saveManager.musicEnabled, true);
      expect(saveManager.soundVolume, 1.0);
      expect(saveManager.musicVolume, 0.7);
      expect(saveManager.selectedDifficulty, 1);
      expect(saveManager.lastPlayedModule, null);
      expect(saveManager.totalPlayTime, 0);
      expect(saveManager.gamesPlayed, 0);
      expect(saveManager.highScore, 0);
    });

    test('should set sound enabled/disabled', () async {
      await saveManager.setSoundEnabled(false);
      expect(saveManager.soundEnabled, false);

      await saveManager.setSoundEnabled(true);
      expect(saveManager.soundEnabled, true);
    });

    test('should set music enabled/disabled', () async {
      await saveManager.setMusicEnabled(false);
      expect(saveManager.musicEnabled, false);

      await saveManager.setMusicEnabled(true);
      expect(saveManager.musicEnabled, true);
    });

    test('should set sound volume with clamping', () async {
      await saveManager.setSoundVolume(-0.5);
      expect(saveManager.soundVolume, 0.0);

      await saveManager.setSoundVolume(1.5);
      expect(saveManager.soundVolume, 1.0);

      await saveManager.setSoundVolume(0.5);
      expect(saveManager.soundVolume, 0.5);
    });

    test('should set music volume with clamping', () async {
      await saveManager.setMusicVolume(-0.5);
      expect(saveManager.musicVolume, 0.0);

      await saveManager.setMusicVolume(1.5);
      expect(saveManager.musicVolume, 1.0);

      await saveManager.setMusicVolume(0.5);
      expect(saveManager.musicVolume, 0.5);
    });

    test('should set selected difficulty', () async {
      await saveManager.setSelectedDifficulty(3);
      expect(saveManager.selectedDifficulty, 3);
    });

    test('should set last played module', () async {
      await saveManager.setLastPlayedModule('shapes');
      expect(saveManager.lastPlayedModule, 'shapes');
    });

    test('should add play time', () async {
      await saveManager.addPlayTime(60);
      expect(saveManager.totalPlayTime, 60);

      await saveManager.addPlayTime(30);
      expect(saveManager.totalPlayTime, 90);
    });

    test('should increment games played', () async {
      await saveManager.incrementGamesPlayed();
      expect(saveManager.gamesPlayed, 1);

      await saveManager.incrementGamesPlayed();
      expect(saveManager.gamesPlayed, 2);
    });

    test('should update high score only when higher', () async {
      await saveManager.updateHighScore(100);
      expect(saveManager.highScore, 100);

      await saveManager.updateHighScore(50);
      expect(saveManager.highScore, 100); // Should not change

      await saveManager.updateHighScore(150);
      expect(saveManager.highScore, 150); // Should update
    });

    test('should save and load module progress', () async {
      final progress = {'level': 2, 'completed': true, 'score': 100};
      await saveManager.saveModuleProgress('test_module', progress);
      
      final loadedProgress = saveManager.getModuleProgress('test_module');
      expect(loadedProgress, progress);
    });

    test('should save and load game state', () async {
      final gameState = {'cards': ['card1', 'card2'], 'moves': 5};
      await saveManager.saveGameState(gameState);
      
      final loadedState = saveManager.getGameState();
      expect(loadedState, gameState);
    });

    test('should clear game state', () async {
      final gameState = {'cards': ['card1', 'card2']};
      await saveManager.saveGameState(gameState);
      await saveManager.clearGameState();
      
      final loadedState = saveManager.getGameState();
      expect(loadedState, null);
    });

    test('should save and load achievements', () async {
      final achievements = ['first_win', 'perfect_game'];
      await saveManager.saveAchievements(achievements);
      
      final loadedAchievements = saveManager.getAchievements();
      expect(loadedAchievements, achievements);
    });

    test('should add achievement without duplicates', () async {
      await saveManager.addAchievement('first_win');
      await saveManager.addAchievement('first_win'); // Duplicate
      await saveManager.addAchievement('perfect_game');
      
      final achievements = saveManager.getAchievements();
      expect(achievements.length, 2);
      expect(achievements.contains('first_win'), true);
      expect(achievements.contains('perfect_game'), true);
    });

    test('should get player statistics', () {
      final stats = saveManager.getPlayerStats();
      expect(stats, isA<Map<String, dynamic>>());
      expect(stats.containsKey('totalPlayTime'), true);
      expect(stats.containsKey('gamesPlayed'), true);
      expect(stats.containsKey('highScore'), true);
      expect(stats.containsKey('achievements'), true);
    });

    test('should export save data', () {
      final exportData = saveManager.exportSaveData();
      expect(exportData, isA<Map<String, dynamic>>());
      expect(exportData.containsKey('settings'), true);
      expect(exportData.containsKey('achievements'), true);
      expect(exportData.containsKey('moduleProgress'), true);
    });

    test('should import save data', () async {
      final importData = {
        'settings': {
          'soundEnabled': false,
          'musicEnabled': false,
          'soundVolume': 0.5,
          'musicVolume': 0.3,
          'selectedDifficulty': 2,
          'lastPlayedModule': 'colors',
          'totalPlayTime': 300,
          'gamesPlayed': 5,
          'highScore': 200,
        },
        'achievements': ['test_achievement'],
        'moduleProgress': {'module_test': {'level': 1}},
      };

      await saveManager.importSaveData(importData);
      
      expect(saveManager.soundEnabled, false);
      expect(saveManager.musicEnabled, false);
      expect(saveManager.soundVolume, 0.5);
      expect(saveManager.musicVolume, 0.3);
      expect(saveManager.selectedDifficulty, 2);
      expect(saveManager.lastPlayedModule, 'colors');
      expect(saveManager.totalPlayTime, 300);
      expect(saveManager.gamesPlayed, 5);
      expect(saveManager.highScore, 200);
      expect(saveManager.getAchievements().contains('test_achievement'), true);
    });

    test('should reset all data', () async {
      // Set some data
      await saveManager.setSoundEnabled(false);
      await saveManager.addPlayTime(100);
      await saveManager.addAchievement('test');
      
      // Reset
      await saveManager.resetAllData();
      
      // Should be back to defaults
      expect(saveManager.soundEnabled, true);
      expect(saveManager.totalPlayTime, 0);
      expect(saveManager.getAchievements().isEmpty, true);
    });
  });
}