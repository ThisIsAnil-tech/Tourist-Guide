import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/router/app_router.dart';
import '../../providers/monitoring_provider.dart';
import '../../providers/zones_provider.dart';
import '../../providers/nearby_devices_provider.dart';
import '../../widgets/indicators/offline_banner.dart';
import 'widgets/risk_zone_badge.dart';
import 'widgets/monitoring_status_card.dart';
import 'widgets/nearby_devices_card.dart';
import 'widgets/map_preview_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ZonesProvider>().loadZones();
      context.read<MonitoringProvider>().startMonitoring();
      context.read<NearbyDevicesProvider>().startScanning();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.paddingMd,
          AppSizes.paddingMd,
          AppSizes.paddingMd,
          140,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const OfflineBanner(),
            const SizedBox(height: AppSizes.paddingMd),
            Text('Tourist Safety', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: AppSizes.paddingLg),
            const RiskZoneBadge(),
            const SizedBox(height: AppSizes.paddingMd),
            const MonitoringStatusCard(),
            const SizedBox(height: AppSizes.paddingMd),
            const NearbyDevicesCard(),
            const SizedBox(height: AppSizes.paddingMd),
            const MapPreviewCard(),
            const SizedBox(height: AppSizes.paddingMd),
            OutlinedButton.icon(
              onPressed: () => context.push(AppRoutes.testAlert),
              icon: const Icon(Icons.science_outlined),
              label: const Text('Try a Test Alert'),
            ),
          ],
        ),
      ),
    );
  }
}