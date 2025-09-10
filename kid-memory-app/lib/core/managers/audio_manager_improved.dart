import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';

/// Improved AudioManager with better error handling and performance
class AudioManagerImproved extends ChangeNotifier {
  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();
  
  bool _isMusicEnabled = true;
  bool _isSoundEnabled = true;
  double _musicVolume = 0.7;
  double _soundVolume = 1.0;
  bool _isPlaying = false;
  String? _currentMusicPath;
  
  // Error tracking
  int _errorCount = 0;
  static const int _maxErrors = 5;
  
  // Performance tracking
  final Map<String, int> _playCounts = {};
  final Map<String, DateTime> _lastPlayTimes = {};

  // Getters
  bool get isMusicEnabled => _isMusicEnabled;
  bool get isSoundEnabled => _isSoundEnabled;
  double get musicVolume => _musicVolume;
  double get soundVolume => _soundVolume;
  bool get isPlaying => _isPlaying;
  String? get currentMusicPath => _currentMusicPath;
  int get errorCount => _errorCount;

  /// Initialize the audio manager with improved error handling
  Future<void> initialize() async {
    try {
      // Set up music player
      _musicPlayer.setReleaseMode(ReleaseMode.loop);
      _musicPlayer.setVolume(_musicVolume);
      
      // Set up SFX player
      _sfxPlayer.setReleaseMode(ReleaseMode.stop);
      _sfxPlayer.setVolume(_soundVolume);
      
      // Listen to music player state changes
      _musicPlayer.onPlayerStateChanged.listen((state) {
        _isPlaying = state == PlayerState.playing;
        notifyListeners();
      });
      
      // Reset error count on successful initialization
      _errorCount = 0;
    } catch (e) {
      _handleError('AudioManager initialization failed', e);
    }
  }

  /// Set music enabled/disabled with validation
  void setMusicEnabled(bool enabled) {
    if (_isMusicEnabled == enabled) return;
    
    _isMusicEnabled = enabled;
    if (!enabled && _isPlaying) {
      stopMusic();
    }
    notifyListeners();
  }

  /// Set sound enabled/disabled with validation
  void setSoundEnabled(bool enabled) {
    if (_isSoundEnabled == enabled) return;
    
    _isSoundEnabled = enabled;
    notifyListeners();
  }

  /// Set music volume with improved validation
  void setMusicVolume(double volume) {
    if (volume < 0.0 || volume > 1.0) {
      _handleError('Invalid music volume: $volume', null);
      return;
    }
    
    _musicVolume = volume;
    try {
      _musicPlayer.setVolume(_musicVolume);
      notifyListeners();
    } catch (e) {
      _handleError('Failed to set music volume', e);
    }
  }

  /// Set sound volume with improved validation
  void setSoundVolume(double volume) {
    if (volume < 0.0 || volume > 1.0) {
      _handleError('Invalid sound volume: $volume', null);
      return;
    }
    
    _soundVolume = volume;
    try {
      _sfxPlayer.setVolume(_soundVolume);
      notifyListeners();
    } catch (e) {
      _handleError('Failed to set sound volume', e);
    }
  }

  /// Play background music with improved error handling
  Future<void> playMusic(String path) async {
    if (!_isMusicEnabled || path.isEmpty) return;
    
    try {
      // Check if we should play (avoid rapid repeated calls)
      final now = DateTime.now();
      final lastPlay = _lastPlayTimes[path];
      if (lastPlay != null && now.difference(lastPlay).inMilliseconds < 100) {
        return; // Too soon to play again
      }
      
      if (_currentMusicPath != path) {
        await _musicPlayer.stop();
        await _musicPlayer.play(AssetSource(path));
        _currentMusicPath = path;
        _lastPlayTimes[path] = now;
        _playCounts[path] = (_playCounts[path] ?? 0) + 1;
      } else if (!_isPlaying) {
        await _musicPlayer.resume();
      }
      
      // Reset error count on successful play
      _errorCount = 0;
    } catch (e) {
      _handleError('Error playing music: $path', e);
    }
  }

  /// Stop background music with error handling
  Future<void> stopMusic() async {
    try {
      await _musicPlayer.stop();
      _currentMusicPath = null;
      _isPlaying = false;
      notifyListeners();
    } catch (e) {
      _handleError('Error stopping music', e);
    }
  }

  /// Pause background music with error handling
  Future<void> pauseMusic() async {
    try {
      await _musicPlayer.pause();
      notifyListeners();
    } catch (e) {
      _handleError('Error pausing music', e);
    }
  }

  /// Resume background music with error handling
  Future<void> resumeMusic() async {
    if (!_isMusicEnabled || _currentMusicPath == null) return;
    
    try {
      await _musicPlayer.resume();
    } catch (e) {
      _handleError('Error resuming music', e);
    }
  }

  /// Play sound effect with improved error handling and rate limiting
  Future<void> playSfx(String path) async {
    if (!_isSoundEnabled || path.isEmpty) return;
    
    try {
      // Rate limiting to prevent audio spam
      final now = DateTime.now();
      final lastPlay = _lastPlayTimes[path];
      if (lastPlay != null && now.difference(lastPlay).inMilliseconds < 50) {
        return; // Too soon to play again
      }
      
      await _sfxPlayer.play(AssetSource(path));
      _lastPlayTimes[path] = now;
      _playCounts[path] = (_playCounts[path] ?? 0) + 1;
      
      // Reset error count on successful play
      _errorCount = 0;
    } catch (e) {
      _handleError('Error playing SFX: $path', e);
    }
  }

  /// Play card flip sound with validation
  Future<void> playCardFlip() async {
    await playSfx('audio/sfx/card_flip.mp3');
  }

  /// Play match sound with validation
  Future<void> playMatch() async {
    await playSfx('audio/sfx/match.mp3');
  }

  /// Play mismatch sound with validation
  Future<void> playMismatch() async {
    await playSfx('audio/sfx/mismatch.mp3');
  }

  /// Play win sound with validation
  Future<void> playWin() async {
    await playSfx('audio/sfx/win.mp3');
  }

  /// Play button click sound with validation
  Future<void> playButtonClick() async {
    await playSfx('audio/sfx/button_click.mp3');
  }

  /// Play module unlock sound with validation
  Future<void> playModuleUnlock() async {
    await playSfx('audio/sfx/module_unlock.mp3');
  }

  /// Play achievement sound with validation
  Future<void> playAchievement() async {
    await playSfx('audio/sfx/achievement.mp3');
  }

  /// Play card name pronunciation with validation
  Future<void> playCardName(String moduleId, String cardName) async {
    if (moduleId.isEmpty || cardName.isEmpty) {
      _handleError('Invalid moduleId or cardName', null);
      return;
    }
    
    final path = 'audio/$moduleId/$cardName.mp3';
    await playSfx(path);
  }

  /// Play module-specific background music with validation
  Future<void> playModuleMusic(String moduleId) async {
    if (moduleId.isEmpty) {
      _handleError('Invalid moduleId', null);
      return;
    }
    
    final path = 'audio/$moduleId/background_music.mp3';
    await playMusic(path);
  }

  /// Play main menu music
  Future<void> playMainMenuMusic() async {
    await playMusic('audio/main_menu_music.mp3');
  }

  /// Play game music
  Future<void> playGameMusic() async {
    await playMusic('audio/game_music.mp3');
  }

  /// Get available SFX files for a module
  List<String> getModuleSfxFiles(String moduleId) {
    if (moduleId.isEmpty) return [];
    
    return [
      'audio/sfx/card_flip.mp3',
      'audio/sfx/match.mp3',
      'audio/sfx/mismatch.mp3',
      'audio/sfx/win.mp3',
      'audio/sfx/button_click.mp3',
    ];
  }

  /// Get available music files
  List<String> getMusicFiles() {
    return [
      'audio/main_menu_music.mp3',
      'audio/game_music.mp3',
      'audio/shapes/background_music.mp3',
      'audio/colors/background_music.mp3',
      'audio/animals/background_music.mp3',
      'audio/jobs/background_music.mp3',
      'audio/farm/background_music.mp3',
      'audio/family/background_music.mp3',
    ];
  }

  /// Preload audio files for better performance
  Future<void> preloadAudioFiles(List<String> paths) async {
    if (paths.isEmpty) return;
    
    for (final path in paths) {
      if (path.isEmpty) continue;
      
      try {
        await _sfxPlayer.setSource(AssetSource(path));
      } catch (e) {
        _handleError('Error preloading audio: $path', e);
      }
    }
  }

  /// Get audio statistics
  Map<String, dynamic> getAudioStats() {
    return {
      'errorCount': _errorCount,
      'playCounts': Map<String, int>.from(_playCounts),
      'isMusicEnabled': _isMusicEnabled,
      'isSoundEnabled': _isSoundEnabled,
      'musicVolume': _musicVolume,
      'soundVolume': _soundVolume,
      'isPlaying': _isPlaying,
      'currentMusicPath': _currentMusicPath,
    };
  }

  /// Reset audio statistics
  void resetStats() {
    _errorCount = 0;
    _playCounts.clear();
    _lastPlayTimes.clear();
  }

  /// Handle errors with improved logging and recovery
  void _handleError(String message, dynamic error) {
    _errorCount++;
    
    if (kDebugMode) {
      print('AudioManager Error: $message');
      if (error != null) {
        print('Error details: $error');
      }
    }
    
    // If too many errors, disable audio temporarily
    if (_errorCount >= _maxErrors) {
      _isMusicEnabled = false;
      _isSoundEnabled = false;
      if (kDebugMode) {
        print('AudioManager: Too many errors, disabling audio');
      }
    }
    
    notifyListeners();
  }

  /// Dispose resources with proper cleanup
  @override
  void dispose() {
    try {
      _musicPlayer.dispose();
      _sfxPlayer.dispose();
    } catch (e) {
      if (kDebugMode) {
        print('Error disposing AudioManager: $e');
      }
    }
    super.dispose();
  }
}