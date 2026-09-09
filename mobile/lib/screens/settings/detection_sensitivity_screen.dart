import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_sizes.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/glass/glass_card.dart';

class DetectionSensitivityScreen extends StatelessWidget {
  const DetectionSensitivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Detection Sensitivity')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingMd),
          child: GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sensitivity auto-adjusts higher in zones marked as high risk.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSizes.paddingLg),
                Text('Current: ${(settings.detectionSensitivity * 100).round()}%'),
                Slider(
                  value: settings.detectionSensitivity,
                  min: 0.5,
                  max: 0.95,
                  divisions: 9,
                  onChanged: (value) {
                    context.read<SettingsProvider>().setDetectionSensitivity(value);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}