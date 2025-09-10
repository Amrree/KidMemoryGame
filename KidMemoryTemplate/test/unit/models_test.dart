import 'package:flutter_test/flutter_test.dart';
import 'package:kid_memory_template/core/models/game_module.dart';

void main() {
  group('GameModule Tests', () {
    late GameModule testModule;

    setUp(() {
      testModule = GameModule(
        id: 'test_module',
        name: 'Test Module',
        description: 'A test module for unit testing',
        iconPath: 'assets/test/icon.png',
        backgroundPath: 'assets/test/background.png',
        cardPaths: ['card1.png', 'card2.png', 'card3.png'],
        isUnlocked: true,
        difficultyLevel: 2,
        audioPaths: ['audio1.mp3', 'audio2.mp3'],
      );
    });

    test('should create GameModule with correct properties', () {
      expect(testModule.id, 'test_module');
      expect(testModule.name, 'Test Module');
      expect(testModule.description, 'A test module for unit testing');
      expect(testModule.iconPath, 'assets/test/icon.png');
      expect(testModule.backgroundPath, 'assets/test/background.png');
      expect(testModule.cardPaths, ['card1.png', 'card2.png', 'card3.png']);
      expect(testModule.isUnlocked, true);
      expect(testModule.difficultyLevel, 2);
      expect(testModule.audioPaths, ['audio1.mp3', 'audio2.mp3']);
    });

    test('should create copy with updated fields', () {
      final updatedModule = testModule.copyWith(
        name: 'Updated Module',
        isUnlocked: false,
        difficultyLevel: 3,
      );

      expect(updatedModule.id, 'test_module'); // unchanged
      expect(updatedModule.name, 'Updated Module'); // changed
      expect(updatedModule.description, 'A test module for unit testing'); // unchanged
      expect(updatedModule.isUnlocked, false); // changed
      expect(updatedModule.difficultyLevel, 3); // changed
    });

    test('should handle null values in copyWith', () {
      final updatedModule = testModule.copyWith(name: null);
      expect(updatedModule.name, 'Test Module'); // should remain unchanged
    });

    test('should create module with default values', () {
      final defaultModule = GameModule(
        id: 'default',
        name: 'Default',
        description: 'Default description',
        iconPath: 'icon.png',
        backgroundPath: 'background.png',
        cardPaths: ['card.png'],
      );

      expect(defaultModule.isUnlocked, false);
      expect(defaultModule.difficultyLevel, 1);
      expect(defaultModule.audioPaths, []);
    });
  });

  group('GameCard Tests', () {
    late GameCard testCard;

    setUp(() {
      testCard = GameCard(
        id: 'card_1',
        imagePath: 'assets/cards/card1.png',
        audioPath: 'assets/audio/card1.mp3',
        name: 'Test Card',
        isMatched: false,
        isFlipped: false,
      );
    });

    test('should create GameCard with correct properties', () {
      expect(testCard.id, 'card_1');
      expect(testCard.imagePath, 'assets/cards/card1.png');
      expect(testCard.audioPath, 'assets/audio/card1.mp3');
      expect(testCard.name, 'Test Card');
      expect(testCard.isMatched, false);
      expect(testCard.isFlipped, false);
    });

    test('should create copy with updated fields', () {
      final updatedCard = testCard.copyWith(
        isMatched: true,
        isFlipped: true,
        name: 'Updated Card',
      );

      expect(updatedCard.id, 'card_1'); // unchanged
      expect(updatedCard.name, 'Updated Card'); // changed
      expect(updatedCard.isMatched, true); // changed
      expect(updatedCard.isFlipped, true); // changed
    });

    test('should handle null values in copyWith', () {
      final updatedCard = testCard.copyWith(name: null);
      expect(updatedCard.name, 'Test Card'); // should remain unchanged
    });

    test('should create card with default values', () {
      final defaultCard = GameCard(
        id: 'default',
        imagePath: 'image.png',
        audioPath: 'audio.mp3',
        name: 'Default',
      );

      expect(defaultCard.isMatched, false);
      expect(defaultCard.isFlipped, false);
    });
  });

  group('GameSession Tests', () {
    late GameSession testSession;

    setUp(() {
      testSession = GameSession(
        sessionId: 'session_123',
        moduleId: 'test_module',
        startTime: DateTime(2024, 1, 1, 10, 0, 0),
        endTime: DateTime(2024, 1, 1, 10, 5, 0),
        correctMatches: 5,
        incorrectMatches: 2,
        totalMoves: 7,
        duration: const Duration(minutes: 5),
      );
    });

    test('should create GameSession with correct properties', () {
      expect(testSession.sessionId, 'session_123');
      expect(testSession.moduleId, 'test_module');
      expect(testSession.startTime, DateTime(2024, 1, 1, 10, 0, 0));
      expect(testSession.endTime, DateTime(2024, 1, 1, 10, 5, 0));
      expect(testSession.correctMatches, 5);
      expect(testSession.incorrectMatches, 2);
      expect(testSession.totalMoves, 7);
      expect(testSession.duration, const Duration(minutes: 5));
    });

    test('should create copy with updated fields', () {
      final updatedSession = testSession.copyWith(
        correctMatches: 10,
        totalMoves: 12,
        endTime: DateTime(2024, 1, 1, 10, 10, 0),
      );

      expect(updatedSession.sessionId, 'session_123'); // unchanged
      expect(updatedSession.correctMatches, 10); // changed
      expect(updatedSession.totalMoves, 12); // changed
      expect(updatedSession.endTime, DateTime(2024, 1, 1, 10, 10, 0)); // changed
    });

    test('should create session with default values', () {
      final defaultSession = GameSession(
        sessionId: 'default',
        moduleId: 'default_module',
        startTime: DateTime.now(),
      );

      expect(defaultSession.endTime, null);
      expect(defaultSession.correctMatches, 0);
      expect(defaultSession.incorrectMatches, 0);
      expect(defaultSession.totalMoves, 0);
      expect(defaultSession.duration, null);
    });

    test('should handle null values in copyWith', () {
      final updatedSession = testSession.copyWith(endTime: null);
      expect(updatedSession.endTime, null);
    });
  });
}