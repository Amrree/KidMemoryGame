import 'package:flutter/foundation.dart';
import '../models/game_module.dart';

/// Manages analytics and tracking for the game
class AnalyticsManager extends ChangeNotifier {
  static final AnalyticsManager _instance = AnalyticsManager._internal();
  factory AnalyticsManager() => _instance;
  AnalyticsManager._internal();

  GameSession? _currentSession;
  final List<GameEvent> _events = [];
  bool _isTrackingEnabled = true;
  String? _userId;
  Map<String, dynamic> _userProperties = {};

  // Getters
  GameSession? get currentSession => _currentSession;
  List<GameEvent> get events => List.unmodifiable(_events);
  bool get isTrackingEnabled => _isTrackingEnabled;
  String? get userId => _userId;

  /// Initialize the analytics manager
  Future<void> init() async {
    // In a real implementation, this would initialize Firebase Analytics
    // or another analytics service
    if (kDebugMode) {
      print('AnalyticsManager initialized');
    }
  }

  /// Set tracking enabled/disabled
  void setTrackingEnabled(bool enabled) {
    _isTrackingEnabled = enabled;
    notifyListeners();
  }

  /// Set user ID
  void setUserId(String? id) {
    _userId = id;
    if (kDebugMode) {
      print('User ID set: $id');
    }
  }

  /// Set user properties
  void setUserProperties(Map<String, dynamic> properties) {
    _userProperties.addAll(properties);
    if (kDebugMode) {
      print('User properties set: $properties');
    }
  }

  /// Start a new game session
  void startSession(String moduleId) {
    if (!_isTrackingEnabled) return;
    
    _currentSession = GameSession(
      moduleId: moduleId,
      startTime: DateTime.now(),
      metadata: {
        'userId': _userId,
        'userProperties': _userProperties,
      },
    );
    
    _logEvent('session_started', {
      'module_id': moduleId,
      'timestamp': DateTime.now().toIso8601String(),
    });
    
    if (kDebugMode) {
      print('Session started for module: $moduleId');
    }
  }

  /// End the current session
  void endSession() {
    if (!_isTrackingEnabled || _currentSession == null) return;
    
    _currentSession!.complete();
    
    _logEvent('session_ended', {
      'module_id': _currentSession!.moduleId,
      'duration_seconds': _currentSession!.durationSeconds,
      'score': _currentSession!.score,
      'moves': _currentSession!.moves,
      'completed': _currentSession!.completed,
      'accuracy': _currentSession!.accuracy,
    });
    
    if (kDebugMode) {
      print('Session ended: ${_currentSession!.moduleId}');
    }
    
    _currentSession = null;
  }

  /// Record a card flip
  void recordCardFlip(String cardId) {
    if (!_isTrackingEnabled) return;
    
    _logEvent('card_flipped', {
      'card_id': cardId,
      'timestamp': DateTime.now().toIso8601String(),
    });
    
    if (_currentSession != null) {
      _currentSession!.moves++;
    }
  }

  /// Record a match
  void recordMatch(String cardId1, String cardId2, bool isCorrect) {
    if (!_isTrackingEnabled) return;
    
    _logEvent('match_attempted', {
      'card_id_1': cardId1,
      'card_id_2': cardId2,
      'is_correct': isCorrect,
      'timestamp': DateTime.now().toIso8601String(),
    });
    
    if (_currentSession != null) {
      if (isCorrect) {
        _currentSession!.correctMatches++;
        _currentSession!.score += 10; // Award points for correct match
      } else {
        _currentSession!.incorrectMatches++;
        _currentSession!.score = (_currentSession!.score - 2).clamp(0, double.infinity).toInt();
      }
    }
  }

  /// Record module unlock
  void recordModuleUnlock(String moduleId) {
    if (!_isTrackingEnabled) return;
    
    _logEvent('module_unlocked', {
      'module_id': moduleId,
      'timestamp': DateTime.now().toIso8601String(),
    });
    
    if (kDebugMode) {
      print('Module unlocked: $moduleId');
    }
  }

  /// Record achievement
  void recordAchievement(String achievementId, String achievementName) {
    if (!_isTrackingEnabled) return;
    
    _logEvent('achievement_unlocked', {
      'achievement_id': achievementId,
      'achievement_name': achievementName,
      'timestamp': DateTime.now().toIso8601String(),
    });
    
    if (kDebugMode) {
      print('Achievement unlocked: $achievementName');
    }
  }

  /// Record game completion
  void recordGameCompletion(String moduleId, int score, int moves, int duration) {
    if (!_isTrackingEnabled) return;
    
    _logEvent('game_completed', {
      'module_id': moduleId,
      'score': score,
      'moves': moves,
      'duration_seconds': duration,
      'timestamp': DateTime.now().toIso8601String(),
    });
    
    if (kDebugMode) {
      print('Game completed: $moduleId with score $score');
    }
  }

  /// Record user interaction
  void recordUserInteraction(String interactionType, Map<String, dynamic> properties) {
    if (!_isTrackingEnabled) return;
    
    _logEvent('user_interaction', {
      'interaction_type': interactionType,
      'properties': properties,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Record error
  void recordError(String errorType, String errorMessage, {Map<String, dynamic>? context}) {
    if (!_isTrackingEnabled) return;
    
    _logEvent('error_occurred', {
      'error_type': errorType,
      'error_message': errorMessage,
      'context': context ?? {},
      'timestamp': DateTime.now().toIso8601String(),
    });
    
    if (kDebugMode) {
      print('Error recorded: $errorType - $errorMessage');
    }
  }

  /// Record custom event
  void recordCustomEvent(String eventName, Map<String, dynamic> parameters) {
    if (!_isTrackingEnabled) return;
    
    _logEvent(eventName, {
      ...parameters,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Log an event internally
  void _logEvent(String eventName, Map<String, dynamic> parameters) {
    final event = GameEvent(
      name: eventName,
      parameters: parameters,
      timestamp: DateTime.now(),
    );
    
    _events.add(event);
    
    // In a real implementation, this would send the event to an analytics service
    if (kDebugMode) {
      print('Event logged: $eventName with parameters: $parameters');
    }
  }

  /// Get events by type
  List<GameEvent> getEventsByType(String eventType) {
    return _events.where((event) => event.name == eventType).toList();
  }

  /// Get events for a specific module
  List<GameEvent> getEventsForModule(String moduleId) {
    return _events.where((event) => 
        event.parameters['module_id'] == moduleId).toList();
  }

  /// Get events in time range
  List<GameEvent> getEventsInRange(DateTime start, DateTime end) {
    return _events.where((event) => 
        event.timestamp.isAfter(start) && event.timestamp.isBefore(end)).toList();
  }

  /// Clear all events (for testing)
  void clearEvents() {
    _events.clear();
    if (kDebugMode) {
      print('All events cleared');
    }
  }

  /// Get analytics summary
  Map<String, dynamic> getAnalyticsSummary() {
    final totalEvents = _events.length;
    final sessionEvents = getEventsByType('session_started').length;
    final matchEvents = getEventsByType('match_attempted').length;
    final correctMatches = _events
        .where((e) => e.name == 'match_attempted' && e.parameters['is_correct'] == true)
        .length;
    final incorrectMatches = _events
        .where((e) => e.name == 'match_attempted' && e.parameters['is_correct'] == false)
        .length;
    
    return {
      'totalEvents': totalEvents,
      'sessionsStarted': sessionEvents,
      'matchAttempts': matchEvents,
      'correctMatches': correctMatches,
      'incorrectMatches': incorrectMatches,
      'accuracy': matchEvents > 0 ? (correctMatches / matchEvents) * 100 : 0.0,
      'trackingEnabled': _isTrackingEnabled,
      'userId': _userId,
    };
  }
}

/// Represents a game event for analytics
class GameEvent {
  final String name;
  final Map<String, dynamic> parameters;
  final DateTime timestamp;

  GameEvent({
    required this.name,
    required this.parameters,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'GameEvent(name: $name, parameters: $parameters, timestamp: $timestamp)';
  }
}