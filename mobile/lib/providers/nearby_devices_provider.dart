import 'package:flutter/foundation.dart';
import '../models/nearby_device_model.dart';
import '../services/mesh_service.dart';

class NearbyDevicesProvider extends ChangeNotifier {
  final MeshService _meshService;

  NearbyDevicesProvider({required MeshService meshService}) : _meshService = meshService {
    _meshService.deviceUpdates.listen(_onDeviceUpdate);
  }

  final Map<String, NearbyDeviceModel> _devices = {};
  bool _isScanning = false;

  List<NearbyDeviceModel> get devices => _devices.values.toList();
  int get availableCount => _devices.values
      .where((d) => d.state == DeviceConnectionState.discovered ||
          d.state == DeviceConnectionState.connected)
      .length;
  bool get isScanning => _isScanning;

  Future<void> startScanning() async {
    _isScanning = true;
    notifyListeners();
    await _meshService.startDiscovery();
  }

  Future<void> stopScanning() async {
    await _meshService.stopDiscovery();
    _isScanning = false;
    notifyListeners();
  }

  void _onDeviceUpdate(NearbyDeviceModel device) {
    _devices[device.endpointId] = device;
    notifyListeners();
  }

  @override
  void dispose() {
    _meshService.stopDiscovery();
    super.dispose();
  }
}