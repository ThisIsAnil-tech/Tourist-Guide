import 'package:flutter/foundation.dart';
import '../services/secure_storage_service.dart';

class SettingsProvider extends ChangeNotifier {
  final SecureStorageService _storage;

  SettingsProvider({required SecureStorageService storage}) : _storage = storage;

  double _detectionSensitivity = 0.85;
  bool _notificationsEnabled = true;
  String _languageCode = 'en';
  bool _isDarkMode = false;

  double get detectionSensitivity => _detectionSensitivity;
  bool get notificationsEnabled => _notificationsEnabled;
  String get languageCode => _languageCode;
  bool get isDarkMode => _isDarkMode;

  Future<void> loadSettings() async {
    _detectionSensitivity = await _storage.getDetectionSensitivity() ?? 0.85;
    _notificationsEnabled = await _storage.getNotificationsEnabled() ?? true;
    _languageCode = await _storage.getLanguageCode() ?? 'en';
    _isDarkMode = await _storage.getDarkModeEnabled() ?? false;
    notifyListeners();
  }

  Future<void> setDetectionSensitivity(double value) async {
    _detectionSensitivity = value;
    await _storage.saveDetectionSensitivity(value);
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool value) async {
    _notificationsEnabled = value;
    await _storage.saveNotificationsEnabled(value);
    notifyListeners();
  }

  Future<void> setLanguageCode(String code) async {
    _languageCode = code;
    await _storage.saveLanguageCode(code);
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;
    await _storage.saveDarkModeEnabled(value);
    notifyListeners();
  }
}