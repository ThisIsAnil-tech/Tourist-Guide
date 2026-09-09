import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/auth_provider.dart';
import 'providers/sos_provider.dart';
import 'providers/zones_provider.dart';
import 'providers/nearby_devices_provider.dart';
import 'providers/monitoring_provider.dart';
import 'providers/settings_provider.dart';
import 'services/api/auth_api.dart';
import 'services/api/sos_api.dart';
import 'services/api/zones_api.dart';
import 'services/secure_storage_service.dart';
import 'services/risk_cache_service.dart';
import 'services/mesh_service.dart';
import 'services/sos_pipeline_service.dart';
import 'services/audio_classification_service.dart';
import 'services/gps_anomaly_service.dart';
import 'services/background_service.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.instance.init();

  final meshService = MeshService();
  final sosPipelineService = SosPipelineService(meshService: meshService);
  final audioClassificationService = AudioClassificationService(pipeline: sosPipelineService);
  final gpsAnomalyService = GpsAnomalyService(pipeline: sosPipelineService);
  final backgroundService = BackgroundService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            authApi: AuthApi.instance,
            storage: SecureStorageService.instance,
          )..restoreSession(),
        ),
        ChangeNotifierProvider(
          create: (_) => SosProvider(
            pipeline: sosPipelineService,
            sosApi: SosApi.instance,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ZonesProvider(
            zonesApi: ZonesApi.instance,
            riskCache: RiskCacheService(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => NearbyDevicesProvider(meshService: meshService),
        ),
        ChangeNotifierProvider(
          create: (_) => MonitoringProvider(
            audioService: audioClassificationService,
            gpsService: gpsAnomalyService,
            backgroundService: backgroundService,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(
            storage: SecureStorageService.instance,
          )..loadSettings(),
        ),
      ],
      child: const TouristSafetyApp(),
    ),
  );
}