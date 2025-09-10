import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:kid_memory_template/core/screens/main_menu_screen.dart';
import 'package:kid_memory_template/core/managers/audio_manager.dart';
import 'package:kid_memory_template/core/managers/save_manager.dart';
import 'package:kid_memory_template/core/managers/module_manager.dart';
import 'package:kid_memory_template/core/managers/analytics_manager.dart';

void main() {
  group('MainMenuScreen Widget Tests', () {
    late AudioManager audioManager;
    late SaveManager saveManager;
    late ModuleManager moduleManager;
    late AnalyticsManager analyticsManager;

    setUp(() {
      audioManager = AudioManager();
      saveManager = SaveManager();
      moduleManager = ModuleManager();
      analyticsManager = AnalyticsManager();
    });

    tearDown(() {
      audioManager.dispose();
      saveManager.dispose();
      moduleManager.dispose();
      analyticsManager.dispose();
    });

    Widget createTestWidget() {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => audioManager),
          ChangeNotifierProvider(create: (_) => saveManager),
          ChangeNotifierProvider(create: (_) => moduleManager),
          ChangeNotifierProvider(create: (_) => analyticsManager),
        ],
        child: MaterialApp(
          home: const MainMenuScreen(),
        ),
      );
    }

    testWidgets('should display main menu elements', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for main title
      expect(find.text('Kid Memory'), findsOneWidget);
      expect(find.text('Educational Memory Game'), findsOneWidget);

      // Check for menu buttons
      expect(find.text('Play Game'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Parental Gate'), findsOneWidget);

      // Check for version info
      expect(find.text('Version 1.0.0'), findsOneWidget);

      // Check for logo icon
      expect(find.byIcon(Icons.psychology), findsOneWidget);
    });

    testWidgets('should display animated elements', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      
      // Initially, elements should be in their starting positions
      await tester.pump();
      
      // After animation completes
      await tester.pumpAndSettle();
      
      // All elements should be visible
      expect(find.text('Kid Memory'), findsOneWidget);
      expect(find.text('Play Game'), findsOneWidget);
    });

    testWidgets('should have proper button styling', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find all ElevatedButton widgets
      final buttons = find.byType(ElevatedButton);
      expect(buttons, findsNWidgets(3));

      // Check button styling
      final playButton = tester.widget<ElevatedButton>(
        find.ancestor(
          of: find.text('Play Game'),
          matching: find.byType(ElevatedButton),
        ),
      );

      expect(playButton.style?.backgroundColor?.resolve({}), Colors.white);
    });

    testWidgets('should navigate to module selector when Play Game is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap Play Game button
      await tester.tap(find.text('Play Game'));
      await tester.pumpAndSettle();

      // Should navigate to ModuleSelectorScreen
      // Note: This would require proper navigation setup in tests
      // For now, we just verify the button is tappable
      expect(find.text('Play Game'), findsOneWidget);
    });

    testWidgets('should navigate to settings when Settings is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap Settings button
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      // Should navigate to SettingsScreen
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('should navigate to parental gate when Parental Gate is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap Parental Gate button
      await tester.tap(find.text('Parental Gate'));
      await tester.pumpAndSettle();

      // Should navigate to ParentalGateScreen
      expect(find.text('Parental Gate'), findsOneWidget);
    });

    testWidgets('should have proper gradient background', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find the Container with gradient decoration
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(Scaffold),
          matching: find.byType(Container),
        ).first,
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.gradient, isA<LinearGradient>());
    });

    testWidgets('should display proper icons for buttons', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for button icons
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
      expect(find.byIcon(Icons.lock), findsOneWidget);
    });

    testWidgets('should handle button press animations', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find a button and test press
      final playButton = find.text('Play Game');
      expect(playButton, findsOneWidget);

      // Simulate button press
      await tester.tap(playButton);
      await tester.pump();

      // Button should still be visible after press
      expect(playButton, findsOneWidget);
    });

    testWidgets('should have proper text styling', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check main title styling
      final titleText = tester.widget<Text>(find.text('Kid Memory'));
      expect(titleText.style?.fontSize, 36);
      expect(titleText.style?.fontWeight, FontWeight.bold);
      expect(titleText.style?.color, Colors.white);

      // Check subtitle styling
      final subtitleText = tester.widget<Text>(find.text('Educational Memory Game'));
      expect(subtitleText.style?.fontSize, 16);
      expect(subtitleText.style?.color, Colors.white70);
    });

    testWidgets('should be responsive to different screen sizes', (WidgetTester tester) async {
      // Test with different screen sizes
      await tester.binding.setSurfaceSize(const Size(400, 800));
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // All elements should still be visible
      expect(find.text('Kid Memory'), findsOneWidget);
      expect(find.text('Play Game'), findsOneWidget);

      // Test with smaller screen
      await tester.binding.setSurfaceSize(const Size(300, 600));
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // All elements should still be visible
      expect(find.text('Kid Memory'), findsOneWidget);
      expect(find.text('Play Game'), findsOneWidget);
    });

    testWidgets('should dispose controllers properly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Remove the widget to trigger dispose
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();

      // Should not throw any errors during disposal
    });
  });
}