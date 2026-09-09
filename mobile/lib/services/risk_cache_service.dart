import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/zone_model.dart';

class RiskCacheService {
  static const _zonesKey = 'cached_zones';
  static const _syncedAtKey = 'zones_synced_at';

  Future<void> saveZones(List<ZoneModel> zones) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = zones
        .map((z) => {
              '_id': z.id,
              'name': z.name,
              'polygon': z.polygon,
              'coordinates': {'lat': z.lat, 'lon': z.lon},
              'region_keywords': z.regionKeywords,
              'risk_score': z.riskScore,
              'weather_snapshot': z.weatherSnapshot,
              'news_summary': z.newsSummary,
              'last_updated': z.lastUpdated.toIso8601String(),
            })
        .toList();

    await prefs.setString(_zonesKey, jsonEncode(encoded));
    await prefs.setString(_syncedAtKey, DateTime.now().toIso8601String());
  }

  Future<List<ZoneModel>> loadCachedZones() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_zonesKey);
    if (raw == null) return [];

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => ZoneModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<DateTime?> getLastSyncedAt() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_syncedAtKey);
    return raw != null ? DateTime.parse(raw) : null;
  }
}