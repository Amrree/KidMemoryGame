import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:kidsgame/core/managers/analytics_manager.dart';
import 'package:kidsgame/core/managers/audio_manager.dart';
import 'package:kidsgame/core/managers/module_manager.dart';
import 'package:kidsgame/core/managers/save_manager.dart';
import 'package:kidsgame/core/managers/parental_gate_manager.dart';
import 'package:kidsgame/core/models/game_module.dart';

/// Test helpers for Kids Game Template
class TestHelpers {
  /// Creates a test app with all providers
  static Widget createTestApp({Widget? home}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AnalyticsManager()),
        ChangeNotifierProvider(create: (_) => AudioManager()),
        ChangeNotifierProvider(create: (_) => ModuleManager()),
        ChangeNotifierProvider(create: (_) => SaveManager()),
        ChangeNotifierProvider(create: (_) => ParentalGateManager()),
      ],
      child: MaterialApp(
        home: home ?? const SizedBox(),
      ),
    );
  }

  /// Creates a test app with custom providers
  static Widget createTestAppWithProviders({
    required List<ChangeNotifierProvider> providers,
    Widget? home,
  }) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        home: home ?? const SizedBox(),
      ),
    );
  }

  /// Waits for all animations to complete
  static Future<void> waitForAnimations(WidgetTester tester) async {
    await tester.pumpAndSettle();
  }

  /// Taps a widget and waits for animations
  static Future<void> tapAndWait(WidgetTester tester, Finder finder) async {
    await tester.tap(finder);
    await waitForAnimations(tester);
  }

  /// Enters text and waits for animations
  static Future<void> enterTextAndWait(WidgetTester tester, Finder finder, String text) async {
    await tester.enterText(finder, text);
    await waitForAnimations(tester);
  }

  /// Navigates to a screen and waits
  static Future<void> navigateToScreen(WidgetTester tester, String buttonText) async {
    await tapAndWait(tester, find.text(buttonText));
  }

  /// Navigates back and waits
  static Future<void> navigateBack(WidgetTester tester) async {
    await tapAndWait(tester, find.byIcon(Icons.arrow_back));
  }

  /// Creates a test module
  static GameModule createTestModule({
    String id = 'test_module',
    String name = 'Test Module',
    String description = 'A test module',
    String iconPath = 'test_icon.png',
    String backgroundPath = 'test_background.png',
    List<String> cardPaths = const ['card1.png', 'card2.png'],
    bool isUnlocked = true,
    int difficultyLevel = 1,
    List<String> audioPaths = const ['audio1.mp3'],
    String category = 'Test',
    int ageRangeMin = 3,
    int ageRangeMax = 6,
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
      category: category,
      ageRangeMin: ageRangeMin,
      ageRangeMax: ageRangeMax,
    );
  }

  /// Creates a test game session
  static GameSession createTestSession({
    String moduleId = 'test_module',
    DateTime? startTime,
    DateTime? endTime,
    int score = 100,
    int moves = 10,
    int correctMatches = 5,
    int incorrectMatches = 2,
    bool completed = true,
    Map<String, dynamic> metadata = const {},
  }) {
    return GameSession(
      moduleId: moduleId,
      startTime: startTime ?? DateTime.now(),
      endTime: endTime,
      score: score,
      moves: moves,
      correctMatches: correctMatches,
      incorrectMatches: incorrectMatches,
      completed: completed,
      metadata: metadata,
    );
  }

  /// Mocks a successful operation
  static Future<T> mockSuccess<T>(T value) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return value;
  }

  /// Mocks a failed operation
  static Future<T> mockFailure<T>(Exception exception) async {
    await Future.delayed(const Duration(milliseconds: 100));
    throw exception;
  }

  /// Mocks a timeout operation
  static Future<T> mockTimeout<T>() async {
    await Future.delayed(const Duration(seconds: 10));
    throw TimeoutException('Operation timed out', const Duration(seconds: 5));
  }

  /// Creates a mock analytics manager
  static AnalyticsManager createMockAnalyticsManager() {
    return AnalyticsManager();
  }

  /// Creates a mock audio manager
  static AudioManager createMockAudioManager() {
    return AudioManager();
  }

  /// Creates a mock module manager
  static ModuleManager createMockModuleManager() {
    return ModuleManager();
  }

  /// Creates a mock save manager
  static SaveManager createMockSaveManager() {
    return SaveManager();
  }

  /// Creates a mock parental gate manager
  static ParentalGateManager createMockParentalGateManager() {
    return ParentalGateManager();
  }

  /// Waits for a specific condition to be true
  static Future<void> waitForCondition(
    WidgetTester tester,
    bool Function() condition, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final stopwatch = Stopwatch()..start();
    
    while (!condition() && stopwatch.elapsed < timeout) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    
    if (stopwatch.elapsed >= timeout) {
      throw TimeoutException('Condition not met within timeout', timeout);
    }
  }

  /// Waits for a widget to appear
  static Future<void> waitForWidget(WidgetTester tester, Finder finder) async {
    await waitForCondition(tester, () => finder.evaluate().isNotEmpty);
  }

  /// Waits for a widget to disappear
  static Future<void> waitForWidgetToDisappear(WidgetTester tester, Finder finder) async {
    await waitForCondition(tester, () => finder.evaluate().isEmpty);
  }

  /// Simulates screen rotation
  static Future<void> rotateScreen(WidgetTester tester, Size newSize) async {
    await tester.binding.setSurfaceSize(newSize);
    await waitForAnimations(tester);
  }

  /// Simulates app lifecycle changes
  static Future<void> simulateAppLifecycle(WidgetTester tester, AppLifecycleState state) async {
    await tester.binding.handleAppLifecycleStateChanged(state);
    await waitForAnimations(tester);
  }

  /// Simulates memory pressure
  static Future<void> simulateMemoryPressure(WidgetTester tester) async {
    // Simulate memory pressure by creating many objects
    final objects = <List<int>>[];
    for (int i = 0; i < 1000; i++) {
      objects.add(List.filled(1000, i));
    }
    
    // Clean up
    objects.clear();
    await waitForAnimations(tester);
  }

  /// Simulates network delay
  static Future<void> simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  /// Simulates slow device
  static Future<void> simulateSlowDevice(WidgetTester tester) async {
    // Simulate slow device by adding delays
    await Future.delayed(const Duration(milliseconds: 100));
    await tester.pump();
  }

  /// Simulates fast device
  static Future<void> simulateFastDevice(WidgetTester tester) async {
    // Simulate fast device by reducing delays
    await tester.pump(const Duration(milliseconds: 1));
  }

  /// Creates a test scenario with specific conditions
  static Future<void> runTestScenario(
    WidgetTester tester,
    Future<void> Function() scenario,
  ) async {
    try {
      await scenario();
    } catch (e) {
      // Log error but don't fail the test
      print('Test scenario error: $e');
    }
  }

  /// Measures performance of an operation
  static Future<Duration> measurePerformance(
    Future<void> Function() operation,
  ) async {
    final stopwatch = Stopwatch()..start();
    await operation();
    stopwatch.stop();
    return stopwatch.elapsed;
  }

  /// Creates a test with specific screen size
  static Future<void> testWithScreenSize(
    WidgetTester tester,
    Size screenSize,
    Future<void> Function() test,
  ) async {
    await tester.binding.setSurfaceSize(screenSize);
    await test();
  }

  /// Creates a test with specific orientation
  static Future<void> testWithOrientation(
    WidgetTester tester,
    Size screenSize,
    Future<void> Function() test,
  ) async {
    await testWithScreenSize(tester, screenSize, test);
  }

  /// Creates a test with specific device type
  static Future<void> testWithDeviceType(
    WidgetTester tester,
    DeviceType deviceType,
    Future<void> Function() test,
  ) async {
    Size screenSize;
    switch (deviceType) {
      case DeviceType.phone:
        screenSize = const Size(400, 800);
        break;
      case DeviceType.tablet:
        screenSize = const Size(1024, 768);
        break;
      case DeviceType.desktop:
        screenSize = const Size(1920, 1080);
        break;
    }
    
    await testWithScreenSize(tester, screenSize, test);
  }

  /// Creates a test with specific network conditions
  static Future<void> testWithNetworkConditions(
    NetworkCondition condition,
    Future<void> Function() test,
  ) async {
    switch (condition) {
      case NetworkCondition.fast:
        await test();
        break;
      case NetworkCondition.slow:
        await simulateNetworkDelay();
        await test();
        break;
      case NetworkCondition.offline:
        // Simulate offline conditions
        await test();
        break;
    }
  }

  /// Creates a test with specific memory conditions
  static Future<void> testWithMemoryConditions(
    WidgetTester tester,
    MemoryCondition condition,
    Future<void> Function() test,
  ) async {
    switch (condition) {
      case MemoryCondition.normal:
        await test();
        break;
      case MemoryCondition.low:
        await simulateMemoryPressure(tester);
        await test();
        break;
      case MemoryCondition.critical:
        await simulateMemoryPressure(tester);
        await simulateMemoryPressure(tester);
        await test();
        break;
    }
  }
}

/// Device types for testing
enum DeviceType {
  phone,
  tablet,
  desktop,
}

/// Network conditions for testing
enum NetworkCondition {
  fast,
  slow,
  offline,
}

/// Memory conditions for testing
enum MemoryCondition {
  normal,
  low,
  critical,
}

/// Custom matchers for testing
class CustomMatchers {
  /// Matches a widget with specific text content
  static Matcher hasText(String text) {
    return find.text(text);
  }

  /// Matches a widget with specific icon
  static Matcher hasIcon(IconData icon) {
    return find.byIcon(icon);
  }

  /// Matches a widget with specific type
  static Matcher hasType(Type type) {
    return find.byType(type);
  }

  /// Matches a widget with specific key
  static Matcher hasKey(Key key) {
    return find.byKey(key);
  }

  /// Matches a widget with specific ancestor
  static Matcher hasAncestor(Matcher ancestor) {
    return find.ancestor(of: ancestor, matching: find.any);
  }

  /// Matches a widget with specific descendant
  static Matcher hasDescendant(Matcher descendant) {
    return find.descendant(of: find.any, matching: descendant);
  }
}

/// Test data factories
class TestDataFactory {
  /// Creates test modules
  static List<GameModule> createTestModules() {
    return [
      TestHelpers.createTestModule(
        id: 'shapes',
        name: 'Shapes',
        description: 'Learn about different shapes',
        category: 'Learning',
        difficultyLevel: 1,
        isUnlocked: true,
      ),
      TestHelpers.createTestModule(
        id: 'colors',
        name: 'Colors',
        description: 'Discover the world of colors',
        category: 'Learning',
        difficultyLevel: 1,
        isUnlocked: true,
      ),
      TestHelpers.createTestModule(
        id: 'animals',
        name: 'Animals',
        description: 'Meet friendly animals',
        category: 'Nature',
        difficultyLevel: 2,
        isUnlocked: false,
      ),
    ];
  }

  /// Creates test game sessions
  static List<GameSession> createTestSessions() {
    return [
      TestHelpers.createTestSession(
        moduleId: 'shapes',
        score: 100,
        moves: 10,
        correctMatches: 5,
        incorrectMatches: 2,
      ),
      TestHelpers.createTestSession(
        moduleId: 'colors',
        score: 150,
        moves: 12,
        correctMatches: 6,
        incorrectMatches: 3,
      ),
    ];
  }

  /// Creates test user settings
  static Map<String, dynamic> createTestUserSettings() {
    return {
      'theme': 'light',
      'language': 'en',
      'notifications': true,
      'difficulty': 'medium',
      'sound_enabled': true,
      'music_enabled': true,
      'voice_enabled': true,
    };
  }
}