import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/game_module.dart';

/// Manages analytics and tracking for the game
class AnalyticsManager extends ChangeNotifier {
  static const String _boxName = 'analytics';
  late Box<GameSession> _sessionsBox;
  
  GameSession? _currentSession;
  int _totalCorrectMatches = 0;
  int _totalIncorrectMatches = 0;
  int _totalSessions = 0;

  // Getters
  GameSession? get currentSession => _currentSession;
  int get totalCorrectMatches => _totalCorrectMatches;
  int get totalIncorrectMatches => _totalIncorrectMatches;
  int get totalSessions => _totalSessions;
  double get accuracy => _totalCorrectMatches + _totalIncorrectMatches > 0 
      ? _totalCorrectMatches / (_totalCorrectMatches + _totalIncorrectMatches) 
      : 0.0;

  /// Initialize the analytics manager
  Future<void> initialize() async {
    _sessionsBox = await Hive.openBox<GameSession>(_boxName);
    _loadAnalytics();
  }

  /// Load analytics data from storage
  void _loadAnalytics() {
    _totalSessions = _sessionsBox.length;
    
    for (final session in _sessionsBox.values) {
      _totalCorrectMatches += session.correctMatches;
      _totalIncorrectMatches += session.incorrectMatches;
    }
    
    notifyListeners();
  }

  /// Start a new game session
  void startSession(String moduleId) {
    _currentSession = GameSession(
      sessionId: DateTime.now().millisecondsSinceEpoch.toString(),
      moduleId: moduleId,
      startTime: DateTime.now(),
    );
    notifyListeners();
  }

  /// End the current session
  void endSession() {
    if (_currentSession != null) {
      final endTime = DateTime.now();
      final duration = endTime.difference(_currentSession!.startTime);
      
      _currentSession = _currentSession!.copyWith(
        endTime: endTime,
        duration: duration,
      );
      
      _saveSession(_currentSession!);
      _currentSession = null;
      notifyListeners();
    }
  }

  /// Record a correct match
  void recordCorrectMatch() {
    if (_currentSession != null) {
      _currentSession = _currentSession!.copyWith(
        correctMatches: _currentSession!.correctMatches + 1,
        totalMoves: _currentSession!.totalMoves + 1,
      );
      _totalCorrectMatches++;
      notifyListeners();
    }
  }

  /// Record an incorrect match
  void recordIncorrectMatch() {
    if (_currentSession != null) {
      _currentSession = _currentSession!.copyWith(
        incorrectMatches: _currentSession!.incorrectMatches + 1,
        totalMoves: _currentSession!.totalMoves + 1,
      );
      _totalIncorrectMatches++;
      notifyListeners();
    }
  }

  /// Save session to storage
  void _saveSession(GameSession session) {
    _sessionsBox.put(session.sessionId, session);
    _totalSessions++;
  }

  /// Get analytics for a specific module
  List<GameSession> getModuleAnalytics(String moduleId) {
    return _sessionsBox.values
        .where((session) => session.moduleId == moduleId)
        .toList();
  }

  /// Get recent sessions
  List<GameSession> getRecentSessions({int limit = 10}) {
    final sessions = _sessionsBox.values.toList();
    sessions.sort((a, b) => b.startTime.compareTo(a.startTime));
    return sessions.take(limit).toList();
  }

  /// Clear all analytics data
  Future<void> clearAnalytics() async {
    await _sessionsBox.clear();
    _totalCorrectMatches = 0;
    _totalIncorrectMatches = 0;
    _totalSessions = 0;
    notifyListeners();
  }

  /// Get performance statistics
  Map<String, dynamic> getPerformanceStats() {
    final sessions = _sessionsBox.values.toList();
    if (sessions.isEmpty) {
      return {
        'totalSessions': 0,
        'averageAccuracy': 0.0,
        'averageDuration': 0.0,
        'bestAccuracy': 0.0,
        'fastestTime': 0.0,
      };
    }

    final totalAccuracy = sessions.map((s) {
      final total = s.correctMatches + s.incorrectMatches;
      return total > 0 ? s.correctMatches / total : 0.0;
    }).reduce((a, b) => a + b);

    final totalDuration = sessions
        .where((s) => s.duration != null)
        .map((s) => s.duration!.inSeconds)
        .reduce((a, b) => a + b);

    final bestAccuracy = sessions.map((s) {
      final total = s.correctMatches + s.incorrectMatches;
      return total > 0 ? s.correctMatches / total : 0.0;
    }).reduce((a, b) => a > b ? a : b);

    final fastestTime = sessions
        .where((s) => s.duration != null)
        .map((s) => s.duration!.inSeconds)
        .reduce((a, b) => a < b ? a : b);

    return {
      'totalSessions': sessions.length,
      'averageAccuracy': totalAccuracy / sessions.length,
      'averageDuration': totalDuration / sessions.length,
      'bestAccuracy': bestAccuracy,
      'fastestTime': fastestTime.toDouble(),
    };
  }

  @override
  void dispose() {
    _sessionsBox.close();
    super.dispose();
  }
}