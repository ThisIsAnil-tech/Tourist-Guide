class SosLocation {
  final double lat;
  final double lon;

  SosLocation({required this.lat, required this.lon});

  factory SosLocation.fromJson(Map<String, dynamic> json) {
    return SosLocation(
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {'lat': lat, 'lon': lon};
}

class SosEventModel {
  final String id;
  final String userId;
  final String eventType;
  final SosLocation location;
  final String deliveredVia;
  final String? zoneId;
  final String status;
  final bool isTest;
  final Map<String, dynamic> originMeta;
  final String? resolvedBy;
  final DateTime createdAt;
  final DateTime? resolvedAt;

  SosEventModel({
    required this.id,
    required this.userId,
    required this.eventType,
    required this.location,
    required this.deliveredVia,
    this.zoneId,
    required this.status,
    required this.isTest,
    required this.originMeta,
    this.resolvedBy,
    required this.createdAt,
    this.resolvedAt,
  });

  factory SosEventModel.fromJson(Map<String, dynamic> json) {
    return SosEventModel(
      id: json['_id'] as String,
      userId: json['user_id'] as String,
      eventType: json['event_type'] as String,
      location: SosLocation.fromJson(json['location'] as Map<String, dynamic>),
      deliveredVia: json['delivered_via'] as String,
      zoneId: json['zone_id'] as String?,
      status: json['status'] as String,
      isTest: json['is_test'] as bool? ?? false,
      originMeta: json['origin_meta'] as Map<String, dynamic>? ?? {},
      resolvedBy: json['resolved_by'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      resolvedAt: json['resolved_at'] != null
          ? DateTime.parse(json['resolved_at'] as String)
          : null,
    );
  }

  bool get isActive => status == 'active';

  List<String> get relayChain =>
      (originMeta['relay_chain'] as List<dynamic>? ?? []).map((e) => e as String).toList();

  int get hopCount => originMeta['hop_count'] as int? ?? 0;
}