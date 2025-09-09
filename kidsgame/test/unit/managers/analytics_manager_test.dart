import 'package:flutter_test/flutter_test.dart';
import 'package:kidsgame/core/managers/analytics_manager.dart';

void main() {
  group('AnalyticsManager Unit Tests', () {
    late AnalyticsManager analyticsManager;

    setUp(() {
      analyticsManager = AnalyticsManager();
    });

    tearDown(() {
      analyticsManager.dispose();
    });

    test('should initialize with default values', () async {
      await analyticsManager.init();
      
      expect(analyticsManager.currentSession, null);
      expect(analyticsManager.events, isEmpty);
      expect(analyticsManager.isTrackingEnabled, true);
      expect(analyticsManager.userId, null);
    });

    test('should set tracking enabled/disabled', () async {
      await analyticsManager.init();
      
      analyticsManager.setTrackingEnabled(false);
      expect(analyticsManager.isTrackingEnabled, false);
      
      analyticsManager.setTrackingEnabled(true);
      expect(analyticsManager.isTrackingEnabled, true);
    });

    test('should set user ID', () async {
      await analyticsManager.init();
      
      analyticsManager.setUserId('test_user_123');
      expect(analyticsManager.userId, 'test_user_123');
      
      analyticsManager.setUserId(null);
      expect(analyticsManager.userId, null);
    });

    test('should set user properties', () async {
      await analyticsManager.init();
      
      final properties = {
        'age': 5,
        'grade': 'kindergarten',
        'parent_consent': true,
      };
      
      analyticsManager.setUserProperties(properties);
      // Note: User properties are stored internally and used in session metadata
    });

    test('should start and end session', () async {
      await analyticsManager.init();
      
      analyticsManager.startSession('shapes');
      expect(analyticsManager.currentSession, isNotNull);
      expect(analyticsManager.currentSession!.moduleId, 'shapes');
      expect(analyticsManager.currentSession!.startTime, isNotNull);
      
      analyticsManager.endSession();
      expect(analyticsManager.currentSession, null);
    });

    test('should record card flip', () async {
      await analyticsManager.init();
      
      analyticsManager.startSession('shapes');
      analyticsManager.recordCardFlip('card1');
      
      expect(analyticsManager.currentSession!.moves, 1);
      
      final cardFlipEvents = analyticsManager.getEventsByType('card_flipped');
      expect(cardFlipEvents.length, 1);
      expect(cardFlipEvents.first.parameters['card_id'], 'card1');
    });

    test('should record match correctly', () async {
      await analyticsManager.init();
      
      analyticsManager.startSession('shapes');
      analyticsManager.recordMatch('card1', 'card2', true);
      
      expect(analyticsManager.currentSession!.correctMatches, 1);
      expect(analyticsManager.currentSession!.score, 10);
      
      final matchEvents = analyticsManager.getEventsByType('match_attempted');
      expect(matchEvents.length, 1);
      expect(matchEvents.first.parameters['is_correct'], true);
    });

    test('should record mismatch correctly', () async {
      await analyticsManager.init();
      
      analyticsManager.startSession('shapes');
      analyticsManager.recordMatch('card1', 'card2', false);
      
      expect(analyticsManager.currentSession!.incorrectMatches, 1);
      expect(analyticsManager.currentSession!.score, -2);
      
      final matchEvents = analyticsManager.getEventsByType('match_attempted');
      expect(matchEvents.length, 1);
      expect(matchEvents.first.parameters['is_correct'], false);
    });

    test('should record module unlock', () async {
      await analyticsManager.init();
      
      analyticsManager.recordModuleUnlock('animals');
      
      final unlockEvents = analyticsManager.getEventsByType('module_unlocked');
      expect(unlockEvents.length, 1);
      expect(unlockEvents.first.parameters['module_id'], 'animals');
    });

    test('should record achievement', () async {
      await analyticsManager.init();
      
      analyticsManager.recordAchievement('first_match', 'First Match!');
      
      final achievementEvents = analyticsManager.getEventsByType('achievement_unlocked');
      expect(achievementEvents.length, 1);
      expect(achievementEvents.first.parameters['achievement_id'], 'first_match');
      expect(achievementEvents.first.parameters['achievement_name'], 'First Match!');
    });

    test('should record game completion', () async {
      await analyticsManager.init();
      
      analyticsManager.recordGameCompletion('shapes', 100, 10, 60);
      
      final completionEvents = analyticsManager.getEventsByType('game_completed');
      expect(completionEvents.length, 1);
      expect(completionEvents.first.parameters['module_id'], 'shapes');
      expect(completionEvents.first.parameters['score'], 100);
      expect(completionEvents.first.parameters['moves'], 10);
      expect(completionEvents.first.parameters['duration_seconds'], 60);
    });

    test('should record user interaction', () async {
      await analyticsManager.init();
      
      final properties = {
        'button_name': 'play_button',
        'screen': 'main_menu',
        'timestamp': DateTime.now().toIso8601String(),
      };
      
      analyticsManager.recordUserInteraction('button_click', properties);
      
      final interactionEvents = analyticsManager.getEventsByType('user_interaction');
      expect(interactionEvents.length, 1);
      expect(interactionEvents.first.parameters['interaction_type'], 'button_click');
      expect(interactionEvents.first.parameters['properties'], properties);
    });

    test('should record error', () async {
      await analyticsManager.init();
      
      final context = {
        'screen': 'game_screen',
        'action': 'card_flip',
        'error_code': 'ASSET_LOAD_FAILED',
      };
      
      analyticsManager.recordError('asset_error', 'Failed to load card image', context: context);
      
      final errorEvents = analyticsManager.getEventsByType('error_occurred');
      expect(errorEvents.length, 1);
      expect(errorEvents.first.parameters['error_type'], 'asset_error');
      expect(errorEvents.first.parameters['error_message'], 'Failed to load card image');
      expect(errorEvents.first.parameters['context'], context);
    });

    test('should record custom event', () async {
      await analyticsManager.init();
      
      final parameters = {
        'custom_param1': 'value1',
        'custom_param2': 42,
        'custom_param3': true,
      };
      
      analyticsManager.recordCustomEvent('custom_event', parameters);
      
      final customEvents = analyticsManager.getEventsByType('custom_event');
      expect(customEvents.length, 1);
      expect(customEvents.first.parameters['custom_param1'], 'value1');
      expect(customEvents.first.parameters['custom_param2'], 42);
      expect(customEvents.first.parameters['custom_param3'], true);
    });

    test('should not record events when tracking disabled', () async {
      await analyticsManager.init();
      
      analyticsManager.setTrackingEnabled(false);
      
      analyticsManager.startSession('shapes');
      analyticsManager.recordCardFlip('card1');
      analyticsManager.recordMatch('card1', 'card2', true);
      
      expect(analyticsManager.events, isEmpty);
    });

    test('should get events by type', () async {
      await analyticsManager.init();
      
      analyticsManager.recordCardFlip('card1');
      analyticsManager.recordCardFlip('card2');
      analyticsManager.recordMatch('card1', 'card2', true);
      
      final cardFlipEvents = analyticsManager.getEventsByType('card_flipped');
      expect(cardFlipEvents.length, 2);
      
      final matchEvents = analyticsManager.getEventsByType('match_attempted');
      expect(matchEvents.length, 1);
    });

    test('should get events for module', () async {
      await analyticsManager.init();
      
      analyticsManager.startSession('shapes');
      analyticsManager.recordCardFlip('card1');
      analyticsManager.recordMatch('card1', 'card2', true);
      
      analyticsManager.startSession('colors');
      analyticsManager.recordCardFlip('card3');
      
      final shapesEvents = analyticsManager.getEventsForModule('shapes');
      expect(shapesEvents.length, 3); // session_started, card_flipped, match_attempted
      
      final colorsEvents = analyticsManager.getEventsForModule('colors');
      expect(colorsEvents.length, 2); // session_started, card_flipped
    });

    test('should get events in time range', () async {
      await analyticsManager.init();
      
      final startTime = DateTime.now();
      
      analyticsManager.recordCardFlip('card1');
      
      // Wait a bit
      await Future.delayed(const Duration(milliseconds: 100));
      
      final midTime = DateTime.now();
      
      analyticsManager.recordCardFlip('card2');
      
      // Wait a bit
      await Future.delayed(const Duration(milliseconds: 100));
      
      final endTime = DateTime.now();
      
      analyticsManager.recordCardFlip('card3');
      
      final earlyEvents = analyticsManager.getEventsInRange(startTime, midTime);
      expect(earlyEvents.length, 1);
      
      final lateEvents = analyticsManager.getEventsInRange(midTime, endTime);
      expect(lateEvents.length, 1);
      
      final allEvents = analyticsManager.getEventsInRange(startTime, endTime);
      expect(allEvents.length, 2);
    });

    test('should clear events', () async {
      await analyticsManager.init();
      
      analyticsManager.recordCardFlip('card1');
      analyticsManager.recordMatch('card1', 'card2', true);
      
      expect(analyticsManager.events.length, 2);
      
      analyticsManager.clearEvents();
      
      expect(analyticsManager.events, isEmpty);
    });

    test('should get analytics summary', () async {
      await analyticsManager.init();
      
      analyticsManager.startSession('shapes');
      analyticsManager.recordCardFlip('card1');
      analyticsManager.recordMatch('card1', 'card2', true);
      analyticsManager.recordMatch('card3', 'card4', false);
      analyticsManager.endSession();
      
      final summary = analyticsManager.getAnalyticsSummary();
      
      expect(summary['totalEvents'], 4);
      expect(summary['sessionsStarted'], 1);
      expect(summary['matchAttempts'], 2);
      expect(summary['correctMatches'], 1);
      expect(summary['incorrectMatches'], 1);
      expect(summary['accuracy'], 50.0);
      expect(summary['trackingEnabled'], true);
    });

    test('should handle rapid event recording', () async {
      await analyticsManager.init();
      
      // Record many events rapidly
      for (int i = 0; i < 100; i++) {
        analyticsManager.recordCardFlip('card$i');
        analyticsManager.recordMatch('card$i', 'card${i + 1}', i % 2 == 0);
      }
      
      expect(analyticsManager.events.length, 200);
      
      final cardFlipEvents = analyticsManager.getEventsByType('card_flipped');
      expect(cardFlipEvents.length, 100);
      
      final matchEvents = analyticsManager.getEventsByType('match_attempted');
      expect(matchEvents.length, 100);
    });

    test('should handle concurrent operations', () async {
      await analyticsManager.init();
      
      // Simulate concurrent operations
      final futures = <Future>[];
      
      for (int i = 0; i < 10; i++) {
        futures.add(Future(() {
          analyticsManager.recordCardFlip('card$i');
          analyticsManager.recordMatch('card$i', 'card${i + 1}', true);
        }));
      }
      
      await Future.wait(futures);
      
      expect(analyticsManager.events.length, 20);
    });

    test('should handle session without starting', () async {
      await analyticsManager.init();
      
      // Try to record events without starting session
      analyticsManager.recordCardFlip('card1');
      analyticsManager.recordMatch('card1', 'card2', true);
      
      // Should not crash and events should still be recorded
      expect(analyticsManager.events.length, 2);
    });

    test('should handle multiple sessions', () async {
      await analyticsManager.init();
      
      // Start first session
      analyticsManager.startSession('shapes');
      analyticsManager.recordCardFlip('card1');
      analyticsManager.endSession();
      
      // Start second session
      analyticsManager.startSession('colors');
      analyticsManager.recordCardFlip('card2');
      analyticsManager.endSession();
      
      expect(analyticsManager.events.length, 4); // 2 session_started, 2 card_flipped
      
      final shapesEvents = analyticsManager.getEventsForModule('shapes');
      expect(shapesEvents.length, 2);
      
      final colorsEvents = analyticsManager.getEventsForModule('colors');
      expect(colorsEvents.length, 2);
    });
  });
}