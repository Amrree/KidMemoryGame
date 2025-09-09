import 'package:flutter_test/flutter_test.dart';
import 'package:kidsgame/core/managers/parental_gate_manager.dart';

void main() {
  group('ParentalGateManager Unit Tests', () {
    late ParentalGateManager parentalGateManager;

    setUp(() async {
      parentalGateManager = ParentalGateManager();
    });

    tearDown(() {
      parentalGateManager.dispose();
    });

    test('should initialize with default values', () async {
      await parentalGateManager.init();
      
      expect(parentalGateManager.isEnabled, true);
      expect(parentalGateManager.isUnlocked, false);
      expect(parentalGateManager.analyticsEnabled, true);
      expect(parentalGateManager.purchasesEnabled, false);
      expect(parentalGateManager.dataCollectionEnabled, true);
      expect(parentalGateManager.advertisementsEnabled, false);
      expect(parentalGateManager.socialFeaturesEnabled, false);
      expect(parentalGateManager.unlockAttempts, 0);
      expect(parentalGateManager.maxAttempts, 3);
      expect(parentalGateManager.isLockedOut, false);
    });

    test('should attempt unlock with correct passcode', () async {
      await parentalGateManager.init();
      
      final success = await parentalGateManager.attemptUnlock('1234');
      
      expect(success, true);
      expect(parentalGateManager.isUnlocked, true);
    });

    test('should fail unlock with incorrect passcode', () async {
      await parentalGateManager.init();
      
      final success = await parentalGateManager.attemptUnlock('0000');
      
      expect(success, false);
      expect(parentalGateManager.isUnlocked, false);
      expect(parentalGateManager.unlockAttempts, 1);
    });

    test('should lock out after max attempts', () async {
      await parentalGateManager.init();
      
      // Try wrong passcode 3 times
      for (int i = 0; i < 3; i++) {
        final success = await parentalGateManager.attemptUnlock('0000');
        expect(success, false);
      }
      
      expect(parentalGateManager.isLockedOut, true);
      expect(parentalGateManager.unlockAttempts, 3);
      
      // Should not be able to unlock even with correct passcode
      final success = await parentalGateManager.attemptUnlock('1234');
      expect(success, false);
    });

    test('should reset attempts after successful unlock', () async {
      await parentalGateManager.init();
      
      // Try wrong passcode twice
      await parentalGateManager.attemptUnlock('0000');
      await parentalGateManager.attemptUnlock('0000');
      expect(parentalGateManager.unlockAttempts, 2);
      
      // Correct passcode should reset attempts
      final success = await parentalGateManager.attemptUnlock('1234');
      expect(success, true);
      expect(parentalGateManager.unlockAttempts, 0);
    });

    test('should lock parental gate', () async {
      await parentalGateManager.init();
      
      // First unlock
      await parentalGateManager.attemptUnlock('1234');
      expect(parentalGateManager.isUnlocked, true);
      
      // Then lock
      parentalGateManager.lock();
      expect(parentalGateManager.isUnlocked, false);
    });

    test('should set new passcode when unlocked', () async {
      await parentalGateManager.init();
      
      await parentalGateManager.attemptUnlock('1234');
      
      final success = parentalGateManager.setPasscode('5678');
      expect(success, true);
      
      // Lock and try new passcode
      parentalGateManager.lock();
      final unlockSuccess = await parentalGateManager.attemptUnlock('5678');
      expect(unlockSuccess, true);
    });

    test('should reject short passcode', () async {
      await parentalGateManager.init();
      
      await parentalGateManager.attemptUnlock('1234');
      
      final success = parentalGateManager.setPasscode('123');
      expect(success, false);
    });

    test('should not set passcode when locked', () async {
      await parentalGateManager.init();
      
      // Don't unlock first
      final success = parentalGateManager.setPasscode('5678');
      expect(success, false);
    });

    test('should enable/disable parental gate when unlocked', () async {
      await parentalGateManager.init();
      
      await parentalGateManager.attemptUnlock('1234');
      
      parentalGateManager.setEnabled(false);
      expect(parentalGateManager.isEnabled, false);
      expect(parentalGateManager.isUnlocked, true); // Should remain unlocked
      
      parentalGateManager.setEnabled(true);
      expect(parentalGateManager.isEnabled, true);
    });

    test('should not change settings when locked', () async {
      await parentalGateManager.init();
      
      // Don't unlock first
      parentalGateManager.setAnalyticsEnabled(false);
      parentalGateManager.setPurchasesEnabled(true);
      parentalGateManager.setDataCollectionEnabled(false);
      parentalGateManager.setAdvertisementsEnabled(true);
      parentalGateManager.setSocialFeaturesEnabled(true);
      
      // Settings should remain unchanged
      expect(parentalGateManager.analyticsEnabled, true);
      expect(parentalGateManager.purchasesEnabled, false);
      expect(parentalGateManager.dataCollectionEnabled, true);
      expect(parentalGateManager.advertisementsEnabled, false);
      expect(parentalGateManager.socialFeaturesEnabled, false);
    });

    test('should change settings when unlocked', () async {
      await parentalGateManager.init();
      
      await parentalGateManager.attemptUnlock('1234');
      
      parentalGateManager.setAnalyticsEnabled(false);
      parentalGateManager.setPurchasesEnabled(true);
      parentalGateManager.setDataCollectionEnabled(false);
      parentalGateManager.setAdvertisementsEnabled(true);
      parentalGateManager.setSocialFeaturesEnabled(true);
      
      expect(parentalGateManager.analyticsEnabled, false);
      expect(parentalGateManager.purchasesEnabled, true);
      expect(parentalGateManager.dataCollectionEnabled, false);
      expect(parentalGateManager.advertisementsEnabled, true);
      expect(parentalGateManager.socialFeaturesEnabled, true);
    });

    test('should check if feature requires parental gate', () async {
      await parentalGateManager.init();
      
      // When enabled and unlocked
      await parentalGateManager.attemptUnlock('1234');
      expect(parentalGateManager.requiresParentalGate('analytics'), false);
      expect(parentalGateManager.requiresParentalGate('purchases'), true);
      
      // When enabled but locked
      parentalGateManager.lock();
      expect(parentalGateManager.requiresParentalGate('analytics'), true);
      expect(parentalGateManager.requiresParentalGate('purchases'), true);
      
      // When disabled
      parentalGateManager.setEnabled(false);
      expect(parentalGateManager.requiresParentalGate('analytics'), false);
      expect(parentalGateManager.requiresParentalGate('purchases'), false);
    });

    test('should check if feature is allowed', () async {
      await parentalGateManager.init();
      
      // When enabled and unlocked
      await parentalGateManager.attemptUnlock('1234');
      expect(parentalGateManager.isFeatureAllowed('analytics'), true);
      expect(parentalGateManager.isFeatureAllowed('purchases'), false);
      
      // When enabled but locked
      parentalGateManager.lock();
      expect(parentalGateManager.isFeatureAllowed('analytics'), false);
      expect(parentalGateManager.isFeatureAllowed('purchases'), false);
      
      // When disabled
      parentalGateManager.setEnabled(false);
      expect(parentalGateManager.isFeatureAllowed('analytics'), true);
      expect(parentalGateManager.isFeatureAllowed('purchases'), true);
    });

    test('should get remaining lockout time', () async {
      await parentalGateManager.init();
      
      // Try wrong passcode 3 times to trigger lockout
      for (int i = 0; i < 3; i++) {
        await parentalGateManager.attemptUnlock('0000');
      }
      
      expect(parentalGateManager.isLockedOut, true);
      
      final remainingTime = parentalGateManager.getRemainingLockoutTime();
      expect(remainingTime, isNotNull);
      expect(remainingTime!.inSeconds, greaterThan(0));
    });

    test('should reset lockout', () async {
      await parentalGateManager.init();
      
      // Trigger lockout
      for (int i = 0; i < 3; i++) {
        await parentalGateManager.attemptUnlock('0000');
      }
      
      expect(parentalGateManager.isLockedOut, true);
      
      // Reset lockout
      await parentalGateManager.resetLockout();
      
      expect(parentalGateManager.isLockedOut, false);
      expect(parentalGateManager.unlockAttempts, 0);
    });

    test('should get all settings', () async {
      await parentalGateManager.init();
      
      await parentalGateManager.attemptUnlock('1234');
      parentalGateManager.setAnalyticsEnabled(false);
      parentalGateManager.setPurchasesEnabled(true);
      
      final settings = parentalGateManager.getAllSettings();
      
      expect(settings['isEnabled'], true);
      expect(settings['isUnlocked'], true);
      expect(settings['analyticsEnabled'], false);
      expect(settings['purchasesEnabled'], true);
      expect(settings['unlockAttempts'], 0);
      expect(settings['isLockedOut'], false);
    });

    test('should load settings from map', () async {
      await parentalGateManager.init();
      
      final settings = {
        'isEnabled': false,
        'analyticsEnabled': false,
        'purchasesEnabled': true,
        'dataCollectionEnabled': false,
        'advertisementsEnabled': true,
        'socialFeaturesEnabled': true,
      };
      
      await parentalGateManager.loadSettings(settings);
      
      expect(parentalGateManager.isEnabled, false);
      expect(parentalGateManager.analyticsEnabled, false);
      expect(parentalGateManager.purchasesEnabled, true);
      expect(parentalGateManager.dataCollectionEnabled, false);
      expect(parentalGateManager.advertisementsEnabled, true);
      expect(parentalGateManager.socialFeaturesEnabled, true);
    });

    test('should handle rapid unlock attempts', () async {
      await parentalGateManager.init();
      
      // Rapid wrong attempts
      for (int i = 0; i < 5; i++) {
        await parentalGateManager.attemptUnlock('0000');
      }
      
      expect(parentalGateManager.isLockedOut, true);
      expect(parentalGateManager.unlockAttempts, 3); // Should cap at max attempts
    });

    test('should handle concurrent operations', () async {
      await parentalGateManager.init();
      
      // Simulate concurrent operations
      final futures = <Future>[];
      
      for (int i = 0; i < 10; i++) {
        futures.add(parentalGateManager.attemptUnlock('1234'));
      }
      
      final results = await Future.wait(futures);
      
      // Only one should succeed
      final successCount = results.where((r) => r == true).length;
      expect(successCount, 1);
    });

    test('should handle feature checks for all features', () async {
      await parentalGateManager.init();
      
      await parentalGateManager.attemptUnlock('1234');
      
      // Test all feature types
      expect(parentalGateManager.isFeatureAllowed('analytics'), true);
      expect(parentalGateManager.isFeatureAllowed('purchases'), false);
      expect(parentalGateManager.isFeatureAllowed('data_collection'), true);
      expect(parentalGateManager.isFeatureAllowed('advertisements'), false);
      expect(parentalGateManager.isFeatureAllowed('social_features'), false);
      expect(parentalGateManager.isFeatureAllowed('unknown_feature'), true);
    });

    test('should handle lockout duration correctly', () async {
      await parentalGateManager.init();
      
      // Trigger lockout
      for (int i = 0; i < 3; i++) {
        await parentalGateManager.attemptUnlock('0000');
      }
      
      expect(parentalGateManager.isLockedOut, true);
      
      // Wait for lockout to expire (in real app, this would be 5 minutes)
      // For testing, we'll reset the lockout
      await parentalGateManager.resetLockout();
      
      expect(parentalGateManager.isLockedOut, false);
      
      // Should be able to unlock again
      final success = await parentalGateManager.attemptUnlock('1234');
      expect(success, true);
    });
  });
}