import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages parental controls and access restrictions
class ParentalGateManager extends ChangeNotifier {
  static final ParentalGateManager _instance = ParentalGateManager._internal();
  factory ParentalGateManager() => _instance;
  ParentalGateManager._internal();

  late SharedPreferences _prefs;
  
  bool _isEnabled = true;
  bool _isUnlocked = false;
  String _passcode = '1234'; // Default passcode
  int _unlockAttempts = 0;
  int _maxAttempts = 3;
  DateTime? _lastUnlockTime;
  Duration _lockoutDuration = const Duration(minutes: 5);
  
  // Settings that require parental gate
  bool _analyticsEnabled = true;
  bool _purchasesEnabled = false;
  bool _dataCollectionEnabled = true;
  bool _advertisementsEnabled = false;
  bool _socialFeaturesEnabled = false;

  // Getters
  bool get isEnabled => _isEnabled;
  bool get isUnlocked => _isUnlocked;
  bool get analyticsEnabled => _analyticsEnabled;
  bool get purchasesEnabled => _purchasesEnabled;
  bool get dataCollectionEnabled => _dataCollectionEnabled;
  bool get advertisementsEnabled => _advertisementsEnabled;
  bool get socialFeaturesEnabled => _socialFeaturesEnabled;
  int get unlockAttempts => _unlockAttempts;
  int get maxAttempts => _maxAttempts;
  bool get isLockedOut => _isLockedOut();

  /// Initialize the parental gate manager
  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      await _loadSettings();
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing ParentalGateManager: $e');
      }
    }
  }

  /// Load settings from storage
  Future<void> _loadSettings() async {
    _isEnabled = _prefs.getBool('parental_gate_enabled') ?? true;
    _passcode = _prefs.getString('parental_gate_passcode') ?? '1234';
    _unlockAttempts = _prefs.getInt('parental_gate_attempts') ?? 0;
    _lastUnlockTime = _prefs.getString('parental_gate_last_unlock') != null
        ? DateTime.parse(_prefs.getString('parental_gate_last_unlock')!)
        : null;
    
    _analyticsEnabled = _prefs.getBool('analytics_enabled') ?? true;
    _purchasesEnabled = _prefs.getBool('purchases_enabled') ?? false;
    _dataCollectionEnabled = _prefs.getBool('data_collection_enabled') ?? true;
    _advertisementsEnabled = _prefs.getBool('advertisements_enabled') ?? false;
    _socialFeaturesEnabled = _prefs.getBool('social_features_enabled') ?? false;
  }

  /// Save settings to storage
  Future<void> _saveSettings() async {
    await _prefs.setBool('parental_gate_enabled', _isEnabled);
    await _prefs.setString('parental_gate_passcode', _passcode);
    await _prefs.setInt('parental_gate_attempts', _unlockAttempts);
    await _prefs.setString('parental_gate_last_unlock', 
        _lastUnlockTime?.toIso8601String() ?? '');
    
    await _prefs.setBool('analytics_enabled', _analyticsEnabled);
    await _prefs.setBool('purchases_enabled', _purchasesEnabled);
    await _prefs.setBool('data_collection_enabled', _dataCollectionEnabled);
    await _prefs.setBool('advertisements_enabled', _advertisementsEnabled);
    await _prefs.setBool('social_features_enabled', _socialFeaturesEnabled);
  }

  /// Check if currently locked out
  bool _isLockedOut() {
    if (_lastUnlockTime == null) return false;
    return DateTime.now().difference(_lastUnlockTime!) < _lockoutDuration;
  }

  /// Attempt to unlock with passcode
  Future<bool> attemptUnlock(String enteredPasscode) async {
    if (!_isEnabled) {
      _isUnlocked = true;
      return true;
    }

    if (_isLockedOut()) {
      if (kDebugMode) {
        print('Parental gate is locked out');
      }
      return false;
    }

    if (enteredPasscode == _passcode) {
      _isUnlocked = true;
      _unlockAttempts = 0;
      _lastUnlockTime = DateTime.now();
      await _saveSettings();
      notifyListeners();
      
      if (kDebugMode) {
        print('Parental gate unlocked successfully');
      }
      return true;
    } else {
      _unlockAttempts++;
      await _saveSettings();
      
      if (_unlockAttempts >= _maxAttempts) {
        _lastUnlockTime = DateTime.now();
        await _saveSettings();
        
        if (kDebugMode) {
          print('Parental gate locked out after $maxAttempts failed attempts');
        }
      }
      
      notifyListeners();
      return false;
    }
  }

  /// Lock the parental gate
  Future<void> lock() async {
    _isUnlocked = false;
    notifyListeners();
    
    if (kDebugMode) {
      print('Parental gate locked');
    }
  }

  /// Set new passcode
  Future<bool> setPasscode(String newPasscode) async {
    if (!_isUnlocked) return false;
    
    if (newPasscode.length < 4) return false;
    
    _passcode = newPasscode;
    await _saveSettings();
    
    if (kDebugMode) {
      print('Parental gate passcode updated');
    }
    return true;
  }

  /// Enable/disable parental gate
  Future<void> setEnabled(bool enabled) async {
    if (!_isUnlocked) return;
    
    _isEnabled = enabled;
    if (!enabled) {
      _isUnlocked = true;
    }
    await _saveSettings();
    notifyListeners();
    
    if (kDebugMode) {
      print('Parental gate ${enabled ? 'enabled' : 'disabled'}');
    }
  }

  /// Set analytics enabled
  Future<void> setAnalyticsEnabled(bool enabled) async {
    if (!_isUnlocked) return;
    
    _analyticsEnabled = enabled;
    await _saveSettings();
    notifyListeners();
    
    if (kDebugMode) {
      print('Analytics ${enabled ? 'enabled' : 'disabled'}');
    }
  }

  /// Set purchases enabled
  Future<void> setPurchasesEnabled(bool enabled) async {
    if (!_isUnlocked) return;
    
    _purchasesEnabled = enabled;
    await _saveSettings();
    notifyListeners();
    
    if (kDebugMode) {
      print('Purchases ${enabled ? 'enabled' : 'disabled'}');
    }
  }

  /// Set data collection enabled
  Future<void> setDataCollectionEnabled(bool enabled) async {
    if (!_isUnlocked) return;
    
    _dataCollectionEnabled = enabled;
    await _saveSettings();
    notifyListeners();
    
    if (kDebugMode) {
      print('Data collection ${enabled ? 'enabled' : 'disabled'}');
    }
  }

  /// Set advertisements enabled
  Future<void> setAdvertisementsEnabled(bool enabled) async {
    if (!_isUnlocked) return;
    
    _advertisementsEnabled = enabled;
    await _saveSettings();
    notifyListeners();
    
    if (kDebugMode) {
      print('Advertisements ${enabled ? 'enabled' : 'disabled'}');
    }
  }

  /// Set social features enabled
  Future<void> setSocialFeaturesEnabled(bool enabled) async {
    if (!_isUnlocked) return;
    
    _socialFeaturesEnabled = enabled;
    await _saveSettings();
    notifyListeners();
    
    if (kDebugMode) {
      print('Social features ${enabled ? 'enabled' : 'disabled'}');
    }
  }

  /// Check if a feature requires parental gate
  bool requiresParentalGate(String feature) {
    switch (feature) {
      case 'analytics':
        return _isEnabled && !_analyticsEnabled;
      case 'purchases':
        return _isEnabled && !_purchasesEnabled;
      case 'data_collection':
        return _isEnabled && !_dataCollectionEnabled;
      case 'advertisements':
        return _isEnabled && !_advertisementsEnabled;
      case 'social_features':
        return _isEnabled && !_socialFeaturesEnabled;
      default:
        return _isEnabled;
    }
  }

  /// Check if a feature is allowed
  bool isFeatureAllowed(String feature) {
    if (!_isEnabled) return true;
    if (!_isUnlocked) return false;
    
    switch (feature) {
      case 'analytics':
        return _analyticsEnabled;
      case 'purchases':
        return _purchasesEnabled;
      case 'data_collection':
        return _dataCollectionEnabled;
      case 'advertisements':
        return _advertisementsEnabled;
      case 'social_features':
        return _socialFeaturesEnabled;
      default:
        return true;
    }
  }

  /// Get remaining lockout time
  Duration? getRemainingLockoutTime() {
    if (!_isLockedOut()) return null;
    
    final elapsed = DateTime.now().difference(_lastUnlockTime!);
    return _lockoutDuration - elapsed;
  }

  /// Reset lockout (for testing)
  Future<void> resetLockout() async {
    _unlockAttempts = 0;
    _lastUnlockTime = null;
    await _saveSettings();
    notifyListeners();
    
    if (kDebugMode) {
      print('Parental gate lockout reset');
    }
  }

  /// Get all settings
  Map<String, dynamic> getAllSettings() {
    return {
      'isEnabled': _isEnabled,
      'isUnlocked': _isUnlocked,
      'analyticsEnabled': _analyticsEnabled,
      'purchasesEnabled': _purchasesEnabled,
      'dataCollectionEnabled': _dataCollectionEnabled,
      'advertisementsEnabled': _advertisementsEnabled,
      'socialFeaturesEnabled': _socialFeaturesEnabled,
      'unlockAttempts': _unlockAttempts,
      'maxAttempts': _maxAttempts,
      'isLockedOut': _isLockedOut(),
      'remainingLockoutTime': getRemainingLockoutTime()?.inSeconds,
    };
  }

  /// Load settings from map
  Future<void> loadSettings(Map<String, dynamic> settings) async {
    _isEnabled = settings['isEnabled'] ?? true;
    _analyticsEnabled = settings['analyticsEnabled'] ?? true;
    _purchasesEnabled = settings['purchasesEnabled'] ?? false;
    _dataCollectionEnabled = settings['dataCollectionEnabled'] ?? true;
    _advertisementsEnabled = settings['advertisementsEnabled'] ?? false;
    _socialFeaturesEnabled = settings['socialFeaturesEnabled'] ?? false;
    
    await _saveSettings();
    notifyListeners();
  }
}