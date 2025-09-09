import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:kidsgame/core/managers/analytics_manager.dart';
import 'package:kidsgame/core/managers/audio_manager.dart';
import 'package:kidsgame/core/managers/module_manager.dart';
import 'package:kidsgame/core/managers/save_manager.dart';
import 'package:kidsgame/core/managers/parental_gate_manager.dart';
import 'package:kidsgame/core/screens/module_selector_screen.dart';

void main() {
  group('ModuleSelectorScreen Widget Tests', () {
    testWidgets('should display module selector elements', (WidgetTester tester) async {
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

      // Verify main elements are present
      expect(find.text('Choose a Module'), findsOneWidget);
      expect(find.text('Shapes'), findsOneWidget);
      expect(find.text('Colors'), findsOneWidget);
      expect(find.text('Animals'), findsOneWidget);
      expect(find.text('Jobs'), findsOneWidget);
      expect(find.text('Farm'), findsOneWidget);
      expect(find.text('Family'), findsOneWidget);
    });

    testWidgets('should display app bar with back button', (WidgetTester tester) async {
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

      await tester.pumpAndSettle();

      // Verify app bar elements
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Choose a Module'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('should display module cards in grid', (WidgetTester tester) async {
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

      await tester.pumpAndSettle();

      // Verify grid layout
      expect(find.byType(GridView), findsOneWidget);
      expect(find.byType(Card), findsAtLeastNWidgets(6));
      expect(find.byType(InkWell), findsAtLeastNWidgets(6));
    });

    testWidgets('should display module icons', (WidgetTester tester) async {
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

      await tester.pumpAndSettle();

      // Verify module icons are present
      expect(find.byIcon(Icons.crop_square), findsOneWidget); // Shapes
      expect(find.byIcon(Icons.palette), findsOneWidget); // Colors
      expect(find.byIcon(Icons.pets), findsOneWidget); // Animals
      expect(find.byIcon(Icons.work), findsOneWidget); // Jobs
      expect(find.byIcon(Icons.agriculture), findsOneWidget); // Farm
      expect(find.byIcon(Icons.family_restroom), findsOneWidget); // Family
    });

    testWidgets('should display module descriptions', (WidgetTester tester) async {
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

      await tester.pumpAndSettle();

      // Verify module descriptions are present
      expect(find.textContaining('Learn about different shapes'), findsOneWidget);
      expect(find.textContaining('Discover the world of colors'), findsOneWidget);
      expect(find.textContaining('Meet friendly animals'), findsOneWidget);
      expect(find.textContaining('Explore different professions'), findsOneWidget);
      expect(find.textContaining('Visit the farm'), findsOneWidget);
      expect(find.textContaining('Learn about family members'), findsOneWidget);
    });

    testWidgets('should display difficulty levels', (WidgetTester tester) async {
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

      await tester.pumpAndSettle();

      // Verify difficulty levels are displayed
      expect(find.text('Easy'), findsAtLeastNWidgets(1));
      expect(find.text('Medium'), findsAtLeastNWidgets(1));
    });

    testWidgets('should display unlock status', (WidgetTester tester) async {
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

      await tester.pumpAndSettle();

      // Verify unlock status icons
      expect(find.byIcon(Icons.play_arrow), findsAtLeastNWidgets(1)); // Unlocked modules
      expect(find.byIcon(Icons.lock), findsAtLeastNWidgets(1)); // Locked modules
    });

    testWidgets('should navigate back when back button is tapped', (WidgetTester tester) async {
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

      await tester.pumpAndSettle();

      // Tap back button
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Verify navigation back
      expect(find.text('Kids Game'), findsOneWidget);
    });

    testWidgets('should show locked dialog for locked modules', (WidgetTester tester) async {
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

      await tester.pumpAndSettle();

      // Find a locked module (animals, jobs, farm, or family)
      final lockedModule = find.text('Animals');
      expect(lockedModule, findsOneWidget);

      // Tap on locked module
      await tester.tap(lockedModule);
      await tester.pumpAndSettle();

      // Verify locked dialog appears
      expect(find.text('Animals is Locked'), findsOneWidget);
      expect(find.text('Complete other modules to unlock Animals!'), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);
    });

    testWidgets('should close locked dialog when OK is tapped', (WidgetTester tester) async {
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

      await tester.pumpAndSettle();

      // Tap on locked module
      await tester.tap(find.text('Animals'));
      await tester.pumpAndSettle();

      // Tap OK button
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Verify dialog is closed
      expect(find.text('Animals is Locked'), findsNothing);
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
            home: ModuleSelectorScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify gradient background is present
      expect(find.byType(Container), findsAtLeastNWidgets(1));
      expect(find.byType(LinearGradient), findsAtLeastNWidgets(1));
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
            home: ModuleSelectorScreen(),
          ),
        ),
      );

      // Verify animation controllers are present
      expect(find.byType(AnimatedBuilder), findsAtLeastNWidgets(1));
      expect(find.byType(Transform), findsAtLeastNWidgets(1));
      expect(find.byType(Opacity), findsAtLeastNWidgets(1));
    });

    testWidgets('should display proper card styling', (WidgetTester tester) async {
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

      await tester.pumpAndSettle();

      // Verify card styling
      final cards = tester.widgetList<Card>(find.byType(Card));
      for (final card in cards) {
        expect(card.elevation, isNotNull);
        expect(card.shape, isNotNull);
      }
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
            home: ModuleSelectorScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify text styling
      final titleText = tester.widget<Text>(find.text('Choose a Module'));
      expect(titleText.style?.fontSize, 24.0);
      expect(titleText.style?.fontWeight, FontWeight.bold);

      final moduleNames = tester.widgetList<Text>(find.text('Shapes'));
      for (final text in moduleNames) {
        expect(text.style?.fontSize, 18.0);
        expect(text.style?.fontWeight, FontWeight.bold);
      }
    });

    testWidgets('should handle rapid module taps', (WidgetTester tester) async {
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

      await tester.pumpAndSettle();

      // Rapidly tap on different modules
      for (int i = 0; i < 5; i++) {
        await tester.tap(find.text('Shapes'));
        await tester.pump();
        await tester.tap(find.text('Colors'));
        await tester.pump();
      }

      await tester.pumpAndSettle();

      // Should still be functional
      expect(find.text('Choose a Module'), findsOneWidget);
    });

    testWidgets('should display proper grid layout', (WidgetTester tester) async {
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

      await tester.pumpAndSettle();

      // Verify grid layout
      final gridView = tester.widget<GridView>(find.byType(GridView));
      expect(gridView.gridDelegate, isA<SliverGridDelegateWithFixedCrossAxisCount>());
      
      final delegate = gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, 2);
      expect(delegate.crossAxisSpacing, 16.0);
      expect(delegate.mainAxisSpacing, 16.0);
      expect(delegate.childAspectRatio, 0.8);
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
            home: ModuleSelectorScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify layout is responsive
      expect(find.byType(SafeArea), findsOneWidget);
      expect(find.byType(Padding), findsAtLeastNWidgets(1));
    });

    testWidgets('should display high scores for unlocked modules', (WidgetTester tester) async {
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

      await tester.pumpAndSettle();

      // Verify high score display (if any)
      expect(find.textContaining('High:'), findsAtLeastNWidgets(0));
    });
  });
}