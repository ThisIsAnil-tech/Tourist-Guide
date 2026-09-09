import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/router/app_router.dart';
import '../../providers/sos_provider.dart';
import '../../models/sos_event_model.dart';
import '../../widgets/glass/glass_card.dart';

class SosActiveScreen extends StatelessWidget {
  final String? eventId;

  const SosActiveScreen({super.key, this.eventId});

  String _tierLabel(String tier) {
    switch (tier) {
      case 'internet':
        return 'Alert sent via Internet';
      case 'sms':
        return 'Alert sent via SMS';
      case 'mesh':
        return 'Relaying via nearby devices';
      default:
        return 'Sending alert...';
    }
  }

  @override
  Widget build(BuildContext context) {
    final sosProvider = context.watch<SosProvider>();
    final SosEventModel? event = sosProvider.activeEvent;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.dangerDark, AppColors.danger],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.paddingLg),
            child: Column(
              children: [
                const SizedBox(height: AppSizes.paddingXl),
                const Icon(Icons.warning_amber_rounded, size: 72, color: Colors.white),
                const SizedBox(height: AppSizes.paddingMd),
                Text(
                  event?.isTest == true ? 'Test Alert Active' : 'SOS Active',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: AppSizes.paddingSm),
                Text(
                  event != null ? _tierLabel(event.deliveredVia) : 'Sending alert...',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: AppSizes.paddingLg),
                GlassCard(
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline, color: AppColors.primary),
                      const SizedBox(width: AppSizes.paddingSm),
                      const Expanded(child: Text('Evidence attached')),
                    ],
                  ),
                ),
                if (event != null && event.relayChain.isNotEmpty) ...[
                  const SizedBox(height: AppSizes.paddingMd),
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Mesh Relay', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: AppSizes.paddingXs),
                        Text('Hops: ${event.hopCount}'),
                        ...event.relayChain.map((id) => Text('• $id')),
                      ],
                    ),
                  ),
                ],
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.danger,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusButton),
                      ),
                    ),
                    onPressed: () async {
                      await context.read<SosProvider>().resolveActiveEvent();
                      if (context.mounted) context.go(AppRoutes.main);
                    },
                    child: const Text("I'm Safe — Cancel"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}