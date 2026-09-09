class ZoneModel {
  final String id;
  final String name;
  final Map<String, dynamic> polygon;
  final double lat;
  final double lon;
  final List<String> regionKeywords;
  final double riskScore;
  final Map<String, dynamic> weatherSnapshot;
  final String? newsSummary;
  final DateTime lastUpdated;

  ZoneModel({
    required this.id,
    required this.name,
    required this.polygon,
    required this.lat,
    required this.lon,
    required this.regionKeywords,
    required this.riskScore,
    required this.weatherSnapshot,
    this.newsSummary,
    required this.lastUpdated,
  });

  factory ZoneModel.fromJson(Map<String, dynamic> json) {
    final coordinates = json['coordinates'] as Map<String, dynamic>;
    return ZoneModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      polygon: json['polygon'] as Map<String, dynamic>,
      lat: (coordinates['lat'] as num).toDouble(),
      lon: (coordinates['lon'] as num).toDouble(),
      regionKeywords: (json['region_keywords'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
      riskScore: (json['risk_score'] as num).toDouble(),
      weatherSnapshot: json['weather_snapshot'] as Map<String, dynamic>? ?? {},
      newsSummary: json['news_summary'] as String?,
      lastUpdated: DateTime.parse(json['last_updated'] as String),
    );
  }

  String get riskLevel {
    if (riskScore >= 7) return 'high';
    if (riskScore >= 4) return 'medium';
    return 'low';
  }
}