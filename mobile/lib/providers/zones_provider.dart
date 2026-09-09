import 'package:flutter/foundation.dart';
import '../models/zone_model.dart';
import '../services/api/zones_api.dart';
import '../services/risk_cache_service.dart';

class ZonesProvider extends ChangeNotifier {
  final ZonesApi _zonesApi;
  final RiskCacheService _riskCache;

  ZonesProvider({required ZonesApi zonesApi, required RiskCacheService riskCache})
      : _zonesApi = zonesApi,
        _riskCache = riskCache;

  List<ZoneModel> _zones = [];
  ZoneModel? _currentZone;
  bool _isLoading = false;
  DateTime? _lastSyncedAt;

  List<ZoneModel> get zones => _zones;
  ZoneModel? get currentZone => _currentZone;
  bool get isLoading => _isLoading;
  DateTime? get lastSyncedAt => _lastSyncedAt;

  Future<void> loadZones() async {
    _isLoading = true;
    notifyListeners();

    try {
      _zones = await _zonesApi.getAllZones();
      await _riskCache.saveZones(_zones);
      _lastSyncedAt = DateTime.now();
    } catch (_) {
      _zones = await _riskCache.loadCachedZones();
      _lastSyncedAt = await _riskCache.getLastSyncedAt();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateCurrentLocation(double lat, double lon) {
    _currentZone = _findZoneContaining(lat, lon);
    notifyListeners();
  }

  ZoneModel? _findZoneContaining(double lat, double lon) {
    for (final zone in _zones) {
      if (_pointInPolygon(lat, lon, zone.polygon)) {
        return zone;
      }
    }
    return null;
  }

  bool _pointInPolygon(double lat, double lon, Map<String, dynamic> polygon) {
    final coords = (polygon['coordinates'] as List<dynamic>)[0] as List<dynamic>;
    bool inside = false;
    int j = coords.length - 1;

    for (int i = 0; i < coords.length; i++) {
      final xi = (coords[i][0] as num).toDouble();
      final yi = (coords[i][1] as num).toDouble();
      final xj = (coords[j][0] as num).toDouble();
      final yj = (coords[j][1] as num).toDouble();

      final intersects = ((yi > lat) != (yj > lat)) &&
          (lon < (xj - xi) * (lat - yi) / (yj - yi + 1e-12) + xi);
      if (intersects) inside = !inside;
      j = i;
    }
    return inside;
  }
}