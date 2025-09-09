import 'package:flutter_test/flutter_test.dart';
import 'package:kidsgame/core/managers/audio_manager.dart';

void main() {
  group('AudioManager Unit Tests', () {
    late AudioManager audioManager;

    setUp(() {
      audioManager = AudioManager();
    });

    tearDown(() {
      audioManager.dispose();
    });

    test('should initialize with default values', () async {
      await audioManager.initialize();
      
      expect(audioManager.isMusicEnabled, true);
      expect(audioManager.isSoundEnabled, true);
      expect(audioManager.isVoiceEnabled, true);
      expect(audioManager.musicVolume, 0.7);
      expect(audioManager.soundVolume, 1.0);
      expect(audioManager.voiceVolume, 1.0);
      expect(audioManager.isPlaying, false);
      expect(audioManager.currentMusicPath, null);
    });

    test('should toggle music enabled state', () async {
      await audioManager.initialize();
      
      audioManager.setMusicEnabled(false);
      expect(audioManager.isMusicEnabled, false);
      
      audioManager.setMusicEnabled(true);
      expect(audioManager.isMusicEnabled, true);
    });

    test('should toggle sound enabled state', () async {
      await audioManager.initialize();
      
      audioManager.setSoundEnabled(false);
      expect(audioManager.isSoundEnabled, false);
      
      audioManager.setSoundEnabled(true);
      expect(audioManager.isSoundEnabled, true);
    });

    test('should toggle voice enabled state', () async {
      await audioManager.initialize();
      
      audioManager.setVoiceEnabled(false);
      expect(audioManager.isVoiceEnabled, false);
      
      audioManager.setVoiceEnabled(true);
      expect(audioManager.isVoiceEnabled, true);
    });

    test('should set music volume within valid range', () async {
      await audioManager.initialize();
      
      audioManager.setMusicVolume(0.5);
      expect(audioManager.musicVolume, 0.5);
      
      audioManager.setMusicVolume(1.5); // Should clamp to 1.0
      expect(audioManager.musicVolume, 1.0);
      
      audioManager.setMusicVolume(-0.5); // Should clamp to 0.0
      expect(audioManager.musicVolume, 0.0);
    });

    test('should set sound volume within valid range', () async {
      await audioManager.initialize();
      
      audioManager.setSoundVolume(0.8);
      expect(audioManager.soundVolume, 0.8);
      
      audioManager.setSoundVolume(1.5); // Should clamp to 1.0
      expect(audioManager.soundVolume, 1.0);
      
      audioManager.setSoundVolume(-0.2); // Should clamp to 0.0
      expect(audioManager.soundVolume, 0.0);
    });

    test('should set voice volume within valid range', () async {
      await audioManager.initialize();
      
      audioManager.setVoiceVolume(0.6);
      expect(audioManager.voiceVolume, 0.6);
      
      audioManager.setVoiceVolume(1.2); // Should clamp to 1.0
      expect(audioManager.voiceVolume, 1.0);
      
      audioManager.setVoiceVolume(-0.1); // Should clamp to 0.0
      expect(audioManager.voiceVolume, 0.0);
    });

    test('should not play music when disabled', () async {
      await audioManager.initialize();
      audioManager.setMusicEnabled(false);
      
      await audioManager.playMusic('test_music.mp3');
      expect(audioManager.currentMusicPath, null);
    });

    test('should not play SFX when disabled', () async {
      await audioManager.initialize();
      audioManager.setSoundEnabled(false);
      
      // These should not throw errors even when disabled
      await audioManager.playSfx('test_sfx.mp3');
      await audioManager.playButtonClick();
      await audioManager.playCardFlip();
      await audioManager.playMatch();
      await audioManager.playMismatch();
      await audioManager.playWin();
    });

    test('should not play voice when disabled', () async {
      await audioManager.initialize();
      audioManager.setVoiceEnabled(false);
      
      // This should not throw errors even when disabled
      await audioManager.playVoice('test_voice.mp3');
      await audioManager.playCardName('shapes', 'circle');
    });

    test('should get audio settings as map', () async {
      await audioManager.initialize();
      
      final settings = audioManager.getAudioSettings();
      expect(settings['musicEnabled'], true);
      expect(settings['soundEnabled'], true);
      expect(settings['voiceEnabled'], true);
      expect(settings['musicVolume'], 0.7);
      expect(settings['soundVolume'], 1.0);
      expect(settings['voiceVolume'], 1.0);
    });

    test('should load audio settings from map', () async {
      await audioManager.initialize();
      
      final newSettings = {
        'musicEnabled': false,
        'soundEnabled': false,
        'voiceEnabled': false,
        'musicVolume': 0.5,
        'soundVolume': 0.8,
        'voiceVolume': 0.6,
      };
      
      audioManager.loadAudioSettings(newSettings);
      
      expect(audioManager.isMusicEnabled, false);
      expect(audioManager.isSoundEnabled, false);
      expect(audioManager.isVoiceEnabled, false);
      expect(audioManager.musicVolume, 0.5);
      expect(audioManager.soundVolume, 0.8);
      expect(audioManager.voiceVolume, 0.6);
    });

    test('should get module SFX files', () async {
      await audioManager.initialize();
      
      final sfxFiles = audioManager.getModuleSfxFiles('shapes');
      expect(sfxFiles, isNotEmpty);
      expect(sfxFiles, contains('assets/audio/common/button_click.mp3'));
      expect(sfxFiles, contains('assets/audio/common/card_flip.mp3'));
    });

    test('should get music files', () async {
      await audioManager.initialize();
      
      final musicFiles = audioManager.getMusicFiles();
      expect(musicFiles, isNotEmpty);
      expect(musicFiles, contains('assets/audio/common/main_menu_music.mp3'));
      expect(musicFiles, contains('assets/audio/common/game_music.mp3'));
    });

    test('should handle preload audio files gracefully', () async {
      await audioManager.initialize();
      
      final paths = [
        'assets/audio/common/button_click.mp3',
        'assets/audio/common/card_flip.mp3',
        'nonexistent_file.mp3',
      ];
      
      // Should not throw errors even with invalid paths
      await audioManager.preloadAudioFiles(paths);
    });

    test('should handle multiple rapid volume changes', () async {
      await audioManager.initialize();
      
      for (int i = 0; i < 100; i++) {
        audioManager.setMusicVolume(i / 100.0);
        audioManager.setSoundVolume(i / 100.0);
        audioManager.setVoiceVolume(i / 100.0);
      }
      
      expect(audioManager.musicVolume, 1.0);
      expect(audioManager.soundVolume, 1.0);
      expect(audioManager.voiceVolume, 1.0);
    });

    test('should handle rapid enable/disable toggles', () async {
      await audioManager.initialize();
      
      for (int i = 0; i < 50; i++) {
        audioManager.setMusicEnabled(i % 2 == 0);
        audioManager.setSoundEnabled(i % 2 == 1);
        audioManager.setVoiceEnabled(i % 3 == 0);
      }
      
      // Final state should be consistent
      expect(audioManager.isMusicEnabled, false);
      expect(audioManager.isSoundEnabled, true);
      expect(audioManager.isVoiceEnabled, false);
    });
  });
}