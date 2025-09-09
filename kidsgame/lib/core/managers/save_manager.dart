import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_module.dart';

/// Manages local data persistence using Hive and SharedPreferences
class SaveManager extends ChangeNotifier {
  static final SaveManager _instance = SaveManager._internal();
  factory SaveManager() => _instance;
  SaveManager._internal();

  late Box<GameSession> _sessionBox;
  late SharedPreferences _prefs;
  
  // Game statistics
  int _totalGamesPlayed = 0;
  int _totalScore = 0;
  int _highScore = 0;
  int _totalPlayTime = 0;
  Map<String, int> _moduleScores = {};
  Map<String, int> _modulePlayCounts = {};
  List<String> _unlockedModules = [];
  Map<String, dynamic> _userSettings = {};

  // Getters
  int get totalGamesPlayed => _totalGamesPlayed;
  int get totalScore => _totalScore;
  int get highScore => _highScore;
  int get totalPlayTime => _totalPlayTime;
  Map<String, int> get moduleScores => Map.unmodifiable(_moduleScores);
  Map<String, int> get modulePlayCounts => Map.unmodifiable(_modulePlayCounts);
  List<String> get unlockedModules => List.unmodifiable(_unlockedModules);
  Map<String, dynamic> get userSettings => Map.unmodifiable(_userSettings);

  /// Initialize the save manager
  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _sessionBox = await Hive.openBox<GameSession>('game_sessions');
      await _loadData();
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing SaveManager: $e');
      }
    }
  }

  /// Load all saved data
  Future<void> _loadData() async {
    _totalGamesPlayed = _prefs.getInt('total_games_played') ?? 0;
    _totalScore = _prefs.getInt('total_score') ?? 0;
    _highScore = _prefs.getInt('high_score') ?? 0;
    _totalPlayTime = _prefs.getInt('total_play_time') ?? 0;
    
    // Load module scores
    final moduleScoresString = _prefs.getString('module_scores');
    if (moduleScoresString != null) {
      _moduleScores = Map<String, int>.from(
        Map<String, dynamic>.from(
          Uri.splitQueryString(moduleScoresString),
        ).map((k, v) => MapEntry(k, int.tryParse(v) ?? 0)),
      );
    }
    
    // Load module play counts
    final modulePlayCountsString = _prefs.getString('module_play_counts');
    if (modulePlayCountsString != null) {
      _modulePlayCounts = Map<String, int>.from(
        Map<String, dynamic>.from(
          Uri.splitQueryString(modulePlayCountsString),
        ).map((k, v) => MapEntry(k, int.tryParse(v) ?? 0)),
      );
    }
    
    // Load unlocked modules
    _unlockedModules = _prefs.getStringList('unlocked_modules') ?? [];
    
    // Load user settings
    final settingsString = _prefs.getString('user_settings');
    if (settingsString != null) {
      _userSettings = Map<String, dynamic>.from(
        Uri.splitQueryString(settingsString),
      );
    }
  }

  /// Save all data
  Future<void> _saveData() async {
    await _prefs.setInt('total_games_played', _totalGamesPlayed);
    await _prefs.setInt('total_score', _totalScore);
    await _prefs.setInt('high_score', _highScore);
    await _prefs.setInt('total_play_time', _totalPlayTime);
    
    await _prefs.setString('module_scores', Uri(queryParameters: 
        _moduleScores.map((k, v) => MapEntry(k, v.toString()))).query);
    
    await _prefs.setString('module_play_counts', Uri(queryParameters: 
        _modulePlayCounts.map((k, v) => MapEntry(k, v.toString()))).query);
    
    await _prefs.setStringList('unlocked_modules', _unlockedModules);
    
    await _prefs.setString('user_settings', Uri(queryParameters: 
        _userSettings.map((k, v) => MapEntry(k, v.toString()))).query);
  }

  /// Save a game session
  Future<void> saveGameSession(GameSession session) async {
    try {
      await _sessionBox.add(session);
      
      // Update statistics
      _totalGamesPlayed++;
      _totalScore += session.score;
      _totalPlayTime += session.durationSeconds;
      
      if (session.score > _highScore) {
        _highScore = session.score;
      }
      
      // Update module-specific stats
      _moduleScores[session.moduleId] = (_moduleScores[session.moduleId] ?? 0) + session.score;
      _modulePlayCounts[session.moduleId] = (_modulePlayCounts[session.moduleId] ?? 0) + 1;
      
      await _saveData();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error saving game session: $e');
      }
    }
  }

  /// Get high score for a specific module
  int getModuleHighScore(String moduleId) {
    return _moduleScores[moduleId] ?? 0;
  }

  /// Get play count for a specific module
  int getModulePlayCount(String moduleId) {
    return _modulePlayCounts[moduleId] ?? 0;
  }

  /// Get average score for a specific module
  double getModuleAverageScore(String moduleId) {
    final playCount = getModulePlayCount(moduleId);
    if (playCount == 0) return 0.0;
    return getModuleHighScore(moduleId) / playCount;
  }

  /// Update high score
  Future<void> updateHighScore(int score) async {
    if (score > _highScore) {
      _highScore = score;
      await _saveData();
      notifyListeners();
    }
  }

  /// Update module high score
  Future<void> updateModuleHighScore(String moduleId, int score) async {
    final currentHigh = getModuleHighScore(moduleId);
    if (score > currentHigh) {
      _moduleScores[moduleId] = score;
      await _saveData();
      notifyListeners();
    }
  }

  /// Increment games played
  Future<void> incrementGamesPlayed() async {
    _totalGamesPlayed++;
    await _saveData();
    notifyListeners();
  }

  /// Add play time
  Future<void> addPlayTime(int seconds) async {
    _totalPlayTime += seconds;
    await _saveData();
    notifyListeners();
  }

  /// Unlock a module
  Future<void> unlockModule(String moduleId) async {
    if (!_unlockedModules.contains(moduleId)) {
      _unlockedModules.add(moduleId);
      await _saveData();
      notifyListeners();
    }
  }

  /// Check if a module is unlocked
  bool isModuleUnlocked(String moduleId) {
    return _unlockedModules.contains(moduleId);
  }

  /// Save user settings
  Future<void> saveUserSettings(Map<String, dynamic> settings) async {
    _userSettings.addAll(settings);
    await _saveData();
    notifyListeners();
  }

  /// Get user setting
  T? getUserSetting<T>(String key, {T? defaultValue}) {
    final value = _userSettings[key];
    if (value is T) return value;
    return defaultValue;
  }

  /// Set user setting
  Future<void> setUserSetting(String key, dynamic value) async {
    _userSettings[key] = value;
    await _saveData();
    notifyListeners();
  }

  /// Get game sessions for a module
  List<GameSession> getModuleSessions(String moduleId) {
    return _sessionBox.values
        .where((session) => session.moduleId == moduleId)
        .toList();
  }

  /// Get recent game sessions
  List<GameSession> getRecentSessions({int limit = 10}) {
    final sessions = _sessionBox.values.toList();
    sessions.sort((a, b) => b.startTime.compareTo(a.startTime));
    return sessions.take(limit).toList();
  }

  /// Get best game sessions
  List<GameSession> getBestSessions({int limit = 10}) {
    final sessions = _sessionBox.values.toList();
    sessions.sort((a, b) => b.score.compareTo(a.score));
    return sessions.take(limit).toList();
  }

  /// Clear all data (for testing)
  Future<void> clearAllData() async {
    await _sessionBox.clear();
    await _prefs.clear();
    
    _totalGamesPlayed = 0;
    _totalScore = 0;
    _highScore = 0;
    _totalPlayTime = 0;
    _moduleScores.clear();
    _modulePlayCounts.clear();
    _unlockedModules.clear();
    _userSettings.clear();
    
    notifyListeners();
  }

  /// Export data for backup
  Map<String, dynamic> exportData() {
    return {
      'totalGamesPlayed': _totalGamesPlayed,
      'totalScore': _totalScore,
      'highScore': _highScore,
      'totalPlayTime': _totalPlayTime,
      'moduleScores': _moduleScores,
      'modulePlayCounts': _modulePlayCounts,
      'unlockedModules': _unlockedModules,
      'userSettings': _userSettings,
      'sessions': _sessionBox.values.map((s) => {
        'moduleId': s.moduleId,
        'startTime': s.startTime.toIso8601String(),
        'endTime': s.endTime?.toIso8601String(),
        'score': s.score,
        'moves': s.moves,
        'correctMatches': s.correctMatches,
        'incorrectMatches': s.incorrectMatches,
        'completed': s.completed,
        'metadata': s.metadata,
      }).toList(),
    };
  }

  /// Import data from backup
  Future<void> importData(Map<String, dynamic> data) async {
    _totalGamesPlayed = data['totalGamesPlayed'] ?? 0;
    _totalScore = data['totalScore'] ?? 0;
    _highScore = data['highScore'] ?? 0;
    _totalPlayTime = data['totalPlayTime'] ?? 0;
    _moduleScores = Map<String, int>.from(data['moduleScores'] ?? {});
    _modulePlayCounts = Map<String, int>.from(data['modulePlayCounts'] ?? {});
    _unlockedModules = List<String>.from(data['unlockedModules'] ?? []);
    _userSettings = Map<String, dynamic>.from(data['userSettings'] ?? {});
    
    // Import sessions
    await _sessionBox.clear();
    final sessions = data['sessions'] as List<dynamic>? ?? [];
    for (final sessionData in sessions) {
      final session = GameSession(
        moduleId: sessionData['moduleId'],
        startTime: DateTime.parse(sessionData['startTime']),
        endTime: sessionData['endTime'] != null 
            ? DateTime.parse(sessionData['endTime']) 
            : null,
        score: sessionData['score'] ?? 0,
        moves: sessionData['moves'] ?? 0,
        correctMatches: sessionData['correctMatches'] ?? 0,
        incorrectMatches: sessionData['incorrectMatches'] ?? 0,
        completed: sessionData['completed'] ?? false,
        metadata: Map<String, dynamic>.from(sessionData['metadata'] ?? {}),
      );
      await _sessionBox.add(session);
    }
    
    await _saveData();
    notifyListeners();
  }

  @override
  void dispose() {
    _sessionBox.close();
    super.dispose();
  }
}