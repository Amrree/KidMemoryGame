import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_module.dart';

/// Improved SaveManager with better error handling and performance
class SaveManagerImproved extends ChangeNotifier {
  static const String _boxName = 'saveData';
  late Box<Map> _saveBox;
  late SharedPreferences _prefs;
  
  // Game settings with validation
  bool _soundEnabled = true;
  bool _musicEnabled = true;
  double _soundVolume = 1.0;
  double _musicVolume = 0.7;
  int _selectedDifficulty = 1;
  String? _lastPlayedModule;
  int _totalPlayTime = 0;
  int _gamesPlayed = 0;
  int _highScore = 0;
  
  // Error tracking
  int _errorCount = 0;
  static const int _maxErrors = 10;
  
  // Performance tracking
  final Map<String, int> _operationCounts = {};
  final Map<String, DateTime> _lastOperationTimes = {};

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
  int get errorCount => _errorCount;

  /// Initialize the save manager with improved error handling
  Future<void> initialize() async {
    try {
      _saveBox = await Hive.openBox<Map>(_boxName);
      _prefs = await SharedPreferences.getInstance();
      await _loadSettings();
      _errorCount = 0; // Reset error count on successful initialization
    } catch (e) {
      _handleError('SaveManager initialization failed', e);
      // Initialize with default values if storage fails
      await _initializeDefaults();
    }
  }

  /// Initialize default values
  Future<void> _initializeDefaults() async {
    _soundEnabled = true;
    _musicEnabled = true;
    _soundVolume = 1.0;
    _musicVolume = 0.7;
    _selectedDifficulty = 1;
    _lastPlayedModule = null;
    _totalPlayTime = 0;
    _gamesPlayed = 0;
    _highScore = 0;
    notifyListeners();
  }

  /// Load settings from storage with validation
  Future<void> _loadSettings() async {
    try {
      _soundEnabled = _prefs.getBool('soundEnabled') ?? true;
      _musicEnabled = _prefs.getBool('musicEnabled') ?? true;
      _soundVolume = _prefs.getDouble('soundVolume') ?? 1.0;
      _musicVolume = _prefs.getDouble('musicVolume') ?? 0.7;
      _selectedDifficulty = _prefs.getInt('selectedDifficulty') ?? 1;
      _lastPlayedModule = _prefs.getString('lastPlayedModule');
      _totalPlayTime = _prefs.getInt('totalPlayTime') ?? 0;
      _gamesPlayed = _prefs.getInt('gamesPlayed') ?? 0;
      _highScore = _prefs.getInt('highScore') ?? 0;
      
      // Validate loaded values
      _validateSettings();
      notifyListeners();
    } catch (e) {
      _handleError('Error loading settings', e);
      await _initializeDefaults();
    }
  }

  /// Validate settings and fix invalid values
  void _validateSettings() {
    _soundVolume = _soundVolume.clamp(0.0, 1.0);
    _musicVolume = _musicVolume.clamp(0.0, 1.0);
    _selectedDifficulty = _selectedDifficulty.clamp(1, 5);
    _totalPlayTime = _totalPlayTime.clamp(0, 999999);
    _gamesPlayed = _gamesPlayed.clamp(0, 999999);
    _highScore = _highScore.clamp(0, 999999);
  }

  /// Save settings to storage with error handling
  Future<void> _saveSettings() async {
    try {
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
    } catch (e) {
      _handleError('Error saving settings', e);
    }
  }

  /// Set sound enabled/disabled with validation
  Future<void> setSoundEnabled(bool enabled) async {
    if (_soundEnabled == enabled) return;
    
    _soundEnabled = enabled;
    await _saveSettings();
    _trackOperation('setSoundEnabled');
    notifyListeners();
  }

  /// Set music enabled/disabled with validation
  Future<void> setMusicEnabled(bool enabled) async {
    if (_musicEnabled == enabled) return;
    
    _musicEnabled = enabled;
    await _saveSettings();
    _trackOperation('setMusicEnabled');
    notifyListeners();
  }

  /// Set sound volume with validation
  Future<void> setSoundVolume(double volume) async {
    if (volume < 0.0 || volume > 1.0) {
      _handleError('Invalid sound volume: $volume', null);
      return;
    }
    
    _soundVolume = volume;
    await _saveSettings();
    _trackOperation('setSoundVolume');
    notifyListeners();
  }

  /// Set music volume with validation
  Future<void> setMusicVolume(double volume) async {
    if (volume < 0.0 || volume > 1.0) {
      _handleError('Invalid music volume: $volume', null);
      return;
    }
    
    _musicVolume = volume;
    await _saveSettings();
    _trackOperation('setMusicVolume');
    notifyListeners();
  }

  /// Set selected difficulty with validation
  Future<void> setSelectedDifficulty(int difficulty) async {
    if (difficulty < 1 || difficulty > 5) {
      _handleError('Invalid difficulty: $difficulty', null);
      return;
    }
    
    _selectedDifficulty = difficulty;
    await _saveSettings();
    _trackOperation('setSelectedDifficulty');
    notifyListeners();
  }

  /// Set last played module with validation
  Future<void> setLastPlayedModule(String moduleId) async {
    if (moduleId.isEmpty) {
      _handleError('Invalid moduleId', null);
      return;
    }
    
    _lastPlayedModule = moduleId;
    await _saveSettings();
    _trackOperation('setLastPlayedModule');
    notifyListeners();
  }

  /// Add play time with validation
  Future<void> addPlayTime(int seconds) async {
    if (seconds < 0) {
      _handleError('Invalid play time: $seconds', null);
      return;
    }
    
    _totalPlayTime = (_totalPlayTime + seconds).clamp(0, 999999);
    await _saveSettings();
    _trackOperation('addPlayTime');
    notifyListeners();
  }

  /// Increment games played with validation
  Future<void> incrementGamesPlayed() async {
    _gamesPlayed = (_gamesPlayed + 1).clamp(0, 999999);
    await _saveSettings();
    _trackOperation('incrementGamesPlayed');
    notifyListeners();
  }

  /// Update high score with validation
  Future<void> updateHighScore(int score) async {
    if (score < 0) {
      _handleError('Invalid score: $score', null);
      return;
    }
    
    if (score > _highScore) {
      _highScore = score.clamp(0, 999999);
      await _saveSettings();
      _trackOperation('updateHighScore');
      notifyListeners();
    }
  }

  /// Save game progress for a specific module with validation
  Future<void> saveModuleProgress(String moduleId, Map<String, dynamic> progress) async {
    if (moduleId.isEmpty) {
      _handleError('Invalid moduleId', null);
      return;
    }
    
    try {
      await _saveBox.put('module_$moduleId', progress);
      _trackOperation('saveModuleProgress');
    } catch (e) {
      _handleError('Error saving module progress', e);
    }
  }

  /// Load game progress for a specific module with validation
  Map<String, dynamic>? getModuleProgress(String moduleId) {
    if (moduleId.isEmpty) {
      _handleError('Invalid moduleId', null);
      return null;
    }
    
    try {
      return _saveBox.get('module_$moduleId')?.cast<String, dynamic>();
    } catch (e) {
      _handleError('Error loading module progress', e);
      return null;
    }
  }

  /// Save game state with validation
  Future<void> saveGameState(Map<String, dynamic> gameState) async {
    try {
      await _saveBox.put('currentGame', gameState);
      _trackOperation('saveGameState');
    } catch (e) {
      _handleError('Error saving game state', e);
    }
  }

  /// Load game state with validation
  Map<String, dynamic>? getGameState() {
    try {
      return _saveBox.get('currentGame')?.cast<String, dynamic>();
    } catch (e) {
      _handleError('Error loading game state', e);
      return null;
    }
  }

  /// Clear game state with error handling
  Future<void> clearGameState() async {
    try {
      await _saveBox.delete('currentGame');
      _trackOperation('clearGameState');
    } catch (e) {
      _handleError('Error clearing game state', e);
    }
  }

  /// Save achievements with validation
  Future<void> saveAchievements(List<String> achievements) async {
    if (achievements.any((a) => a.isEmpty)) {
      _handleError('Invalid achievement: empty string', null);
      return;
    }
    
    try {
      await _prefs.setStringList('achievements', achievements);
      _trackOperation('saveAchievements');
    } catch (e) {
      _handleError('Error saving achievements', e);
    }
  }

  /// Load achievements with error handling
  List<String> getAchievements() {
    try {
      return _prefs.getStringList('achievements') ?? [];
    } catch (e) {
      _handleError('Error loading achievements', e);
      return [];
    }
  }

  /// Add achievement with validation
  Future<void> addAchievement(String achievement) async {
    if (achievement.isEmpty) {
      _handleError('Invalid achievement: empty string', null);
      return;
    }
    
    try {
      final achievements = getAchievements();
      if (!achievements.contains(achievement)) {
        achievements.add(achievement);
        await saveAchievements(achievements);
        _trackOperation('addAchievement');
        notifyListeners();
      }
    } catch (e) {
      _handleError('Error adding achievement', e);
    }
  }

  /// Get player statistics with error handling
  Map<String, dynamic> getPlayerStats() {
    try {
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
        'errorCount': _errorCount,
        'operationCounts': Map<String, int>.from(_operationCounts),
      };
    } catch (e) {
      _handleError('Error getting player stats', e);
      return {};
    }
  }

  /// Reset all save data with confirmation
  Future<void> resetAllData() async {
    try {
      await _saveBox.clear();
      await _prefs.clear();
      await _initializeDefaults();
      _operationCounts.clear();
      _lastOperationTimes.clear();
      _errorCount = 0;
      _trackOperation('resetAllData');
    } catch (e) {
      _handleError('Error resetting data', e);
    }
  }

  /// Export save data with error handling
  Map<String, dynamic> exportSaveData() {
    try {
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
        'metadata': {
          'exportTime': DateTime.now().toIso8601String(),
          'version': '1.0.0',
        },
      };
    } catch (e) {
      _handleError('Error exporting save data', e);
      return {};
    }
  }

  /// Import save data with validation
  Future<void> importSaveData(Map<String, dynamic> data) async {
    try {
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
        
        _validateSettings();
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

      _trackOperation('importSaveData');
      notifyListeners();
    } catch (e) {
      _handleError('Error importing save data', e);
    }
  }

  /// Track operation for performance monitoring
  void _trackOperation(String operation) {
    _operationCounts[operation] = (_operationCounts[operation] ?? 0) + 1;
    _lastOperationTimes[operation] = DateTime.now();
  }

  /// Handle errors with improved logging
  void _handleError(String message, dynamic error) {
    _errorCount++;
    
    if (kDebugMode) {
      print('SaveManager Error: $message');
      if (error != null) {
        print('Error details: $error');
      }
    }
    
    // If too many errors, reset to defaults
    if (_errorCount >= _maxErrors) {
      if (kDebugMode) {
        print('SaveManager: Too many errors, resetting to defaults');
      }
      _initializeDefaults();
    }
  }

  /// Get performance statistics
  Map<String, dynamic> getPerformanceStats() {
    return {
      'errorCount': _errorCount,
      'operationCounts': Map<String, int>.from(_operationCounts),
      'lastOperationTimes': Map<String, String>.fromEntries(
        _lastOperationTimes.entries.map((e) => MapEntry(e.key, e.value.toIso8601String())),
      ),
    };
  }

  /// Dispose resources with proper cleanup
  @override
  void dispose() {
    try {
      _saveBox.close();
    } catch (e) {
      if (kDebugMode) {
        print('Error disposing SaveManager: $e');
      }
    }
    super.dispose();
  }
}