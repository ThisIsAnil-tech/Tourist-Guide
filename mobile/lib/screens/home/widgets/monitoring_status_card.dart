import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../providers/monitoring_provider.dart';
import '../../../widgets/glass/glass_card.dart';
import '../../../widgets/indicators/pulse_indicator.dart';

class MonitoringStatusCard extends StatelessWidget {
  const MonitoringStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    final monitoring = context.watch<MonitoringProvider>();

    return GlassCard(
      child: Row(
        children: [
          PulseIndicator(isActive: monitoring.isActive),
          const SizedBox(width: AppSizes.paddingSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  monitoring.isActive ? 'Monitoring active' : 'Monitoring paused',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  'Audio and location detection running in the background',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}