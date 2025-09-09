import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';

/// Manages audio playback for the game
class AudioManager extends ChangeNotifier {
  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();
  
  bool _isMusicEnabled = true;
  bool _isSoundEnabled = true;
  double _musicVolume = 0.7;
  double _soundVolume = 1.0;
  bool _isPlaying = false;
  String? _currentMusicPath;

  // Getters
  bool get isMusicEnabled => _isMusicEnabled;
  bool get isSoundEnabled => _isSoundEnabled;
  double get musicVolume => _musicVolume;
  double get soundVolume => _soundVolume;
  bool get isPlaying => _isPlaying;
  String? get currentMusicPath => _currentMusicPath;

  /// Initialize the audio manager
  Future<void> initialize() async {
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
  }

  /// Set music enabled/disabled
  void setMusicEnabled(bool enabled) {
    _isMusicEnabled = enabled;
    if (!enabled && _isPlaying) {
      stopMusic();
    }
    notifyListeners();
  }

  /// Set sound enabled/disabled
  void setSoundEnabled(bool enabled) {
    _isSoundEnabled = enabled;
    notifyListeners();
  }

  /// Set music volume
  void setMusicVolume(double volume) {
    _musicVolume = volume.clamp(0.0, 1.0);
    _musicPlayer.setVolume(_musicVolume);
    notifyListeners();
  }

  /// Set sound volume
  void setSoundVolume(double volume) {
    _soundVolume = volume.clamp(0.0, 1.0);
    _sfxPlayer.setVolume(_soundVolume);
    notifyListeners();
  }

  /// Play background music
  Future<void> playMusic(String path) async {
    if (!_isMusicEnabled) return;
    
    try {
      if (_currentMusicPath != path) {
        await _musicPlayer.stop();
        await _musicPlayer.play(AssetSource(path));
        _currentMusicPath = path;
      } else if (!_isPlaying) {
        await _musicPlayer.resume();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error playing music: $e');
      }
    }
  }

  /// Stop background music
  Future<void> stopMusic() async {
    await _musicPlayer.stop();
    _currentMusicPath = null;
    _isPlaying = false;
    notifyListeners();
  }

  /// Pause background music
  Future<void> pauseMusic() async {
    await _musicPlayer.pause();
    notifyListeners();
  }

  /// Resume background music
  Future<void> resumeMusic() async {
    if (_isMusicEnabled && _currentMusicPath != null) {
      await _musicPlayer.resume();
    }
  }

  /// Play sound effect
  Future<void> playSfx(String path) async {
    if (!_isSoundEnabled) return;
    
    try {
      await _sfxPlayer.play(AssetSource(path));
    } catch (e) {
      if (kDebugMode) {
        print('Error playing SFX: $e');
      }
    }
  }

  /// Play card flip sound
  Future<void> playCardFlip() async {
    await playSfx('audio/sfx/card_flip.mp3');
  }

  /// Play match sound
  Future<void> playMatch() async {
    await playSfx('audio/sfx/match.mp3');
  }

  /// Play mismatch sound
  Future<void> playMismatch() async {
    await playSfx('audio/sfx/mismatch.mp3');
  }

  /// Play win sound
  Future<void> playWin() async {
    await playSfx('audio/sfx/win.mp3');
  }

  /// Play button click sound
  Future<void> playButtonClick() async {
    await playSfx('audio/sfx/button_click.mp3');
  }

  /// Play module unlock sound
  Future<void> playModuleUnlock() async {
    await playSfx('audio/sfx/module_unlock.mp3');
  }

  /// Play achievement sound
  Future<void> playAchievement() async {
    await playSfx('audio/sfx/achievement.mp3');
  }

  /// Play card name pronunciation
  Future<void> playCardName(String moduleId, String cardName) async {
    final path = 'audio/$moduleId/$cardName.mp3';
    await playSfx(path);
  }

  /// Play module-specific background music
  Future<void> playModuleMusic(String moduleId) async {
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
    // This would typically scan the assets folder
    // For now, return common SFX files
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
    for (final path in paths) {
      try {
        await _sfxPlayer.setSource(AssetSource(path));
      } catch (e) {
        if (kDebugMode) {
          print('Error preloading audio: $path - $e');
        }
      }
    }
  }

  /// Dispose resources
  @override
  void dispose() {
    _musicPlayer.dispose();
    _sfxPlayer.dispose();
    super.dispose();
  }
}