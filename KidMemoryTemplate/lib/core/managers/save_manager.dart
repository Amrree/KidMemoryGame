import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_module.dart';

/// Manages save data and game progress
class SaveManager extends ChangeNotifier {
  static const String _boxName = 'saveData';
  late Box<Map> _saveBox;
  late SharedPreferences _prefs;
  
  // Game settings
  bool _soundEnabled = true;
  bool _musicEnabled = true;
  double _soundVolume = 1.0;
  double _musicVolume = 0.7;
  int _selectedDifficulty = 1;
  String? _lastPlayedModule;
  int _totalPlayTime = 0;
  int _gamesPlayed = 0;
  int _highScore = 0;

  // Getters
  bool get soundEnabled => _soundEnabled;
  bool get musicEnabled => _musicEnabled;
  double get soundVolume => _soundVolume;
  double get musicVolume => _musicVolume;
  int get selectedDifficulty => _selectedDifficulty;
  String? get lastPlayedModule => _lastPlayedModule;
  int get totalPlayTime => _totalPlayTime;
  int get gamesPlayed => _gamesPlayed;
  int get highScore => _highScore;

  /// Initialize the save manager
  Future<void> initialize() async {
    _saveBox = await Hive.openBox<Map>(_boxName);
    _prefs = await SharedPreferences.getInstance();
    await _loadSettings();
  }

  /// Load settings from storage
  Future<void> _loadSettings() async {
    _soundEnabled = _prefs.getBool('soundEnabled') ?? true;
    _musicEnabled = _prefs.getBool('musicEnabled') ?? true;
    _soundVolume = _prefs.getDouble('soundVolume') ?? 1.0;
    _musicVolume = _prefs.getDouble('musicVolume') ?? 0.7;
    _selectedDifficulty = _prefs.getInt('selectedDifficulty') ?? 1;
    _lastPlayedModule = _prefs.getString('lastPlayedModule');
    _totalPlayTime = _prefs.getInt('totalPlayTime') ?? 0;
    _gamesPlayed = _prefs.getInt('gamesPlayed') ?? 0;
    _highScore = _prefs.getInt('highScore') ?? 0;
    notifyListeners();
  }

  /// Save settings to storage
  Future<void> _saveSettings() async {
    await _prefs.setBool('soundEnabled', _soundEnabled);
    await _prefs.setBool('musicEnabled', _musicEnabled);
    await _prefs.setDouble('soundVolume', _soundVolume);
    await _prefs.setDouble('musicVolume', _musicVolume);
    await _prefs.setInt('selectedDifficulty', _selectedDifficulty);
    if (_lastPlayedModule != null) {
      await _prefs.setString('lastPlayedModule', _lastPlayedModule!);
    }
    await _prefs.setInt('totalPlayTime', _totalPlayTime);
    await _prefs.setInt('gamesPlayed', _gamesPlayed);
    await _prefs.setInt('highScore', _highScore);
  }

  /// Set sound enabled/disabled
  Future<void> setSoundEnabled(bool enabled) async {
    _soundEnabled = enabled;
    await _prefs.setBool('soundEnabled', enabled);
    notifyListeners();
  }

  /// Set music enabled/disabled
  Future<void> setMusicEnabled(bool enabled) async {
    _musicEnabled = enabled;
    await _prefs.setBool('musicEnabled', enabled);
    notifyListeners();
  }

  /// Set sound volume
  Future<void> setSoundVolume(double volume) async {
    _soundVolume = volume.clamp(0.0, 1.0);
    await _prefs.setDouble('soundVolume', _soundVolume);
    notifyListeners();
  }

  /// Set music volume
  Future<void> setMusicVolume(double volume) async {
    _musicVolume = volume.clamp(0.0, 1.0);
    await _prefs.setDouble('musicVolume', _musicVolume);
    notifyListeners();
  }

  /// Set selected difficulty
  Future<void> setSelectedDifficulty(int difficulty) async {
    _selectedDifficulty = difficulty;
    await _prefs.setInt('selectedDifficulty', difficulty);
    notifyListeners();
  }

  /// Set last played module
  Future<void> setLastPlayedModule(String moduleId) async {
    _lastPlayedModule = moduleId;
    await _prefs.setString('lastPlayedModule', moduleId);
    notifyListeners();
  }

  /// Add play time
  Future<void> addPlayTime(int seconds) async {
    _totalPlayTime += seconds;
    await _prefs.setInt('totalPlayTime', _totalPlayTime);
    notifyListeners();
  }

  /// Increment games played
  Future<void> incrementGamesPlayed() async {
    _gamesPlayed++;
    await _prefs.setInt('gamesPlayed', _gamesPlayed);
    notifyListeners();
  }

  /// Update high score
  Future<void> updateHighScore(int score) async {
    if (score > _highScore) {
      _highScore = score;
      await _prefs.setInt('highScore', _highScore);
      notifyListeners();
    }
  }

  /// Save game progress for a specific module
  Future<void> saveModuleProgress(String moduleId, Map<String, dynamic> progress) async {
    await _saveBox.put('module_$moduleId', progress);
  }

  /// Load game progress for a specific module
  Map<String, dynamic>? getModuleProgress(String moduleId) {
    return _saveBox.get('module_$moduleId')?.cast<String, dynamic>();
  }

  /// Save game state
  Future<void> saveGameState(Map<String, dynamic> gameState) async {
    await _saveBox.put('currentGame', gameState);
  }

  /// Load game state
  Map<String, dynamic>? getGameState() {
    return _saveBox.get('currentGame')?.cast<String, dynamic>();
  }

  /// Clear game state
  Future<void> clearGameState() async {
    await _saveBox.delete('currentGame');
  }

  /// Save achievements
  Future<void> saveAchievements(List<String> achievements) async {
    await _prefs.setStringList('achievements', achievements);
  }

  /// Load achievements
  List<String> getAchievements() {
    return _prefs.getStringList('achievements') ?? [];
  }

  /// Add achievement
  Future<void> addAchievement(String achievement) async {
    final achievements = getAchievements();
    if (!achievements.contains(achievement)) {
      achievements.add(achievement);
      await saveAchievements(achievements);
      notifyListeners();
    }
  }

  /// Get player statistics
  Map<String, dynamic> getPlayerStats() {
    return {
      'totalPlayTime': _totalPlayTime,
      'gamesPlayed': _gamesPlayed,
      'highScore': _highScore,
      'achievements': getAchievements(),
      'lastPlayedModule': _lastPlayedModule,
      'soundEnabled': _soundEnabled,
      'musicEnabled': _musicEnabled,
      'soundVolume': _soundVolume,
      'musicVolume': _musicVolume,
      'selectedDifficulty': _selectedDifficulty,
    };
  }

  /// Reset all save data
  Future<void> resetAllData() async {
    await _saveBox.clear();
    await _prefs.clear();
    await _loadSettings();
  }

  /// Export save data
  Map<String, dynamic> exportSaveData() {
    return {
      'settings': {
        'soundEnabled': _soundEnabled,
        'musicEnabled': _musicEnabled,
        'soundVolume': _soundVolume,
        'musicVolume': _musicVolume,
        'selectedDifficulty': _selectedDifficulty,
        'lastPlayedModule': _lastPlayedModule,
        'totalPlayTime': _totalPlayTime,
        'gamesPlayed': _gamesPlayed,
        'highScore': _highScore,
      },
      'achievements': getAchievements(),
      'moduleProgress': Map.fromEntries(
        _saveBox.keys
            .where((key) => key.startsWith('module_'))
            .map((key) => MapEntry(key, _saveBox.get(key))),
      ),
    };
  }

  /// Import save data
  Future<void> importSaveData(Map<String, dynamic> data) async {
    if (data.containsKey('settings')) {
      final settings = data['settings'] as Map<String, dynamic>;
      _soundEnabled = settings['soundEnabled'] ?? true;
      _musicEnabled = settings['musicEnabled'] ?? true;
      _soundVolume = (settings['soundVolume'] ?? 1.0).toDouble();
      _musicVolume = (settings['musicVolume'] ?? 0.7).toDouble();
      _selectedDifficulty = settings['selectedDifficulty'] ?? 1;
      _lastPlayedModule = settings['lastPlayedModule'];
      _totalPlayTime = settings['totalPlayTime'] ?? 0;
      _gamesPlayed = settings['gamesPlayed'] ?? 0;
      _highScore = settings['highScore'] ?? 0;
      await _saveSettings();
    }

    if (data.containsKey('achievements')) {
      final achievements = (data['achievements'] as List).cast<String>();
      await saveAchievements(achievements);
    }

    if (data.containsKey('moduleProgress')) {
      final moduleProgress = data['moduleProgress'] as Map<String, dynamic>;
      for (final entry in moduleProgress.entries) {
        await _saveBox.put(entry.key, entry.value);
      }
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _saveBox.close();
    super.dispose();
  }
}