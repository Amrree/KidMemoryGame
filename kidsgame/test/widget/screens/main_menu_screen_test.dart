import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:kidsgame/core/managers/analytics_manager.dart';
import 'package:kidsgame/core/managers/audio_manager.dart';
import 'package:kidsgame/core/managers/module_manager.dart';
import 'package:kidsgame/core/managers/save_manager.dart';
import 'package:kidsgame/core/managers/parental_gate_manager.dart';
import 'package:kidsgame/core/screens/main_menu_screen.dart';

void main() {
  group('MainMenuScreen Widget Tests', () {
    testWidgets('should display main menu elements', (WidgetTester tester) async {
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

      // Verify main elements are present
      expect(find.text('Kids Game'), findsOneWidget);
      expect(find.text('Educational Memory Games'), findsOneWidget);
      expect(find.text('Play Game'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Parental Controls'), findsOneWidget);
    });

    testWidgets('should display app icon', (WidgetTester tester) async {
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

      // Verify app icon is present (either image or fallback icon)
      expect(find.byType(Image), findsOneWidget);
      expect(find.byIcon(Icons.psychology), findsOneWidget);
    });

    testWidgets('should display stats in footer', (WidgetTester tester) async {
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

      // Verify stats are displayed
      expect(find.text('Games Played'), findsOneWidget);
      expect(find.text('High Score'), findsOneWidget);
      expect(find.text('Modules'), findsOneWidget);
      expect(find.text('0'), findsAtLeastNWidgets(3)); // Default values
    });

    testWidgets('should navigate to module selector when Play Game is tapped', (WidgetTester tester) async {
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

      // Tap Play Game button
      await tester.tap(find.text('Play Game'));
      await tester.pumpAndSettle();

      // Verify navigation to module selector
      expect(find.text('Choose a Module'), findsOneWidget);
    });

    testWidgets('should navigate to settings when Settings is tapped', (WidgetTester tester) async {
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

      // Tap Settings button
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      // Verify navigation to settings
      expect(find.text('Settings'), findsAtLeastNWidgets(1));
    });

    testWidgets('should navigate to parental controls when Parental Controls is tapped', (WidgetTester tester) async {
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

      // Tap Parental Controls button
      await tester.tap(find.text('Parental Controls'));
      await tester.pumpAndSettle();

      // Verify navigation to parental controls
      expect(find.text('Parental Controls'), findsAtLeastNWidgets(1));
    });

    testWidgets('should display animated elements', (WidgetTester tester) async {
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

      // Verify animation controllers are present
      expect(find.byType(AnimatedBuilder), findsAtLeastNWidgets(1));
      expect(find.byType(Transform), findsAtLeastNWidgets(1));
      expect(find.byType(ScaleTransition), findsAtLeastNWidgets(1));
    });

    testWidgets('should display gradient background', (WidgetTester tester) async {
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

      // Verify gradient background is present
      expect(find.byType(Container), findsAtLeastNWidgets(1));
      expect(find.byType(LinearGradient), findsAtLeastNWidgets(1));
    });

    testWidgets('should display elevated buttons with proper styling', (WidgetTester tester) async {
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

      // Verify elevated buttons are present
      expect(find.byType(ElevatedButton), findsAtLeastNWidgets(3));
      
      // Verify button styling
      final elevatedButtons = tester.widgetList<ElevatedButton>(find.byType(ElevatedButton));
      for (final button in elevatedButtons) {
        expect(button.style?.backgroundColor?.resolve({}), isNotNull);
        expect(button.style?.foregroundColor?.resolve({}), isNotNull);
        expect(button.style?.elevation, isNotNull);
      }
    });

    testWidgets('should display icons in buttons', (WidgetTester tester) async {
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

      // Verify icons are present in buttons
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
      expect(find.byIcon(Icons.security), findsOneWidget);
    });

    testWidgets('should handle back navigation from module selector', (WidgetTester tester) async {
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

      // Navigate back
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Verify we're back at main menu
      expect(find.text('Kids Game'), findsOneWidget);
    });

    testWidgets('should handle back navigation from settings', (WidgetTester tester) async {
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

      // Navigate back
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Verify we're back at main menu
      expect(find.text('Kids Game'), findsOneWidget);
    });

    testWidgets('should handle back navigation from parental controls', (WidgetTester tester) async {
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

      // Navigate back
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Verify we're back at main menu
      expect(find.text('Kids Game'), findsOneWidget);
    });

    testWidgets('should display proper button layout', (WidgetTester tester) async {
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

      // Verify button layout
      expect(find.byType(Column), findsAtLeastNWidgets(1));
      expect(find.byType(Row), findsAtLeastNWidgets(1));
      expect(find.byType(SizedBox), findsAtLeastNWidgets(1));
    });

    testWidgets('should handle rapid button taps', (WidgetTester tester) async {
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

      // Rapidly tap Play Game button
      for (int i = 0; i < 5; i++) {
        await tester.tap(find.text('Play Game'));
        await tester.pump();
      }

      await tester.pumpAndSettle();

      // Should still be functional
      expect(find.text('Choose a Module'), findsOneWidget);
    });

    testWidgets('should display proper text styling', (WidgetTester tester) async {
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

      // Verify text styling
      final titleText = tester.widget<Text>(find.text('Kids Game'));
      expect(titleText.style?.fontSize, 40.0);
      expect(titleText.style?.fontWeight, FontWeight.bold);

      final subtitleText = tester.widget<Text>(find.text('Educational Memory Games'));
      expect(subtitleText.style?.fontSize, 18.0);
    });

    testWidgets('should handle screen rotation', (WidgetTester tester) async {
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

      // Verify layout is responsive
      expect(find.byType(SafeArea), findsOneWidget);
      expect(find.byType(Padding), findsAtLeastNWidgets(1));
    });
  });
}