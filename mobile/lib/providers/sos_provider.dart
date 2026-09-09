import 'package:flutter/foundation.dart';
import '../models/sos_event_model.dart';
import '../services/sos_pipeline_service.dart';
import '../services/api/sos_api.dart';

class SosProvider extends ChangeNotifier {
  final SosPipelineService _pipeline;
  final SosApi _sosApi;

  SosProvider({required SosPipelineService pipeline, required SosApi sosApi})
      : _pipeline = pipeline,
        _sosApi = sosApi;

  SosEventModel? _activeEvent;
  List<SosEventModel> _history = [];
  bool _isTriggering = false;
  bool _isLoadingHistory = false;

  SosEventModel? get activeEvent => _activeEvent;
  List<SosEventModel> get history => _history;
  bool get isTriggering => _isTriggering;
  bool get isLoadingHistory => _isLoadingHistory;
  bool get hasActiveEvent => _activeEvent != null && _activeEvent!.isActive;

  Future<SosEventModel> triggerSos({
    required String eventType,
    required double lat,
    required double lon,
    bool isTest = false,
  }) async {
    _isTriggering = true;
    notifyListeners();

    try {
      final event = await _pipeline.sendAlert(
        eventType: eventType,
        lat: lat,
        lon: lon,
        isTest: isTest,
      );
      _activeEvent = event;
      return event;
    } finally {
      _isTriggering = false;
      notifyListeners();
    }
  }

  Future<void> resolveActiveEvent() async {
    if (_activeEvent == null) return;
    await _sosApi.resolveEvent(_activeEvent!.id);
    _activeEvent = null;
    notifyListeners();
    await loadHistory();
  }

  Future<void> loadHistory() async {
    _isLoadingHistory = true;
    notifyListeners();

    try {
      _history = await _sosApi.getMyEvents();
    } finally {
      _isLoadingHistory = false;
      notifyListeners();
    }
  }

  void clearActiveEvent() {
    _activeEvent = null;
    notifyListeners();
  }
}