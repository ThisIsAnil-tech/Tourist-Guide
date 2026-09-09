import 'package:flutter/material.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../models/zone_model.dart';
import '../../../widgets/glass/glass_bottom_sheet.dart';

class ZoneDetailSheet extends StatelessWidget {
  final ZoneModel zone;

  const ZoneDetailSheet({super.key, required this.zone});

  @override
  Widget build(BuildContext context) {
    return GlassBottomSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(zone.name, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSizes.paddingSm),
          Row(
            children: [
              Text('Risk Score: ', style: Theme.of(context).textTheme.bodyMedium),
              Text(
                zone.riskScore.toStringAsFixed(1),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingSm),
          Text(
            'Last updated: ${zone.lastUpdated.toLocal()}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (zone.newsSummary != null) ...[
            const SizedBox(height: AppSizes.paddingMd),
            Text(zone.newsSummary!, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ],
      ),
    );
  }
}