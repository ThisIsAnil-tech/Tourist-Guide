import 'package:geolocator/geolocator.dart';
import '../../models/zone_model.dart';
import 'api_client.dart';

class SimplePosition {
  final double lat;
  final double lon;

  SimplePosition({required this.lat, required this.lon});
}

class ZonesApi {
  static final ZonesApi instance = ZonesApi._internal();
  ZonesApi._internal();

  final _dio = ApiClient.instance.dio;

  Future<List<ZoneModel>> getAllZones() async {
    final response = await _dio.get('/zones');
    return (response.data as List<dynamic>)
        .map((e) => ZoneModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ZoneModel> getZone(String zoneId) async {
    final response = await _dio.get('/zones/$zoneId');
    return ZoneModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<SimplePosition> getCurrentPosition() async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return SimplePosition(lat: position.latitude, lon: position.longitude);
  }
}