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
  group('Performance Tests', () {
    testWidgets('should load main menu within performance budget', (WidgetTester tester) async {
      final stopwatch = Stopwatch()..start();
      
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
      stopwatch.stop();

      // Should load within 2 seconds
      expect(stopwatch.elapsedMilliseconds, lessThan(2000));
      expect(find.text('Kids Game'), findsOneWidget);
    });

    testWidgets('should handle rapid screen transitions efficiently', (WidgetTester tester) async {
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

      final stopwatch = Stopwatch()..start();

      // Perform 20 rapid screen transitions
      for (int i = 0; i < 20; i++) {
        await tester.tap(find.text('Play Game'));
        await tester.pump();
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pump();
      }

      stopwatch.stop();

      // Should complete within 5 seconds
      expect(stopwatch.elapsedMilliseconds, lessThan(5000));
      expect(find.text('Kids Game'), findsOneWidget);
    });

    testWidgets('should handle large number of module cards efficiently', (WidgetTester tester) async {
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

      final stopwatch = Stopwatch()..start();
      await tester.pumpAndSettle();
      stopwatch.stop();

      // Should load module selector within 1 second
      expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      expect(find.text('Choose a Module'), findsOneWidget);
      expect(find.byType(Card), findsAtLeastNWidgets(6));
    });

    testWidgets('should handle rapid button taps without performance degradation', (WidgetTester tester) async {
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

      final stopwatch = Stopwatch()..start();

      // Perform 100 rapid button taps
      for (int i = 0; i < 100; i++) {
        await tester.tap(find.text('Play Game'));
        await tester.pump();
      }

      stopwatch.stop();

      // Should complete within 3 seconds
      expect(stopwatch.elapsedMilliseconds, lessThan(3000));
    });

    testWidgets('should handle memory pressure during long sessions', (WidgetTester tester) async {
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

      // Simulate long session with many operations
      for (int session = 0; session < 10; session++) {
        // Navigate to module selector
        await tester.tap(find.text('Play Game'));
        await tester.pumpAndSettle();

        // Navigate back
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();

        // Navigate to settings
        await tester.tap(find.text('Settings'));
        await tester.pumpAndSettle();

        // Navigate back
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();
      }

      // Should still be functional
      expect(find.text('Kids Game'), findsOneWidget);
    });

    testWidgets('should handle concurrent operations efficiently', (WidgetTester tester) async {
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

      final stopwatch = Stopwatch()..start();

      // Simulate concurrent operations
      final futures = <Future>[];
      for (int i = 0; i < 20; i++) {
        futures.add(tester.tap(find.text('Play Game')));
        futures.add(tester.tap(find.text('Settings')));
        futures.add(tester.tap(find.text('Parental Controls')));
      }

      await Future.wait(futures);
      await tester.pumpAndSettle();

      stopwatch.stop();

      // Should complete within 4 seconds
      expect(stopwatch.elapsedMilliseconds, lessThan(4000));
    });

    testWidgets('should handle screen size changes efficiently', (WidgetTester tester) async {
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

      final stopwatch = Stopwatch()..start();

      // Simulate screen size changes
      final sizes = [
        const Size(400, 800),   // Phone portrait
        const Size(800, 400),   // Phone landscape
        const Size(1024, 768),  // Tablet portrait
        const Size(768, 1024),  // Tablet landscape
        const Size(1920, 1080), // Desktop
      ];

      for (final size in sizes) {
        await tester.binding.setSurfaceSize(size);
        await tester.pumpAndSettle();
      }

      stopwatch.stop();

      // Should complete within 2 seconds
      expect(stopwatch.elapsedMilliseconds, lessThan(2000));
      expect(find.text('Kids Game'), findsOneWidget);
    });

    testWidgets('should handle rapid state changes efficiently', (WidgetTester tester) async {
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

      final stopwatch = Stopwatch()..start();

      // Simulate rapid state changes
      for (int i = 0; i < 50; i++) {
        // Toggle settings rapidly
        await tester.tap(find.text('Settings'));
        await tester.pump();
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pump();
      }

      stopwatch.stop();

      // Should complete within 3 seconds
      expect(stopwatch.elapsedMilliseconds, lessThan(3000));
    });

    testWidgets('should handle large data sets efficiently', (WidgetTester tester) async {
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

      final stopwatch = Stopwatch()..start();

      // Simulate large data operations
      final saveManager = tester.element(find.byType(MainMenuScreen)).read<SaveManager>();
      
      // Add many game sessions
      for (int i = 0; i < 100; i++) {
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

      stopwatch.stop();

      // Should complete within 2 seconds
      expect(stopwatch.elapsedMilliseconds, lessThan(2000));
    });

    testWidgets('should handle animation performance efficiently', (WidgetTester tester) async {
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

      final stopwatch = Stopwatch()..start();

      // Wait for all animations to complete
      await tester.pumpAndSettle();

      stopwatch.stop();

      // Should complete within 3 seconds
      expect(stopwatch.elapsedMilliseconds, lessThan(3000));
      expect(find.text('Kids Game'), findsOneWidget);
    });

    testWidgets('should handle network operations efficiently', (WidgetTester tester) async {
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

      final stopwatch = Stopwatch()..start();

      // Simulate network operations (analytics, audio loading, etc.)
      final analyticsManager = tester.element(find.byType(MainMenuScreen)).read<AnalyticsManager>();
      final audioManager = tester.element(find.byType(MainMenuScreen)).read<AudioManager>();
      
      // Record many events
      for (int i = 0; i < 100; i++) {
        analyticsManager.recordCardFlip('card$i');
        analyticsManager.recordMatch('card$i', 'card${i + 1}', true);
      }

      // Simulate audio operations
      await audioManager.initialize();

      stopwatch.stop();

      // Should complete within 2 seconds
      expect(stopwatch.elapsedMilliseconds, lessThan(2000));
    });

    testWidgets('should handle memory cleanup efficiently', (WidgetTester tester) async {
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

      final stopwatch = Stopwatch()..start();

      // Simulate memory cleanup operations
      final saveManager = tester.element(find.byType(MainMenuScreen)).read<SaveManager>();
      await saveManager.clearAllData();

      stopwatch.stop();

      // Should complete within 1 second
      expect(stopwatch.elapsedMilliseconds, lessThan(1000));
    });
  });
}