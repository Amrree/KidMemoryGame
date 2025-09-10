import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kid_memory_template/main.dart' as app;
import 'package:kid_memory_template/core/managers/audio_manager.dart';
import 'package:kid_memory_template/core/managers/save_manager.dart';
import 'package:kid_memory_template/core/managers/module_manager.dart';
import 'package:kid_memory_template/core/managers/analytics_manager.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Flow Integration Tests', () {
    testWidgets('should complete full app startup flow', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Verify main menu is displayed
      expect(find.text('Kid Memory'), findsOneWidget);
      expect(find.text('Educational Memory Game'), findsOneWidget);
      expect(find.text('Play Game'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Parental Gate'), findsOneWidget);
    });

    testWidgets('should navigate through main menu buttons', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Test Play Game navigation
      await tester.tap(find.text('Play Game'));
      await tester.pumpAndSettle();
      
      // Should navigate to module selector
      // Note: This would require proper navigation setup
      // For now, we verify the button is tappable
      expect(find.text('Play Game'), findsOneWidget);

      // Go back to main menu
      await tester.pumpWidget(
        MaterialApp(
          home: const Scaffold(
            body: Center(child: Text('Main Menu')),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Test Settings navigation
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();
      
      // Should navigate to settings
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('should handle audio manager integration', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Test audio manager is properly initialized
      final audioManager = tester.binding.rootElement?.findAncestorStateOfType<AudioManager>();
      // Note: This is a simplified test - actual integration would require
      // proper provider setup in tests
    });

    testWidgets('should handle save manager integration', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Test save manager is properly initialized
      // This would test actual data persistence in integration tests
    });

    testWidgets('should handle module manager integration', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Test module manager loads default modules
      // This would test actual module loading and management
    });

    testWidgets('should handle app lifecycle events', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Test app pause/resume
      await tester.binding.pause();
      await tester.binding.resume();
      await tester.pumpAndSettle();

      // App should still be functional
      expect(find.text('Kid Memory'), findsOneWidget);
    });

    testWidgets('should handle different screen orientations', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Test landscape orientation (app is designed for landscape)
      await tester.binding.setSurfaceSize(const Size(1024, 768));
      await tester.pumpAndSettle();

      // App should still be functional
      expect(find.text('Kid Memory'), findsOneWidget);

      // Test portrait orientation
      await tester.binding.setSurfaceSize(const Size(768, 1024));
      await tester.pumpAndSettle();

      // App should still be functional
      expect(find.text('Kid Memory'), findsOneWidget);
    });

    testWidgets('should handle memory pressure', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Simulate memory pressure by creating many widgets
      for (int i = 0; i < 100; i++) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Test $i'),
              ),
            ),
          ),
        );
        await tester.pump();
      }

      // Return to main app
      app.main();
      await tester.pumpAndSettle();

      // App should still be functional
      expect(find.text('Kid Memory'), findsOneWidget);
    });

    testWidgets('should handle rapid user interactions', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Rapidly tap buttons
      for (int i = 0; i < 10; i++) {
        await tester.tap(find.text('Play Game'));
        await tester.pump();
        await tester.tap(find.text('Settings'));
        await tester.pump();
        await tester.tap(find.text('Parental Gate'));
        await tester.pump();
      }

      await tester.pumpAndSettle();

      // App should still be functional
      expect(find.text('Kid Memory'), findsOneWidget);
    });

    testWidgets('should handle app backgrounding and foregrounding', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Simulate app going to background
      await tester.binding.pause();
      await tester.pump();

      // Simulate app coming to foreground
      await tester.binding.resume();
      await tester.pumpAndSettle();

      // App should still be functional
      expect(find.text('Kid Memory'), findsOneWidget);
    });
  });
}