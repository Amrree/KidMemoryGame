import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kidsgame/core/managers/save_manager.dart';
import 'package:kidsgame/core/models/game_module.dart';

void main() {
  group('SaveManager Unit Tests', () {
    late SaveManager saveManager;

    setUp(() async {
      // Initialize Hive for testing
      await Hive.initFlutter();
      Hive.registerAdapter(GameModuleAdapter());
      Hive.registerAdapter(GameSessionAdapter());
      saveManager = SaveManager();
    });

    tearDown(() async {
      await saveManager.dispose();
      await Hive.deleteFromDisk();
    });

    test('should initialize with default values', () async {
      await saveManager.init();
      
      expect(saveManager.totalGamesPlayed, 0);
      expect(saveManager.totalScore, 0);
      expect(saveManager.highScore, 0);
      expect(saveManager.totalPlayTime, 0);
      expect(saveManager.moduleScores, isEmpty);
      expect(saveManager.modulePlayCounts, isEmpty);
      expect(saveManager.unlockedModules, isEmpty);
      expect(saveManager.userSettings, isEmpty);
    });

    test('should update high score', () async {
      await saveManager.init();
      
      saveManager.updateHighScore(100);
      expect(saveManager.highScore, 100);
      
      saveManager.updateHighScore(50); // Should not update
      expect(saveManager.highScore, 100);
      
      saveManager.updateHighScore(150); // Should update
      expect(saveManager.highScore, 150);
    });

    test('should update module high score', () async {
      await saveManager.init();
      
      saveManager.updateModuleHighScore('shapes', 50);
      expect(saveManager.getModuleHighScore('shapes'), 50);
      
      saveManager.updateModuleHighScore('shapes', 30); // Should not update
      expect(saveManager.getModuleHighScore('shapes'), 50);
      
      saveManager.updateModuleHighScore('shapes', 80); // Should update
      expect(saveManager.getModuleHighScore('shapes'), 80);
    });

    test('should increment games played', () async {
      await saveManager.init();
      
      expect(saveManager.totalGamesPlayed, 0);
      
      saveManager.incrementGamesPlayed();
      expect(saveManager.totalGamesPlayed, 1);
      
      saveManager.incrementGamesPlayed();
      expect(saveManager.totalGamesPlayed, 2);
    });

    test('should add play time', () async {
      await saveManager.init();
      
      expect(saveManager.totalPlayTime, 0);
      
      saveManager.addPlayTime(60); // 1 minute
      expect(saveManager.totalPlayTime, 60);
      
      saveManager.addPlayTime(120); // 2 minutes
      expect(saveManager.totalPlayTime, 180);
    });

    test('should unlock module', () async {
      await saveManager.init();
      
      expect(saveManager.isModuleUnlocked('animals'), false);
      
      saveManager.unlockModule('animals');
      expect(saveManager.isModuleUnlocked('animals'), true);
      
      // Should not duplicate
      saveManager.unlockModule('animals');
      expect(saveManager.unlockedModules.length, 1);
    });

    test('should get module play count', () async {
      await saveManager.init();
      
      expect(saveManager.getModulePlayCount('shapes'), 0);
      
      // Simulate playing shapes module
      saveManager.updateModuleHighScore('shapes', 50);
      expect(saveManager.getModulePlayCount('shapes'), 1);
    });

    test('should get module average score', () async {
      await saveManager.init();
      
      expect(saveManager.getModuleAverageScore('shapes'), 0.0);
      
      // Simulate multiple plays
      saveManager.updateModuleHighScore('shapes', 50);
      saveManager.updateModuleHighScore('shapes', 100);
      saveManager.updateModuleHighScore('shapes', 75);
      
      expect(saveManager.getModuleAverageScore('shapes'), 75.0);
    });

    test('should save and load game session', () async {
      await saveManager.init();
      
      final session = GameSession(
        moduleId: 'shapes',
        startTime: DateTime.now(),
        score: 100,
        moves: 10,
        correctMatches: 5,
        incorrectMatches: 2,
        completed: true,
      );
      
      await saveManager.saveGameSession(session);
      
      expect(saveManager.totalGamesPlayed, 1);
      expect(saveManager.totalScore, 100);
      expect(saveManager.highScore, 100);
      expect(saveManager.getModuleHighScore('shapes'), 100);
      expect(saveManager.getModulePlayCount('shapes'), 1);
    });

    test('should get module sessions', () async {
      await saveManager.init();
      
      final session1 = GameSession(
        moduleId: 'shapes',
        startTime: DateTime.now().subtract(const Duration(hours: 1)),
        score: 50,
        moves: 5,
        correctMatches: 3,
        incorrectMatches: 1,
        completed: true,
      );
      
      final session2 = GameSession(
        moduleId: 'colors',
        startTime: DateTime.now(),
        score: 75,
        moves: 8,
        correctMatches: 4,
        incorrectMatches: 2,
        completed: true,
      );
      
      await saveManager.saveGameSession(session1);
      await saveManager.saveGameSession(session2);
      
      final shapesSessions = saveManager.getModuleSessions('shapes');
      expect(shapesSessions.length, 1);
      expect(shapesSessions.first.moduleId, 'shapes');
      
      final colorsSessions = saveManager.getModuleSessions('colors');
      expect(colorsSessions.length, 1);
      expect(colorsSessions.first.moduleId, 'colors');
    });

    test('should get recent sessions', () async {
      await saveManager.init();
      
      final session1 = GameSession(
        moduleId: 'shapes',
        startTime: DateTime.now().subtract(const Duration(hours: 2)),
        score: 50,
        moves: 5,
        correctMatches: 3,
        incorrectMatches: 1,
        completed: true,
      );
      
      final session2 = GameSession(
        moduleId: 'colors',
        startTime: DateTime.now().subtract(const Duration(hours: 1)),
        score: 75,
        moves: 8,
        correctMatches: 4,
        incorrectMatches: 2,
        completed: true,
      );
      
      final session3 = GameSession(
        moduleId: 'animals',
        startTime: DateTime.now(),
        score: 100,
        moves: 10,
        correctMatches: 5,
        incorrectMatches: 2,
        completed: true,
      );
      
      await saveManager.saveGameSession(session1);
      await saveManager.saveGameSession(session2);
      await saveManager.saveGameSession(session3);
      
      final recentSessions = saveManager.getRecentSessions(limit: 2);
      expect(recentSessions.length, 2);
      expect(recentSessions.first.moduleId, 'animals'); // Most recent
      expect(recentSessions.last.moduleId, 'colors');
    });

    test('should get best sessions', () async {
      await saveManager.init();
      
      final session1 = GameSession(
        moduleId: 'shapes',
        startTime: DateTime.now(),
        score: 50,
        moves: 5,
        correctMatches: 3,
        incorrectMatches: 1,
        completed: true,
      );
      
      final session2 = GameSession(
        moduleId: 'colors',
        startTime: DateTime.now(),
        score: 100,
        moves: 8,
        correctMatches: 4,
        incorrectMatches: 2,
        completed: true,
      );
      
      final session3 = GameSession(
        moduleId: 'animals',
        startTime: DateTime.now(),
        score: 75,
        moves: 10,
        correctMatches: 5,
        incorrectMatches: 2,
        completed: true,
      );
      
      await saveManager.saveGameSession(session1);
      await saveManager.saveGameSession(session2);
      await saveManager.saveGameSession(session3);
      
      final bestSessions = saveManager.getBestSessions(limit: 2);
      expect(bestSessions.length, 2);
      expect(bestSessions.first.score, 100); // Highest score
      expect(bestSessions.last.score, 75);
    });

    test('should save and load user settings', () async {
      await saveManager.init();
      
      final settings = {
        'theme': 'light',
        'language': 'en',
        'notifications': true,
        'difficulty': 'medium',
      };
      
      await saveManager.saveUserSettings(settings);
      
      expect(saveManager.getUserSetting('theme'), 'light');
      expect(saveManager.getUserSetting('language'), 'en');
      expect(saveManager.getUserSetting('notifications'), true);
      expect(saveManager.getUserSetting('difficulty'), 'medium');
      expect(saveManager.getUserSetting('nonexistent'), null);
      expect(saveManager.getUserSetting('nonexistent', defaultValue: 'default'), 'default');
    });

    test('should set individual user setting', () async {
      await saveManager.init();
      
      await saveManager.setUserSetting('theme', 'dark');
      expect(saveManager.getUserSetting('theme'), 'dark');
      
      await saveManager.setUserSetting('language', 'es');
      expect(saveManager.getUserSetting('language'), 'es');
    });

    test('should export data', () async {
      await saveManager.init();
      
      // Add some test data
      saveManager.updateHighScore(100);
      saveManager.incrementGamesPlayed();
      saveManager.unlockModule('shapes');
      await saveManager.setUserSetting('theme', 'light');
      
      final session = GameSession(
        moduleId: 'shapes',
        startTime: DateTime.now(),
        score: 50,
        moves: 5,
        correctMatches: 3,
        incorrectMatches: 1,
        completed: true,
      );
      await saveManager.saveGameSession(session);
      
      final exportedData = saveManager.exportData();
      
      expect(exportedData['totalGamesPlayed'], 1);
      expect(exportedData['highScore'], 100);
      expect(exportedData['unlockedModules'], contains('shapes'));
      expect(exportedData['userSettings']['theme'], 'light');
      expect(exportedData['sessions'], hasLength(1));
    });

    test('should import data', () async {
      await saveManager.init();
      
      final testData = {
        'totalGamesPlayed': 5,
        'totalScore': 500,
        'highScore': 150,
        'totalPlayTime': 3600,
        'moduleScores': {'shapes': 100, 'colors': 80},
        'modulePlayCounts': {'shapes': 3, 'colors': 2},
        'unlockedModules': ['shapes', 'colors'],
        'userSettings': {'theme': 'dark', 'language': 'es'},
        'sessions': [
          {
            'moduleId': 'shapes',
            'startTime': DateTime.now().toIso8601String(),
            'endTime': DateTime.now().toIso8601String(),
            'score': 100,
            'moves': 10,
            'correctMatches': 5,
            'incorrectMatches': 2,
            'completed': true,
            'metadata': {},
          }
        ],
      };
      
      await saveManager.importData(testData);
      
      expect(saveManager.totalGamesPlayed, 5);
      expect(saveManager.highScore, 150);
      expect(saveManager.getModuleHighScore('shapes'), 100);
      expect(saveManager.isModuleUnlocked('shapes'), true);
      expect(saveManager.getUserSetting('theme'), 'dark');
    });

    test('should clear all data', () async {
      await saveManager.init();
      
      // Add some test data
      saveManager.updateHighScore(100);
      saveManager.incrementGamesPlayed();
      saveManager.unlockModule('shapes');
      
      final session = GameSession(
        moduleId: 'shapes',
        startTime: DateTime.now(),
        score: 50,
        moves: 5,
        correctMatches: 3,
        incorrectMatches: 1,
        completed: true,
      );
      await saveManager.saveGameSession(session);
      
      // Verify data exists
      expect(saveManager.totalGamesPlayed, 1);
      expect(saveManager.highScore, 100);
      expect(saveManager.isModuleUnlocked('shapes'), true);
      
      // Clear all data
      await saveManager.clearAllData();
      
      // Verify data is cleared
      expect(saveManager.totalGamesPlayed, 0);
      expect(saveManager.highScore, 0);
      expect(saveManager.isModuleUnlocked('shapes'), false);
    });

    test('should handle rapid operations', () async {
      await saveManager.init();
      
      // Rapid score updates
      for (int i = 0; i < 100; i++) {
        saveManager.updateHighScore(i);
        saveManager.updateModuleHighScore('shapes', i);
        saveManager.incrementGamesPlayed();
        saveManager.addPlayTime(1);
      }
      
      expect(saveManager.highScore, 99);
      expect(saveManager.getModuleHighScore('shapes'), 99);
      expect(saveManager.totalGamesPlayed, 100);
      expect(saveManager.totalPlayTime, 100);
    });

    test('should handle concurrent operations', () async {
      await saveManager.init();
      
      // Simulate concurrent operations
      final futures = <Future>[];
      
      for (int i = 0; i < 10; i++) {
        futures.add(saveManager.updateHighScore(i * 10));
        futures.add(saveManager.incrementGamesPlayed());
        futures.add(saveManager.addPlayTime(10));
      }
      
      await Future.wait(futures);
      
      expect(saveManager.highScore, 90);
      expect(saveManager.totalGamesPlayed, 10);
      expect(saveManager.totalPlayTime, 100);
    });
  });
}