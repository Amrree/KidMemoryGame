import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:kid_memory_template/core/managers/analytics_manager.dart';
import 'package:kid_memory_template/core/managers/audio_manager.dart';
import 'package:kid_memory_template/core/managers/module_manager.dart';
import 'package:kid_memory_template/core/managers/save_manager.dart';
import 'package:kid_memory_template/core/screens/main_menu_screen.dart';

void main() {
  group('Kid Memory Template Tests', () {
    testWidgets('Main menu loads correctly', (WidgetTester tester) async {
      // Build our app and trigger a frame
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AnalyticsManager()),
            ChangeNotifierProvider(create: (_) => AudioManager()),
            ChangeNotifierProvider(create: (_) => ModuleManager()),
            ChangeNotifierProvider(create: (_) => SaveManager()),
          ],
          child: const MaterialApp(
            home: MainMenuScreen(),
          ),
        ),
      );

      // Wait for animations to complete
      await tester.pumpAndSettle();

      // Verify that the main menu elements are present
      expect(find.text('Kid Memory'), findsOneWidget);
      expect(find.text('Educational Memory Game'), findsOneWidget);
      expect(find.text('Play Game'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
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
          ],
          child: const MaterialApp(
            home: MainMenuScreen(),
          ),
        ),
      );

      // Wait for animations to complete
      await tester.pumpAndSettle();

      // Tap the Play Game button
      await tester.tap(find.text('Play Game'));
      await tester.pumpAndSettle();

      // Verify that the module selector is shown
      expect(find.text('Choose a Module'), findsOneWidget);
      expect(find.text('Shapes'), findsOneWidget);
      expect(find.text('Colors'), findsOneWidget);
    });

    testWidgets('Audio manager works correctly', (WidgetTester tester) async {
      final audioManager = AudioManager();
      await audioManager.initialize();

      // Test volume settings
      audioManager.setMusicVolume(0.5);
      expect(audioManager.musicVolume, 0.5);

      audioManager.setSoundVolume(0.8);
      expect(audioManager.soundVolume, 0.8);

      // Test enable/disable
      audioManager.setMusicEnabled(false);
      expect(audioManager.isMusicEnabled, false);

      audioManager.setSoundEnabled(false);
      expect(audioManager.isSoundEnabled, false);
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
    });

    testWidgets('Save manager works correctly', (WidgetTester tester) async {
      final saveManager = SaveManager();
      await saveManager.init();

      // Test score tracking
      saveManager.updateHighScore(100);
      expect(saveManager.getHighScore(), 100);

      // Test games played tracking
      saveManager.incrementGamesPlayed();
      expect(saveManager.getGamesPlayed(), 1);
    });
  });
}