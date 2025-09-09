import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:kidsgame/core/managers/analytics_manager.dart';
import 'package:kidsgame/core/managers/audio_manager.dart';
import 'package:kidsgame/core/managers/module_manager.dart';
import 'package:kidsgame/core/managers/save_manager.dart';
import 'package:kidsgame/core/managers/parental_gate_manager.dart';
import 'package:kidsgame/core/screens/main_menu_screen.dart';
import 'package:kidsgame/core/screens/module_selector_screen.dart';

void main() {
  group('Kids Game Template Tests', () {
    testWidgets('Main menu loads correctly', (WidgetTester tester) async {
      // Build our app and trigger a frame
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AnalyticsManager()),
            ChangeNotifierProvider(create: (_) => AudioManager()),
            ChangeNotifierProvider(create: (_) => ModuleManager()),
            ChangeNotifierProvider(create: (_) => SaveManager()),
            ChangeNotifierProvider(create: (_) => ParentalGateManager()),
          ],
          child: const MaterialApp(
            home: MainMenuScreen(),
          ),
        ),
      );

      // Wait for animations to complete
      await tester.pumpAndSettle();

      // Verify that the main menu elements are present
      expect(find.text('Kids Game'), findsOneWidget);
      expect(find.text('Educational Memory Games'), findsOneWidget);
      expect(find.text('Play Game'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Parental Controls'), findsOneWidget);
    });

    testWidgets('Module selector loads correctly', (WidgetTester tester) async {
      // Build our app and trigger a frame
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AnalyticsManager()),
            ChangeNotifierProvider(create: (_) => AudioManager()),
            ChangeNotifierProvider(create: (_) => ModuleManager()),
            ChangeNotifierProvider(create: (_) => SaveManager()),
            ChangeNotifierProvider(create: (_) => ParentalGateManager()),
          ],
          child: const MaterialApp(
            home: ModuleSelectorScreen(),
          ),
        ),
      );

      // Wait for animations to complete
      await tester.pumpAndSettle();

      // Verify that the module selector is shown
      expect(find.text('Choose a Module'), findsOneWidget);
      expect(find.text('Shapes'), findsOneWidget);
      expect(find.text('Colors'), findsOneWidget);
      expect(find.text('Animals'), findsOneWidget);
      expect(find.text('Jobs'), findsOneWidget);
      expect(find.text('Farm'), findsOneWidget);
      expect(find.text('Family'), findsOneWidget);
    });

    testWidgets('Audio manager works correctly', (WidgetTester tester) async {
      final audioManager = AudioManager();
      await audioManager.initialize();

      // Test volume settings
      audioManager.setMusicVolume(0.5);
      expect(audioManager.musicVolume, 0.5);

      audioManager.setSoundVolume(0.8);
      expect(audioManager.soundVolume, 0.8);

      audioManager.setVoiceVolume(0.6);
      expect(audioManager.voiceVolume, 0.6);

      // Test enable/disable
      audioManager.setMusicEnabled(false);
      expect(audioManager.isMusicEnabled, false);

      audioManager.setSoundEnabled(false);
      expect(audioManager.isSoundEnabled, false);

      audioManager.setVoiceEnabled(false);
      expect(audioManager.isVoiceEnabled, false);
    });

    testWidgets('Module manager works correctly', (WidgetTester tester) async {
      final moduleManager = ModuleManager();
      await moduleManager.init();

      // Test that modules are loaded
      expect(moduleManager.modules.isNotEmpty, true);
      expect(moduleManager.modules.length, 6); // 6 default modules

      // Test module unlocking
      final shapesModule = moduleManager.modules.firstWhere(
        (module) => module.id == 'shapes',
      );
      expect(shapesModule.isUnlocked, true);

      // Test module categories
      final learningModules = moduleManager.getModulesByCategory('Learning');
      expect(learningModules.length, 2); // Shapes and Colors

      // Test age filtering
      final toddlerModules = moduleManager.getModulesForAge(3);
      expect(toddlerModules.isNotEmpty, true);
    });

    testWidgets('Save manager works correctly', (WidgetTester tester) async {
      final saveManager = SaveManager();
      await saveManager.init();

      // Test score tracking
      saveManager.updateHighScore(100);
      expect(saveManager.getHighScore(), 100);

      // Test module-specific scores
      saveManager.updateModuleHighScore('shapes', 50);
      expect(saveManager.getModuleHighScore('shapes'), 50);

      // Test games played tracking
      saveManager.incrementGamesPlayed();
      expect(saveManager.getGamesPlayed(), 1);

      // Test module unlocking
      saveManager.unlockModule('animals');
      expect(saveManager.isModuleUnlocked('animals'), true);
    });

    testWidgets('Analytics manager works correctly', (WidgetTester tester) async {
      final analyticsManager = AnalyticsManager();
      await analyticsManager.init();

      // Test session tracking
      analyticsManager.startSession('shapes');
      expect(analyticsManager.currentSession, isNotNull);
      expect(analyticsManager.currentSession!.moduleId, 'shapes');

      // Test event recording
      analyticsManager.recordCardFlip('card1');
      analyticsManager.recordMatch('card1', 'card2', true);
      analyticsManager.recordModuleUnlock('animals');

      // Test analytics summary
      final summary = analyticsManager.getAnalyticsSummary();
      expect(summary['totalEvents'], greaterThan(0));
      expect(summary['sessionsStarted'], 1);
    });

    testWidgets('Parental gate manager works correctly', (WidgetTester tester) async {
      final parentalGateManager = ParentalGateManager();
      await parentalGateManager.init();

      // Test default settings
      expect(parentalGateManager.isEnabled, true);
      expect(parentalGateManager.analyticsEnabled, true);
      expect(parentalGateManager.purchasesEnabled, false);

      // Test passcode unlock
      final success = await parentalGateManager.attemptUnlock('1234');
      expect(success, true);
      expect(parentalGateManager.isUnlocked, true);

      // Test settings changes
      parentalGateManager.setAnalyticsEnabled(false);
      expect(parentalGateManager.analyticsEnabled, false);

      parentalGateManager.setPurchasesEnabled(true);
      expect(parentalGateManager.purchasesEnabled, true);
    });

    testWidgets('Game module model works correctly', (WidgetTester tester) async {
      final module = GameModule(
        id: 'test',
        name: 'Test Module',
        description: 'A test module',
        iconPath: 'test_icon.png',
        backgroundPath: 'test_background.png',
        cardPaths: ['card1.png', 'card2.png'],
        isUnlocked: true,
        difficultyLevel: 2,
        audioPaths: ['audio1.mp3', 'audio2.mp3'],
        category: 'Test',
        ageRangeMin: 3,
        ageRangeMax: 6,
      );

      // Test basic properties
      expect(module.id, 'test');
      expect(module.name, 'Test Module');
      expect(module.totalCards, 2);
      expect(module.totalPairs, 1);
      expect(module.difficultyDescription, 'Medium');

      // Test age appropriateness
      expect(module.isAppropriateForAge(4), true);
      expect(module.isAppropriateForAge(2), false);
      expect(module.isAppropriateForAge(8), false);

      // Test copy with
      final updatedModule = module.copyWith(
        name: 'Updated Test Module',
        difficultyLevel: 3,
      );
      expect(updatedModule.name, 'Updated Test Module');
      expect(updatedModule.difficultyLevel, 3);
      expect(updatedModule.id, 'test'); // Should remain unchanged
    });

    testWidgets('Game session model works correctly', (WidgetTester tester) async {
      final startTime = DateTime.now();
      final session = GameSession(
        moduleId: 'shapes',
        startTime: startTime,
        score: 50,
        moves: 10,
        correctMatches: 3,
        incorrectMatches: 2,
        completed: true,
      );

      // Test basic properties
      expect(session.moduleId, 'shapes');
      expect(session.score, 50);
      expect(session.moves, 10);
      expect(session.correctMatches, 3);
      expect(session.incorrectMatches, 2);
      expect(session.completed, true);

      // Test accuracy calculation
      expect(session.accuracy, 60.0); // 3 correct out of 5 total

      // Test completion
      expect(session.endTime, isNull);
      session.complete();
      expect(session.endTime, isNotNull);
      expect(session.completed, true);
    });
  });
}