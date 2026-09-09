import '../../models/sos_event_model.dart';
import 'api_client.dart';

class SosApi {
  static final SosApi instance = SosApi._internal();
  SosApi._internal();

  final _dio = ApiClient.instance.dio;

  Future<SosEventModel> triggerSos({
    required String eventType,
    required double lat,
    required double lon,
    bool isTest = false,
  }) async {
    final response = await _dio.post('/sos/trigger', data: {
      'event_type': eventType,
      'location': {'lat': lat, 'lon': lon},
      'is_test': isTest,
    });
    return SosEventModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<SosEventModel> getEvent(String eventId) async {
    final response = await _dio.get('/sos/$eventId');
    return SosEventModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<SosEventModel> resolveEvent(String eventId) async {
    final response = await _dio.put('/sos/$eventId/resolve');
    return SosEventModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<SosEventModel>> getMyEvents() async {
    final response = await _dio.get('/sos/my-events');
    return (response.data as List<dynamic>)
        .map((e) => SosEventModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}