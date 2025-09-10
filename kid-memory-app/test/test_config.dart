/// Test configuration and utilities for the Kid Memory Template app
library test_config;

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import 'package:kid_memory_template/core/models/game_module.dart';

/// Test configuration class
class TestConfig {
  static const String testHivePath = 'test_hive';
  static const Map<String, dynamic> mockSharedPreferences = {};
  
  /// Initialize test environment
  static Future<void> setupTestEnvironment() async {
    // Mock SharedPreferences
    SharedPreferences.setMockInitialValues(mockSharedPreferences);
    
    // Initialize Hive for testing
    Hive.init(testHivePath);
    
    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(GameModuleAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GameCardAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(GameSessionAdapter());
    }
  }
  
  /// Clean up test environment
  static Future<void> cleanupTestEnvironment() async {
    await Hive.deleteFromDisk();
  }
  
  /// Create a test module
  static GameModule createTestModule({
    String id = 'test_module',
    String name = 'Test Module',
    String description = 'A test module for unit testing',
    String iconPath = 'assets/test/icon.png',
    String backgroundPath = 'assets/test/background.png',
    List<String> cardPaths = const ['card1.png', 'card2.png', 'card3.png'],
    bool isUnlocked = true,
    int difficultyLevel = 1,
    List<String> audioPaths = const ['audio1.mp3', 'audio2.mp3'],
  }) {
    return GameModule(
      id: id,
      name: name,
      description: description,
      iconPath: iconPath,
      backgroundPath: backgroundPath,
      cardPaths: cardPaths,
      isUnlocked: isUnlocked,
      difficultyLevel: difficultyLevel,
      audioPaths: audioPaths,
    );
  }
  
  /// Create a test card
  static GameCard createTestCard({
    String id = 'test_card',
    String imagePath = 'assets/test/card.png',
    String audioPath = 'assets/test/audio.mp3',
    String name = 'Test Card',
    bool isMatched = false,
    bool isFlipped = false,
  }) {
    return GameCard(
      id: id,
      imagePath: imagePath,
      audioPath: audioPath,
      name: name,
      isMatched: isMatched,
      isFlipped: isFlipped,
    );
  }
  
  /// Create a test session
  static GameSession createTestSession({
    String sessionId = 'test_session',
    String moduleId = 'test_module',
    DateTime? startTime,
    DateTime? endTime,
    int correctMatches = 0,
    int incorrectMatches = 0,
    int totalMoves = 0,
    Duration? duration,
  }) {
    return GameSession(
      sessionId: sessionId,
      moduleId: moduleId,
      startTime: startTime ?? DateTime.now(),
      endTime: endTime,
      correctMatches: correctMatches,
      incorrectMatches: incorrectMatches,
      totalMoves: totalMoves,
      duration: duration,
    );
  }
}

/// Test utilities
class TestUtils {
  /// Wait for async operations to complete
  static Future<void> waitForAsync() async {
    await Future.delayed(const Duration(milliseconds: 100));
  }
  
  /// Create a mock file path
  static String mockFilePath(String filename) {
    return 'assets/test/$filename';
  }
  
  /// Create a list of mock file paths
  static List<String> mockFilePaths(int count, String prefix) {
    return List.generate(count, (i) => 'assets/test/${prefix}_$i.png');
  }
  
  /// Assert that a value is within a reasonable range
  static void assertInRange(num value, num min, num max, String message) {
    expect(value, greaterThanOrEqualTo(min), reason: message);
    expect(value, lessThanOrEqualTo(max), reason: message);
  }
  
  /// Assert that a duration is reasonable
  static void assertReasonableDuration(Duration duration, Duration maxDuration, String operation) {
    expect(duration, lessThan(maxDuration), reason: '$operation took too long: ${duration.inMilliseconds}ms');
  }
  
  /// Create a test widget with proper providers
  static Widget createTestWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }
}

/// Performance test utilities
class PerformanceTestUtils {
  /// Measure execution time of a function
  static Future<Duration> measureExecution(Future<void> Function() function) async {
    final stopwatch = Stopwatch()..start();
    await function();
    stopwatch.stop();
    return stopwatch.elapsed;
  }
  
  /// Measure execution time of a synchronous function
  static Duration measureSyncExecution(void Function() function) {
    final stopwatch = Stopwatch()..start();
    function();
    stopwatch.stop();
    return stopwatch.elapsed;
  }
  
  /// Assert that execution time is within acceptable limits
  static void assertExecutionTime(Duration duration, Duration maxDuration, String operation) {
    expect(duration, lessThan(maxDuration), 
      reason: '$operation took ${duration.inMilliseconds}ms, expected less than ${maxDuration.inMilliseconds}ms');
  }
}

/// Memory test utilities
class MemoryTestUtils {
  /// Force garbage collection (platform dependent)
  static void forceGC() {
    // This is a placeholder - actual implementation would be platform specific
    // In a real test, you'd use proper memory profiling tools
  }
  
  /// Check if memory usage is reasonable
  static void assertReasonableMemoryUsage() {
    // This is a placeholder - actual implementation would check memory usage
    // In a real test, you'd use proper memory profiling tools
  }
}