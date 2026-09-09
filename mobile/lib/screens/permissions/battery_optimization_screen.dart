import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/router/app_router.dart';
import '../../core/utils/permission_helper.dart';
import '../../widgets/buttons/primary_button.dart';

class BatteryOptimizationScreen extends StatefulWidget {
  const BatteryOptimizationScreen({super.key});

  @override
  State<BatteryOptimizationScreen> createState() => _BatteryOptimizationScreenState();
}

class _BatteryOptimizationScreenState extends State<BatteryOptimizationScreen> {
  bool _isRequesting = false;

  Future<void> _handleAllow() async {
    setState(() => _isRequesting = true);
    await PermissionHelper.requestDisableBatteryOptimization();
    if (mounted) context.go(AppRoutes.main);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.gradientLightStart, AppColors.gradientLightEnd],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.paddingLg),
            child: Column(
              children: [
                const Spacer(),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.battery_charging_full, size: 56, color: AppColors.primary),
                ),
                const SizedBox(height: AppSizes.paddingXl),
                Text('Keep Monitoring Active', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: AppSizes.paddingMd),
                Text(
                  'Disable battery optimization for this app so detection keeps running in the background.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Spacer(),
                PrimaryButton(
                  label: 'Allow',
                  isLoading: _isRequesting,
                  onPressed: _handleAllow,
                ),
                const SizedBox(height: AppSizes.paddingSm),
                TextButton(
                  onPressed: () => context.go(AppRoutes.main),
                  child: const Text('Not Now'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}