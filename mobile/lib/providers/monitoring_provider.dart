import 'package:flutter/foundation.dart';
import '../services/audio_classification_service.dart';
import '../services/gps_anomaly_service.dart';
import '../services/background_service.dart';

class MonitoringProvider extends ChangeNotifier {
  final AudioClassificationService _audioService;
  final GpsAnomalyService _gpsService;
  final BackgroundService _backgroundService;

  MonitoringProvider({
    required AudioClassificationService audioService,
    required GpsAnomalyService gpsService,
    required BackgroundService backgroundService,
  })  : _audioService = audioService,
        _gpsService = gpsService,
        _backgroundService = backgroundService;

  bool _isActive = false;
  bool _isStarting = false;

  bool get isActive => _isActive;
  bool get isStarting => _isStarting;

  Future<void> startMonitoring() async {
    if (_isActive || _isStarting) return;
    _isStarting = true;
    notifyListeners();

    try {
      await _audioService.start();
      await _gpsService.start();
      await _backgroundService.enable();
      _isActive = true;
    } finally {
      _isStarting = false;
      notifyListeners();
    }
  }

  Future<void> stopMonitoring() async {
    await _audioService.stop();
    await _gpsService.stop();
    await _backgroundService.disable();
    _isActive = false;
    notifyListeners();
  }
}