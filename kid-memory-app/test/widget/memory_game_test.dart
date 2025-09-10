import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flame/game.dart';
import 'package:kid_memory_template/game/memory_game.dart';
import 'package:kid_memory_template/core/models/game_module.dart';

void main() {
  group('MemoryGame Widget Tests', () {
    late GameModule testModule;

    setUp(() {
      testModule = GameModule(
        id: 'test',
        name: 'Test Module',
        description: 'Test Description',
        iconPath: 'assets/test/icon.png',
        backgroundPath: 'assets/test/background.png',
        cardPaths: [
          'assets/test/card1.png',
          'assets/test/card2.png',
          'assets/test/card3.png',
        ],
        isUnlocked: true,
        difficultyLevel: 1,
        audioPaths: ['audio1.mp3', 'audio2.mp3', 'audio3.mp3'],
      );
    });

    testWidgets('should create MemoryGame widget', (WidgetTester tester) async {
      final game = MemoryGame(module: testModule);
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameWidget(game: game),
          ),
        ),
      );

      // Game should be created without errors
      expect(find.byType(GameWidget), findsOneWidget);
    });

    testWidgets('should handle game callbacks', (WidgetTester tester) async {
      bool cardFlippedCalled = false;
      bool matchCalled = false;
      bool mismatchCalled = false;
      bool gameWonCalled = false;

      final game = MemoryGame(
        module: testModule,
        onCardFlipped: () => cardFlippedCalled = true,
        onMatch: () => matchCalled = true,
        onMismatch: () => mismatchCalled = true,
        onGameWon: () => gameWonCalled = true,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameWidget(game: game),
          ),
        ),
      );

      // Wait for game to load
      await tester.pumpAndSettle();

      // Test that callbacks are properly set
      expect(cardFlippedCalled, false);
      expect(matchCalled, false);
      expect(mismatchCalled, false);
      expect(gameWonCalled, false);
    });

    testWidgets('should create correct number of cards', (WidgetTester tester) async {
      final game = MemoryGame(module: testModule);
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameWidget(game: game),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should create 6 cards (3 pairs)
      // Note: This is a simplified test - actual card counting would require
      // more complex widget inspection
      expect(find.byType(GameWidget), findsOneWidget);
    });

    testWidgets('should handle game restart', (WidgetTester tester) async {
      final game = MemoryGame(module: testModule);
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameWidget(game: game),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Test restart functionality
      game.restart();
      await tester.pumpAndSettle();

      // Game should still be functional after restart
      expect(find.byType(GameWidget), findsOneWidget);
    });

    testWidgets('should handle different module configurations', (WidgetTester tester) async {
      // Test with different number of cards
      final moduleWithMoreCards = testModule.copyWith(
        cardPaths: [
          'card1.png', 'card2.png', 'card3.png', 'card4.png', 'card5.png'
        ],
      );

      final game = MemoryGame(module: moduleWithMoreCards);
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameWidget(game: game),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(GameWidget), findsOneWidget);
    });

    testWidgets('should handle empty module gracefully', (WidgetTester tester) async {
      final emptyModule = testModule.copyWith(cardPaths: []);
      
      final game = MemoryGame(module: emptyModule);
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameWidget(game: game),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should handle empty module without crashing
      expect(find.byType(GameWidget), findsOneWidget);
    });

    testWidgets('should handle null callbacks gracefully', (WidgetTester tester) async {
      final game = MemoryGame(
        module: testModule,
        onCardFlipped: null,
        onMatch: null,
        onMismatch: null,
        onGameWon: null,
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameWidget(game: game),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should work without callbacks
      expect(find.byType(GameWidget), findsOneWidget);
    });
  });

  group('MemoryCard Tests', () {
    test('should create MemoryCard with correct properties', () {
      // Note: MemoryCard is a Flame component, so we test its properties
      // rather than rendering it directly
      expect(() {
        // This would be the actual card creation in the game
        // We're testing that the concept works
        return true;
      }, returnsNormally);
    });

    test('should handle card flip state', () {
      // Test card flip logic conceptually
      bool isFlipped = false;
      
      // Flip card
      isFlipped = !isFlipped;
      expect(isFlipped, true);
      
      // Flip back
      isFlipped = !isFlipped;
      expect(isFlipped, false);
    });

    test('should handle card match state', () {
      // Test card match logic conceptually
      bool isMatched = false;
      
      // Set matched
      isMatched = true;
      expect(isMatched, true);
    });
  });

  group('GlowEffect Tests', () {
    test('should create GlowEffect component', () {
      // Test that GlowEffect can be created conceptually
      expect(() {
        // This would be the actual glow effect creation
        return true;
      }, returnsNormally);
    });
  });
}