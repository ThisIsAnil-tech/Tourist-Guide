import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:telephony/telephony.dart';
import '../models/sos_event_model.dart';
import '../core/config/env_config.dart';
import 'api/sos_api.dart';
import 'api/zones_api.dart';
import 'mesh_service.dart';

class SosPipelineService {
  final MeshService _meshService;
  final Telephony _telephony = Telephony.instance;

  SosPipelineService({required MeshService meshService}) : _meshService = meshService;

  Future<SosEventModel> triggerFromDetector({required String eventType}) async {
    final position = await ZonesApi.instance.getCurrentPosition();
    return sendAlert(eventType: eventType, lat: position.lat, lon: position.lon, isTest: false);
  }

  Future<SosEventModel> sendAlert({
    required String eventType,
    required double lat,
    required double lon,
    bool isTest = false,
  }) async {
    final connectivity = await Connectivity().checkConnectivity();
    final hasInternet = connectivity != ConnectivityResult.none;

    if (hasInternet) {
      try {
        return await SosApi.instance.triggerSos(
          eventType: eventType,
          lat: lat,
          lon: lon,
          isTest: isTest,
        );
      } catch (_) {
        // fall through to SMS tier
      }
    }

    final smsSent = await _trySms(eventType: eventType, lat: lat, lon: lon);
    if (smsSent) {
      return SosEventModel(
        id: 'pending-sms',
        userId: '',
        eventType: eventType,
        location: SosLocation(lat: lat, lon: lon),
        deliveredVia: 'sms',
        status: 'active',
        isTest: isTest,
        originMeta: {},
        createdAt: DateTime.now(),
      );
    }

    await _meshService.relaySosPayload({
      'event_type': eventType,
      'location': {'lat': lat, 'lon': lon},
      'is_test': isTest,
    });

    return SosEventModel(
      id: 'pending-mesh',
      userId: '',
      eventType: eventType,
      location: SosLocation(lat: lat, lon: lon),
      deliveredVia: 'mesh',
      status: 'active',
      isTest: isTest,
      originMeta: {},
      createdAt: DateTime.now(),
    );
  }

  Future<bool> _trySms({
    required String eventType,
    required double lat,
    required double lon,
  }) async {
    final permissionGranted = await _telephony.requestPhoneAndSmsPermissions ?? false;
    if (!permissionGranted) return false;

    try {
      await _telephony.sendSms(
        to: '+919380945683',
        message: 'SOS lat:$lat lon:$lon type:$eventType',
      );
      return true;
    } catch (_) {
      return false;
    }
  }
}