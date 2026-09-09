import 'package:flutter_background_service/flutter_background_service.dart';

class BackgroundService {
  Future<void> enable() async {
    final service = FlutterBackgroundService();
    final isRunning = await service.isRunning();
    if (!isRunning) {
      await service.startService();
    }
  }

  Future<void> disable() async {
    final service = FlutterBackgroundService();
    service.invoke('stop');
  }

  static void onStart(ServiceInstance service) {
    service.on('stop').listen((event) {
      service.stopSelf();
    });
  }
}