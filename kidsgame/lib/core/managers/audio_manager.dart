import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';

/// Manages audio playback for the game including music and sound effects
class AudioManager extends ChangeNotifier {
  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();
  final AudioPlayer _voicePlayer = AudioPlayer();
  
  bool _isMusicEnabled = true;
  bool _isSoundEnabled = true;
  bool _isVoiceEnabled = true;
  double _musicVolume = 0.7;
  double _soundVolume = 1.0;
  double _voiceVolume = 1.0;
  bool _isPlaying = false;
  String? _currentMusicPath;

  // Getters
  bool get isMusicEnabled => _isMusicEnabled;
  bool get isSoundEnabled => _isSoundEnabled;
  bool get isVoiceEnabled => _isVoiceEnabled;
  double get musicVolume => _musicVolume;
  double get soundVolume => _soundVolume;
  double get voiceVolume => _voiceVolume;
  bool get isPlaying => _isPlaying;
  String? get currentMusicPath => _currentMusicPath;

  /// Initialize the audio manager
  Future<void> initialize() async {
    try {
      // Set up music player
      _musicPlayer.setReleaseMode(ReleaseMode.loop);
      _musicPlayer.setVolume(_musicVolume);
      
      // Set up SFX player
      _sfxPlayer.setReleaseMode(ReleaseMode.stop);
      _sfxPlayer.setVolume(_soundVolume);
      
      // Set up voice player
      _voicePlayer.setReleaseMode(ReleaseMode.stop);
      _voicePlayer.setVolume(_voiceVolume);
      
      // Listen to music player state changes
      _musicPlayer.onPlayerStateChanged.listen((state) {
        _isPlaying = state == PlayerState.playing;
        notifyListeners();
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing AudioManager: $e');
      }
    }
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

  /// Set voice enabled/disabled
  void setVoiceEnabled(bool enabled) {
    _isVoiceEnabled = enabled;
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

  /// Set voice volume
  void setVoiceVolume(double volume) {
    _voiceVolume = volume.clamp(0.0, 1.0);
    _voicePlayer.setVolume(_voiceVolume);
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

  /// Play voice/speech
  Future<void> playVoice(String path) async {
    if (!_isVoiceEnabled) return;
    
    try {
      await _voicePlayer.play(AssetSource(path));
    } catch (e) {
      if (kDebugMode) {
        print('Error playing voice: $e');
      }
    }
  }

  // Specific sound effects
  Future<void> playButtonClick() async {
    await playSfx('assets/audio/common/button_click.mp3');
  }

  Future<void> playCardFlip() async {
    await playSfx('assets/audio/common/card_flip.mp3');
  }

  Future<void> playMatch() async {
    await playSfx('assets/audio/common/match.mp3');
  }

  Future<void> playMismatch() async {
    await playSfx('assets/audio/common/mismatch.mp3');
  }

  Future<void> playWin() async {
    await playSfx('assets/audio/common/win.mp3');
  }

  Future<void> playModuleUnlock() async {
    await playSfx('assets/audio/common/module_unlock.mp3');
  }

  Future<void> playAchievement() async {
    await playSfx('assets/audio/common/achievement.mp3');
  }

  /// Play card name pronunciation
  Future<void> playCardName(String moduleId, String cardName) async {
    final path = 'assets/audio/$moduleId/$cardName.mp3';
    await playVoice(path);
  }

  /// Play module-specific background music
  Future<void> playModuleMusic(String moduleId) async {
    final path = 'assets/audio/$moduleId/background_music.mp3';
    await playMusic(path);
  }

  /// Play main menu music
  Future<void> playMainMenuMusic() async {
    await playMusic('assets/audio/common/main_menu_music.mp3');
  }

  /// Play game music
  Future<void> playGameMusic() async {
    await playMusic('assets/audio/common/game_music.mp3');
  }

  /// Get available SFX files for a module
  List<String> getModuleSfxFiles(String moduleId) {
    return [
      'assets/audio/common/button_click.mp3',
      'assets/audio/common/card_flip.mp3',
      'assets/audio/common/match.mp3',
      'assets/audio/common/mismatch.mp3',
      'assets/audio/common/win.mp3',
    ];
  }

  /// Get available music files
  List<String> getMusicFiles() {
    return [
      'assets/audio/common/main_menu_music.mp3',
      'assets/audio/common/game_music.mp3',
      'assets/audio/shapes/background_music.mp3',
      'assets/audio/colors/background_music.mp3',
      'assets/audio/animals/background_music.mp3',
      'assets/audio/jobs/background_music.mp3',
      'assets/audio/farm/background_music.mp3',
      'assets/audio/family/background_music.mp3',
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

  /// Get audio settings as a map
  Map<String, dynamic> getAudioSettings() {
    return {
      'musicEnabled': _isMusicEnabled,
      'soundEnabled': _isSoundEnabled,
      'voiceEnabled': _isVoiceEnabled,
      'musicVolume': _musicVolume,
      'soundVolume': _soundVolume,
      'voiceVolume': _voiceVolume,
    };
  }

  /// Load audio settings from a map
  void loadAudioSettings(Map<String, dynamic> settings) {
    _isMusicEnabled = settings['musicEnabled'] ?? true;
    _isSoundEnabled = settings['soundEnabled'] ?? true;
    _isVoiceEnabled = settings['voiceEnabled'] ?? true;
    _musicVolume = (settings['musicVolume'] ?? 0.7).toDouble();
    _soundVolume = (settings['soundVolume'] ?? 1.0).toDouble();
    _voiceVolume = (settings['voiceVolume'] ?? 1.0).toDouble();
    
    _musicPlayer.setVolume(_musicVolume);
    _sfxPlayer.setVolume(_soundVolume);
    _voicePlayer.setVolume(_voiceVolume);
    
    notifyListeners();
  }

  @override
  void dispose() {
    _musicPlayer.dispose();
    _sfxPlayer.dispose();
    _voicePlayer.dispose();
    super.dispose();
  }
}