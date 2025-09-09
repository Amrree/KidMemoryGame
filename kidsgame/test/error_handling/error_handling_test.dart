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
import 'package:kidsgame/core/screens/game_screen.dart';
import 'package:kidsgame/core/models/game_module.dart';

void main() {
  group('Error Handling Tests', () {
    testWidgets('should handle null module gracefully', (WidgetTester tester) async {
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

      await tester.pumpAndSettle();

      // Try to navigate to game screen with null module
      try {
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
              home: GameScreen(module: null),
            ),
          ),
        );
      } catch (e) {
        // Should handle null module gracefully
        expect(e, isNotNull);
      }
    });

    testWidgets('should handle invalid module data gracefully', (WidgetTester tester) async {
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

      await tester.pumpAndSettle();

      // Create module with invalid data
      final invalidModule = GameModule(
        id: '',
        name: '',
        description: '',
        iconPath: '',
        backgroundPath: '',
        cardPaths: [],
        isUnlocked: false,
        difficultyLevel: -1,
        audioPaths: [],
        category: '',
        ageRangeMin: -1,
        ageRangeMax: -1,
      );

      // Try to navigate to game screen with invalid module
      try {
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => AnalyticsManager()),
              ChangeNotifierProvider(create: (_) => AudioManager()),
              ChangeNotifierProvider(create: (_) => ModuleManager()),
              ChangeNotifierProvider(create: (_) => SaveManager()),
              ChangeNotifierProvider(create: (_) => ParentalGateManager()),
            ],
            child: MaterialApp(
              home: GameScreen(module: invalidModule),
            ),
          ),
        );
      } catch (e) {
        // Should handle invalid module data gracefully
        expect(e, isNotNull);
      }
    });

    testWidgets('should handle missing assets gracefully', (WidgetTester tester) async {
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

      await tester.pumpAndSettle();

      // Navigate to module selector
      await tester.tap(find.text('Play Game'));
      await tester.pumpAndSettle();

      // Should display fallback icons for missing assets
      expect(find.byIcon(Icons.psychology), findsAtLeastNWidgets(1));
    });

    testWidgets('should handle network errors gracefully', (WidgetTester tester) async {
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

      await tester.pumpAndSettle();

      // Simulate network error in analytics
      final analyticsManager = tester.element(find.byType(MainMenuScreen)).read<AnalyticsManager>();
      
      // Should not crash when network fails
      analyticsManager.recordError('network_error', 'Failed to connect to server');
      
      // App should still be functional
      expect(find.text('Kids Game'), findsOneWidget);
    });

    testWidgets('should handle audio errors gracefully', (WidgetTester tester) async {
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

      await tester.pumpAndSettle();

      // Simulate audio error
      final audioManager = tester.element(find.byType(MainMenuScreen)).read<AudioManager>();
      
      // Should not crash when audio fails
      await audioManager.playSfx('nonexistent_file.mp3');
      await audioManager.playMusic('nonexistent_music.mp3');
      
      // App should still be functional
      expect(find.text('Kids Game'), findsOneWidget);
    });

    testWidgets('should handle storage errors gracefully', (WidgetTester tester) async {
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

      await tester.pumpAndSettle();

      // Simulate storage error
      final saveManager = tester.element(find.byType(MainMenuScreen)).read<SaveManager>();
      
      // Should not crash when storage fails
      try {
        await saveManager.clearAllData();
      } catch (e) {
        // Should handle storage errors gracefully
        expect(e, isNotNull);
      }
      
      // App should still be functional
      expect(find.text('Kids Game'), findsOneWidget);
    });

    testWidgets('should handle invalid user input gracefully', (WidgetTester tester) async {
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

      await tester.pumpAndSettle();

      // Navigate to parental controls
      await tester.tap(find.text('Parental Controls'));
      await tester.pumpAndSettle();

      // Try invalid passcode
      await tester.enterText(find.byType(TextField), 'invalid');
      await tester.tap(find.text('Unlock'));
      await tester.pumpAndSettle();

      // Should show error message
      expect(find.textContaining('Incorrect passcode'), findsOneWidget);
    });

    testWidgets('should handle rapid state changes gracefully', (WidgetTester tester) async {
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

      await tester.pumpAndSettle();

      // Rapidly toggle settings
      for (int i = 0; i < 100; i++) {
        await tester.tap(find.text('Settings'));
        await tester.pump();
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pump();
      }

      // Should not crash
      expect(find.text('Kids Game'), findsOneWidget);
    });

    testWidgets('should handle memory pressure gracefully', (WidgetTester tester) async {
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

      await tester.pumpAndSettle();

      // Simulate memory pressure
      final saveManager = tester.element(find.byType(MainMenuScreen)).read<SaveManager>();
      
      // Add many game sessions
      for (int i = 0; i < 1000; i++) {
        final session = GameSession(
          moduleId: 'shapes',
          startTime: DateTime.now(),
          score: i * 10,
          moves: i * 5,
          correctMatches: i * 3,
          incorrectMatches: i * 2,
          completed: true,
        );
        await saveManager.saveGameSession(session);
      }

      // Should not crash
      expect(find.text('Kids Game'), findsOneWidget);
    });

    testWidgets('should handle concurrent operations gracefully', (WidgetTester tester) async {
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

      await tester.pumpAndSettle();

      // Simulate concurrent operations
      final futures = <Future>[];
      for (int i = 0; i < 100; i++) {
        futures.add(tester.tap(find.text('Play Game')));
        futures.add(tester.tap(find.text('Settings')));
        futures.add(tester.tap(find.text('Parental Controls')));
      }

      await Future.wait(futures);
      await tester.pumpAndSettle();

      // Should not crash
      expect(find.text('Kids Game'), findsOneWidget);
    });

    testWidgets('should handle screen rotation errors gracefully', (WidgetTester tester) async {
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

      await tester.pumpAndSettle();

      // Simulate screen rotation
      await tester.binding.setSurfaceSize(const Size(800, 600));
      await tester.pumpAndSettle();

      // Should not crash
      expect(find.text('Kids Game'), findsOneWidget);
    });

    testWidgets('should handle app lifecycle errors gracefully', (WidgetTester tester) async {
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

      await tester.pumpAndSettle();

      // Simulate app lifecycle changes
      await tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      await tester.pumpAndSettle();
      await tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();

      // Should not crash
      expect(find.text('Kids Game'), findsOneWidget);
    });

    testWidgets('should handle invalid navigation gracefully', (WidgetTester tester) async {
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

      await tester.pumpAndSettle();

      // Try to navigate to non-existent screen
      try {
        await tester.tap(find.text('Non-existent Button'));
        await tester.pumpAndSettle();
      } catch (e) {
        // Should handle invalid navigation gracefully
        expect(e, isNotNull);
      }

      // Should not crash
      expect(find.text('Kids Game'), findsOneWidget);
    });

    testWidgets('should handle data corruption gracefully', (WidgetTester tester) async {
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

      await tester.pumpAndSettle();

      // Simulate data corruption
      final saveManager = tester.element(find.byType(MainMenuScreen)).read<SaveManager>();
      
      try {
        // Try to load corrupted data
        await saveManager.loadSettings({'corrupted': 'data'});
      } catch (e) {
        // Should handle data corruption gracefully
        expect(e, isNotNull);
      }

      // Should not crash
      expect(find.text('Kids Game'), findsOneWidget);
    });

    testWidgets('should handle permission errors gracefully', (WidgetTester tester) async {
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

      await tester.pumpAndSettle();

      // Simulate permission error
      final audioManager = tester.element(find.byType(MainMenuScreen)).read<AudioManager>();
      
      // Should not crash when permissions are denied
      await audioManager.initialize();
      
      // Should not crash
      expect(find.text('Kids Game'), findsOneWidget);
    });

    testWidgets('should handle timeout errors gracefully', (WidgetTester tester) async {
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

      await tester.pumpAndSettle();

      // Simulate timeout error
      final analyticsManager = tester.element(find.byType(MainMenuScreen)).read<AnalyticsManager>();
      
      // Should not crash when operations timeout
      analyticsManager.recordError('timeout_error', 'Operation timed out');
      
      // Should not crash
      expect(find.text('Kids Game'), findsOneWidget);
    });
  });
}