import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  PermissionHelper._();

  static Future<bool> requestMicrophone() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  static Future<bool> requestLocationAlways() async {
    final whenInUse = await Permission.locationWhenInUse.request();
    if (!whenInUse.isGranted) return false;
    final always = await Permission.locationAlways.request();
    return always.isGranted;
  }

  static Future<bool> requestBluetooth() async {
    final scan = await Permission.bluetoothScan.request();
    final connect = await Permission.bluetoothConnect.request();
    final advertise = await Permission.bluetoothAdvertise.request();
    return scan.isGranted && connect.isGranted && advertise.isGranted;
  }

  static Future<bool> isBatteryOptimizationDisabled() async {
    final status = await Permission.ignoreBatteryOptimizations.status;
    return status.isGranted;
  }

  static Future<void> requestDisableBatteryOptimization() async {
    await Permission.ignoreBatteryOptimizations.request();
  }

  static Future<Map<Permission, PermissionStatus>> checkAllStatuses() async {
    return {
      Permission.microphone: await Permission.microphone.status,
      Permission.locationAlways: await Permission.locationAlways.status,
      Permission.bluetoothScan: await Permission.bluetoothScan.status,
    };
  }
}