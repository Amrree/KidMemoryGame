import 'dart:io';

/// Comprehensive test runner for the Kid Memory Template app
/// This script runs all types of tests and generates a detailed report
void main(List<String> args) async {
  print('🧪 Starting Comprehensive Test Suite for Kid Memory Template');
  print('=' * 60);
  
  final results = <String, TestResult>{};
  
  // Run unit tests
  print('\n📋 Running Unit Tests...');
  results['unit'] = await runTestSuite('test/unit', 'Unit Tests');
  
  // Run widget tests
  print('\n🎨 Running Widget Tests...');
  results['widget'] = await runTestSuite('test/widget', 'Widget Tests');
  
  // Run integration tests
  print('\n🔗 Running Integration Tests...');
  results['integration'] = await runTestSuite('test/integration', 'Integration Tests');
  
  // Run stress tests
  print('\n💪 Running Stress Tests...');
  results['stress'] = await runTestSuite('test/stress', 'Stress Tests');
  
  // Run performance tests
  print('\n⚡ Running Performance Tests...');
  results['performance'] = await runTestSuite('test/performance', 'Performance Tests');
  
  // Generate comprehensive report
  print('\n📊 Test Results Summary');
  print('=' * 60);
  
  int totalTests = 0;
  int passedTests = 0;
  int failedTests = 0;
  
  for (final entry in results.entries) {
    final result = entry.value;
    totalTests += result.totalTests;
    passedTests += result.passedTests;
    failedTests += result.failedTests;
    
    print('${entry.key.toUpperCase()}: ${result.passedTests}/${result.totalTests} passed');
    if (result.failedTests > 0) {
      print('  ❌ ${result.failedTests} failed');
    }
    if (result.duration != null) {
      print('  ⏱️  Duration: ${result.duration!.inMilliseconds}ms');
    }
  }
  
  print('\n📈 Overall Results:');
  print('  Total Tests: $totalTests');
  print('  ✅ Passed: $passedTests');
  print('  ❌ Failed: $failedTests');
  print('  📊 Success Rate: ${((passedTests / totalTests) * 100).toStringAsFixed(1)}%');
  
  if (failedTests > 0) {
    print('\n⚠️  Some tests failed. Please review the output above.');
    exit(1);
  } else {
    print('\n🎉 All tests passed! The app is ready for production.');
    exit(0);
  }
}

class TestResult {
  final int totalTests;
  final int passedTests;
  final int failedTests;
  final Duration? duration;
  
  TestResult({
    required this.totalTests,
    required this.passedTests,
    required this.failedTests,
    this.duration,
  });
}

Future<TestResult> runTestSuite(String testPath, String suiteName) async {
  try {
    final stopwatch = Stopwatch()..start();
    
    final result = await Process.run(
      'flutter',
      ['test', testPath, '--reporter=expanded'],
      workingDirectory: Directory.current.path,
    );
    
    stopwatch.stop();
    
    final output = result.stdout.toString();
    final errorOutput = result.stderr.toString();
    
    // Parse test results
    final lines = output.split('\n');
    int totalTests = 0;
    int passedTests = 0;
    int failedTests = 0;
    
    for (final line in lines) {
      if (line.contains('All tests passed!')) {
        // Extract test count from "All X tests passed!" message
        final match = RegExp(r'All (\d+) tests passed!').firstMatch(line);
        if (match != null) {
          totalTests = int.parse(match.group(1)!);
          passedTests = totalTests;
        }
      } else if (line.contains('Some tests failed')) {
        // Extract test counts from failure message
        final totalMatch = RegExp(r'(\d+) tests').firstMatch(line);
        final failedMatch = RegExp(r'(\d+) failed').firstMatch(line);
        if (totalMatch != null) {
          totalTests = int.parse(totalMatch.group(1)!);
        }
        if (failedMatch != null) {
          failedTests = int.parse(failedMatch.group(1)!);
          passedTests = totalTests - failedTests;
        }
      }
    }
    
    if (result.exitCode == 0) {
      print('  ✅ $suiteName completed successfully');
    } else {
      print('  ❌ $suiteName failed');
      if (errorOutput.isNotEmpty) {
        print('  Error: $errorOutput');
      }
    }
    
    return TestResult(
      totalTests: totalTests,
      passedTests: passedTests,
      failedTests: failedTests,
      duration: stopwatch.elapsed,
    );
    
  } catch (e) {
    print('  ❌ Error running $suiteName: $e');
    return TestResult(
      totalTests: 0,
      passedTests: 0,
      failedTests: 1,
    );
  }
}