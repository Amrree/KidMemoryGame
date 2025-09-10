import 'package:flutter_test/flutter_test.dart';
import 'package:kid_memory_template/core/managers/audio_manager.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  group('AudioManager Tests', () {
    late AudioManager audioManager;

    setUp(() {
      audioManager = AudioManager();
    });

    tearDown(() {
      audioManager.dispose();
    });

    test('should initialize with default values', () {
      expect(audioManager.isMusicEnabled, true);
      expect(audioManager.isSoundEnabled, true);
      expect(audioManager.musicVolume, 0.7);
      expect(audioManager.soundVolume, 1.0);
      expect(audioManager.isPlaying, false);
      expect(audioManager.currentMusicPath, null);
    });

    test('should set music enabled/disabled', () {
      audioManager.setMusicEnabled(false);
      expect(audioManager.isMusicEnabled, false);

      audioManager.setMusicEnabled(true);
      expect(audioManager.isMusicEnabled, true);
    });

    test('should set sound enabled/disabled', () {
      audioManager.setSoundEnabled(false);
      expect(audioManager.isSoundEnabled, false);

      audioManager.setSoundEnabled(true);
      expect(audioManager.isSoundEnabled, true);
    });

    test('should clamp volume values between 0.0 and 1.0', () {
      audioManager.setMusicVolume(-0.5);
      expect(audioManager.musicVolume, 0.0);

      audioManager.setMusicVolume(1.5);
      expect(audioManager.musicVolume, 1.0);

      audioManager.setMusicVolume(0.5);
      expect(audioManager.musicVolume, 0.5);
    });

    test('should clamp sound volume values between 0.0 and 1.0', () {
      audioManager.setSoundVolume(-0.5);
      expect(audioManager.soundVolume, 0.0);

      audioManager.setSoundVolume(1.5);
      expect(audioManager.soundVolume, 1.0);

      audioManager.setSoundVolume(0.5);
      expect(audioManager.soundVolume, 0.5);
    });

    test('should not play music when disabled', () async {
      audioManager.setMusicEnabled(false);
      await audioManager.playMusic('test_music.mp3');
      expect(audioManager.isPlaying, false);
    });

    test('should not play sound when disabled', () async {
      audioManager.setSoundEnabled(false);
      await audioManager.playSfx('test_sfx.mp3');
      // Should not throw error
    });

    test('should handle invalid audio paths gracefully', () async {
      // These should not throw exceptions
      await audioManager.playMusic('invalid_path.mp3');
      await audioManager.playSfx('invalid_path.mp3');
    });

    test('should get module SFX files', () {
      final sfxFiles = audioManager.getModuleSfxFiles('test_module');
      expect(sfxFiles, isA<List<String>>());
      expect(sfxFiles.isNotEmpty, true);
    });

    test('should get music files', () {
      final musicFiles = audioManager.getMusicFiles();
      expect(musicFiles, isA<List<String>>());
      expect(musicFiles.isNotEmpty, true);
    });

    test('should preload audio files without errors', () async {
      final paths = ['audio/sfx/card_flip.mp3', 'audio/sfx/match.mp3'];
      await audioManager.preloadAudioFiles(paths);
      // Should not throw error
    });

    test('should handle stop music', () async {
      await audioManager.stopMusic();
      expect(audioManager.isPlaying, false);
      expect(audioManager.currentMusicPath, null);
    });

    test('should handle pause and resume music', () async {
      await audioManager.pauseMusic();
      expect(audioManager.isPlaying, false);

      await audioManager.resumeMusic();
      // Should not throw error
    });

    test('should play specific sound effects', () async {
      await audioManager.playCardFlip();
      await audioManager.playMatch();
      await audioManager.playMismatch();
      await audioManager.playWin();
      await audioManager.playButtonClick();
      await audioManager.playModuleUnlock();
      await audioManager.playAchievement();
      // Should not throw errors
    });

    test('should play card name pronunciation', () async {
      await audioManager.playCardName('shapes', 'circle');
      // Should not throw error
    });

    test('should play module music', () async {
      await audioManager.playModuleMusic('shapes');
      // Should not throw error
    });

    test('should play main menu music', () async {
      await audioManager.playMainMenuMusic();
      // Should not throw error
    });

    test('should play game music', () async {
      await audioManager.playGameMusic();
      // Should not throw error
    });
  });
}