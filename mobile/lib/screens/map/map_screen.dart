import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/zones_provider.dart';
import '../../models/zone_model.dart';
import 'widgets/zone_detail_sheet.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;

  Color _riskColor(String level) {
    switch (level) {
      case 'high':
        return AppColors.riskHigh;
      case 'medium':
        return AppColors.riskMedium;
      default:
        return AppColors.riskLow;
    }
  }

  Set<Polygon> _buildPolygons(List<ZoneModel> zones) {
    return zones.map((zone) {
      final coords = (zone.polygon['coordinates'] as List<dynamic>)[0] as List<dynamic>;
      final points = coords
          .map((c) => LatLng((c[1] as num).toDouble(), (c[0] as num).toDouble()))
          .toList();

      return Polygon(
        polygonId: PolygonId(zone.id),
        points: points,
        fillColor: _riskColor(zone.riskLevel).withOpacity(0.25),
        strokeColor: _riskColor(zone.riskLevel),
        strokeWidth: 2,
        consumeTapEvents: true,
        onTap: () => _showZoneDetail(zone),
      );
    }).toSet();
  }

  void _showZoneDetail(ZoneModel zone) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => ZoneDetailSheet(zone: zone),
    );
  }

  @override
  Widget build(BuildContext context) {
    final zonesProvider = context.watch<ZonesProvider>();
    final zones = zonesProvider.zones;

    final initialTarget = zones.isNotEmpty
        ? LatLng(zones.first.lat, zones.first.lon)
        : const LatLng(12.9716, 77.5946);

    return Scaffold(
      body: zonesProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(target: initialTarget, zoom: 11),
              polygons: _buildPolygons(zones),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onMapCreated: (controller) => _controller = controller,
            ),
    );
  }
}