import 'dart:async';
import 'package:geolocator/geolocator.dart';
import '../core/utils/haversine.dart';
import 'sos_pipeline_service.dart';

class GpsAnomalyService {
  static const _minMovementMeters = 50.0;
  static const _checkInterval = Duration(minutes: 10);
  static const _anomalyLimit = 3;

  final SosPipelineService _pipeline;

  Position? _lastPosition;
  int _anomalyCounter = 0;
  Timer? _timer;
  bool _isInHighRiskZone = false;

  GpsAnomalyService({required SosPipelineService pipeline}) : _pipeline = pipeline;

  void updateZoneRiskStatus(bool isHighRisk) {
    _isInHighRiskZone = isHighRisk;
  }

  Future<void> start() async {
    _lastPosition = await Geolocator.getCurrentPosition();
    _timer = Timer.periodic(_checkInterval, (_) => _checkMovement());
  }

  Future<void> stop() async {
    _timer?.cancel();
  }

  Future<void> _checkMovement() async {
    final currentPosition = await Geolocator.getCurrentPosition();

    if (_lastPosition == null) {
      _lastPosition = currentPosition;
      return;
    }

    final distance = Haversine.distanceMeters(
      _lastPosition!.latitude,
      _lastPosition!.longitude,
      currentPosition.latitude,
      currentPosition.longitude,
    );

    if (distance < _minMovementMeters && _isInHighRiskZone) {
      _anomalyCounter++;
    } else {
      _anomalyCounter = 0;
    }

    if (_anomalyCounter >= _anomalyLimit) {
      await _pipeline.triggerFromDetector(eventType: 'ABNORMAL_STOPPAGE');
      _anomalyCounter = 0;
    }

    _lastPosition = currentPosition;
  }
}