import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../providers/nearby_devices_provider.dart';
import '../../../widgets/glass/glass_card.dart';

class NearbyDevicesCard extends StatelessWidget {
  const NearbyDevicesCard({super.key});

  @override
  Widget build(BuildContext context) {
    final nearby = context.watch<NearbyDevicesProvider>();

    return GlassCard(
      child: Row(
        children: [
          const Icon(Icons.bluetooth, color: AppColors.primary),
          const SizedBox(width: AppSizes.paddingSm),
          Expanded(
            child: Text(
              '${nearby.availableCount} nearby devices available as backup relay',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}