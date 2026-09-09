import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../providers/zones_provider.dart';
import '../../../widgets/glass/glass_card.dart';

class RiskZoneBadge extends StatelessWidget {
  const RiskZoneBadge({super.key});

  Color _riskColor(String level) {
    switch (level) {
      case 'high':
        return AppColors.riskHigh;
      case 'medium':
        return AppColors.riskMedium;
      default:
        return AppColors.riskLow;
    }
  }

  String _riskLabel(String level) {
    switch (level) {
      case 'high':
        return 'High Risk Zone';
      case 'medium':
        return 'Moderate Risk Zone';
      default:
        return 'Low Risk Zone';
    }
  }

  @override
  Widget build(BuildContext context) {
    final zone = context.watch<ZonesProvider>().currentZone;
    final level = zone?.riskLevel ?? 'low';

    return GlassCard(
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: _riskColor(level), shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSizes.paddingSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_riskLabel(level), style: Theme.of(context).textTheme.titleMedium),
                if (zone != null)
                  Text(zone.name, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}