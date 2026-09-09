import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_sizes.dart';
import '../../providers/zones_provider.dart';
import '../../widgets/glass/glass_card.dart';
import '../../widgets/buttons/primary_button.dart';

class OfflineDataScreen extends StatelessWidget {
  const OfflineDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final zonesProvider = context.watch<ZonesProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Offline Data')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingMd),
          child: GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Zone risk scores are cached locally so detection sensitivity keeps working offline.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSizes.paddingMd),
                Text(
                  zonesProvider.lastSyncedAt != null
                      ? 'Last synced: ${zonesProvider.lastSyncedAt!.toLocal()}'
                      : 'Never synced',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSizes.paddingSm),
                Text('${zonesProvider.zones.length} zones cached'),
                const SizedBox(height: AppSizes.paddingLg),
                PrimaryButton(
                  label: 'Sync Now',
                  isLoading: zonesProvider.isLoading,
                  onPressed: () => context.read<ZonesProvider>().loadZones(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}