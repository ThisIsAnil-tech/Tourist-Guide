import 'dart:async';
import 'package:nearby_connections/nearby_connections.dart';
import '../models/nearby_device_model.dart';
import '../core/config/env_config.dart';
import 'api/sos_api.dart';

class MeshService {
  static const _serviceId = 'com.touristsafety.mesh';
  static const _strategy = Strategy.P2P_CLUSTER;

  final Nearby _nearby = Nearby();
  final _updatesController = StreamController<NearbyDeviceModel>.broadcast();

  Stream<NearbyDeviceModel> get deviceUpdates => _updatesController.stream;

  final Map<String, NearbyDeviceModel> _knownDevices = {};

  Future<void> startDiscovery() async {
    await _nearby.startAdvertising(
      'tourist-device',
      _strategy,
      onConnectionInitiated: _onConnectionInitiated,
      onConnectionResult: (id, status) {},
      onDisconnected: _onDisconnected,
      serviceId: _serviceId,
    );

    await _nearby.startDiscovery(
      'tourist-device',
      _strategy,
      onEndpointFound: (id, name, serviceId) {
        final device = NearbyDeviceModel(
          endpointId: id,
          displayName: name,
          state: DeviceConnectionState.discovered,
        );
        _knownDevices[id] = device;
        _updatesController.add(device);
        _nearby.requestConnection(
          'tourist-device',
          id,
          onConnectionInitiated: _onConnectionInitiated,
          onConnectionResult: (endpointId, status) {},
          onDisconnected: _onDisconnected,
        );
      },
      onEndpointLost: (id) {
        if (id != null && _knownDevices.containsKey(id)) {
          final updated = _knownDevices[id]!.copyWith(state: DeviceConnectionState.lost);
          _knownDevices[id] = updated;
          _updatesController.add(updated);
        }
      },
      serviceId: _serviceId,
    );
  }

  Future<void> stopDiscovery() async {
    await _nearby.stopAdvertising();
    await _nearby.stopDiscovery();
    await _nearby.stopAllEndpoints();
  }

  void _onConnectionInitiated(String id, ConnectionInfo info) {
    _nearby.acceptConnection(
      id,
      onPayLoadRecieved: (endpointId, payload) => _onPayloadReceived(endpointId, payload),
    );
  }

  void _onDisconnected(String id) {
    if (_knownDevices.containsKey(id)) {
      final updated = _knownDevices[id]!.copyWith(state: DeviceConnectionState.lost);
      _knownDevices[id] = updated;
      _updatesController.add(updated);
    }
  }

  Future<void> _onPayloadReceived(String endpointId, Payload payload) async {
    if (payload.type != PayloadType.BYTES || payload.bytes == null) return;
    await _relayOrDeliver(payload.bytes!, hopCount: 1, relayChain: [endpointId]);
  }

  Future<void> _relayOrDeliver(
    List<int> bytes, {
    required int hopCount,
    required List<String> relayChain,
  }) async {
    try {
      final json = String.fromCharCodes(bytes);
      await SosApi.instance.triggerSos(
        eventType: 'MESH_RELAY',
        lat: 0,
        lon: 0,
      );
    } catch (_) {
      // no internet here either; would continue relaying to next hop in a full implementation
    }
  }

  Future<void> relaySosPayload(Map<String, dynamic> payload) async {
    final bestNeighbor = _selectBestNeighbor();
    if (bestNeighbor == null) return;

    await _nearby.sendBytesPayload(
      bestNeighbor.endpointId,
      Uint8List.fromList(payload.toString().codeUnits),
    );
  }

  NearbyDeviceModel? _selectBestNeighbor() {
    final connected = _knownDevices.values
        .where((d) => d.state == DeviceConnectionState.connected)
        .toList();
    if (connected.isEmpty) return null;

    connected.sort((a, b) => a.reportedHops.compareTo(b.reportedHops));
    return connected.first;
  }

  void dispose() {
    _updatesController.close();
  }
}