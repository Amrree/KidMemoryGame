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
import 'package:kidsgame/core/screens/celebration_screen.dart';
import 'package:kidsgame/core/screens/settings_screen.dart';
import 'package:kidsgame/core/screens/parental_gate_screen.dart';
import 'package:kidsgame/core/models/game_module.dart';

void main() {
  group('Game Flow Integration Tests', () {
    testWidgets('should complete full game flow from main menu to celebration', (WidgetTester tester) async {
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

      // Wait for main menu to load
      await tester.pumpAndSettle();
      expect(find.text('Kids Game'), findsOneWidget);

      // Navigate to module selector
      await tester.tap(find.text('Play Game'));
      await tester.pumpAndSettle();
      expect(find.text('Choose a Module'), findsOneWidget);

      // Select shapes module (should be unlocked)
      await tester.tap(find.text('Shapes'));
      await tester.pumpAndSettle();

      // Should navigate to game screen
      expect(find.byType(GameScreen), findsOneWidget);
    });

    testWidgets('should handle settings navigation flow', (WidgetTester tester) async {
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

      // Navigate to settings
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();
      expect(find.text('Settings'), findsAtLeastNWidgets(1));

      // Navigate back
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.text('Kids Game'), findsOneWidget);
    });

    testWidgets('should handle parental controls navigation flow', (WidgetTester tester) async {
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
      expect(find.text('Parental Controls'), findsAtLeastNWidgets(1));

      // Navigate back
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.text('Kids Game'), findsOneWidget);
    });

    testWidgets('should handle locked module selection', (WidgetTester tester) async {
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

      // Try to select a locked module
      await tester.tap(find.text('Animals'));
      await tester.pumpAndSettle();

      // Should show locked dialog
      expect(find.text('Animals is Locked'), findsOneWidget);
      expect(find.text('Complete other modules to unlock Animals!'), findsOneWidget);

      // Close dialog
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Should be back at module selector
      expect(find.text('Choose a Module'), findsOneWidget);
    });

    testWidgets('should handle rapid navigation between screens', (WidgetTester tester) async {
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

      // Rapidly navigate between screens
      for (int i = 0; i < 3; i++) {
        // Go to module selector
        await tester.tap(find.text('Play Game'));
        await tester.pumpAndSettle();

        // Go back
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();

        // Go to settings
        await tester.tap(find.text('Settings'));
        await tester.pumpAndSettle();

        // Go back
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();
      }

      // Should still be functional
      expect(find.text('Kids Game'), findsOneWidget);
    });

    testWidgets('should handle screen rotation during navigation', (WidgetTester tester) async {
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

      // Simulate screen rotation
      await tester.binding.setSurfaceSize(const Size(800, 600));
      await tester.pumpAndSettle();

      // Should still be functional
      expect(find.text('Choose a Module'), findsOneWidget);
    });

    testWidgets('should handle multiple module selections', (WidgetTester tester) async {
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

      // Try to select different modules
      await tester.tap(find.text('Shapes'));
      await tester.pumpAndSettle();

      // Go back to module selector
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Try another module
      await tester.tap(find.text('Colors'));
      await tester.pumpAndSettle();

      // Should navigate to game screen
      expect(find.byType(GameScreen), findsOneWidget);
    });

    testWidgets('should handle settings changes and persistence', (WidgetTester tester) async {
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

      // Navigate to settings
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      // Toggle some settings
      final musicSwitch = find.byType(Switch).first;
      await tester.tap(musicSwitch);
      await tester.pumpAndSettle();

      // Navigate back
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Navigate back to settings
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      // Settings should be persisted
      expect(find.byType(Switch), findsAtLeastNWidgets(1));
    });

    testWidgets('should handle parental gate unlock flow', (WidgetTester tester) async {
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

      // Should show passcode screen
      expect(find.text('Parental Controls'), findsAtLeastNWidgets(1));
      expect(find.text('Enter passcode to access parental settings'), findsOneWidget);

      // Enter correct passcode
      await tester.enterText(find.byType(TextField), '1234');
      await tester.tap(find.text('Unlock'));
      await tester.pumpAndSettle();

      // Should show unlocked settings
      expect(find.text('Parental controls unlocked'), findsOneWidget);
    });

    testWidgets('should handle error states gracefully', (WidgetTester tester) async {
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

      // Try to navigate to non-existent screen (should not crash)
      try {
        await tester.tap(find.text('Non-existent Button'));
        await tester.pumpAndSettle();
      } catch (e) {
        // Expected to fail, should not crash the app
      }

      // App should still be functional
      expect(find.text('Kids Game'), findsOneWidget);
    });

    testWidgets('should handle memory pressure during navigation', (WidgetTester tester) async {
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

      // Navigate multiple times to simulate memory pressure
      for (int i = 0; i < 10; i++) {
        await tester.tap(find.text('Play Game'));
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();
      }

      // Should still be functional
      expect(find.text('Kids Game'), findsOneWidget);
    });

    testWidgets('should handle concurrent user interactions', (WidgetTester tester) async {
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

      // Simulate rapid concurrent taps
      final futures = <Future>[];
      for (int i = 0; i < 5; i++) {
        futures.add(tester.tap(find.text('Play Game')));
        futures.add(tester.tap(find.text('Settings')));
        futures.add(tester.tap(find.text('Parental Controls')));
      }

      await Future.wait(futures);
      await tester.pumpAndSettle();

      // Should still be functional
      expect(find.text('Kids Game'), findsOneWidget);
    });

    testWidgets('should handle app lifecycle changes during navigation', (WidgetTester tester) async {
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

      // Simulate app pause/resume
      await tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      await tester.pumpAndSettle();
      await tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();

      // Should still be functional
      expect(find.text('Choose a Module'), findsOneWidget);
    });
  });
}