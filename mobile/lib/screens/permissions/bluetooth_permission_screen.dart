import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform;
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/router/app_router.dart';
import '../../core/utils/permission_helper.dart';
import '../../widgets/buttons/primary_button.dart';

class BluetoothPermissionScreen extends StatefulWidget {
  const BluetoothPermissionScreen({super.key});

  @override
  State<BluetoothPermissionScreen> createState() => _BluetoothPermissionScreenState();
}

class _BluetoothPermissionScreenState extends State<BluetoothPermissionScreen> {
  bool _isRequesting = false;

  Future<void> _handleAllow() async {
    setState(() => _isRequesting = true);
    await PermissionHelper.requestBluetooth();
    if (!mounted) return;

    if (defaultTargetPlatform == TargetPlatform.android) {
      context.go(AppRoutes.batteryOptimization);
    } else {
      context.go(AppRoutes.main);
    }
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
                  child: const Icon(Icons.bluetooth, size: 56, color: AppColors.primary),
                ),
                const SizedBox(height: AppSizes.paddingXl),
                Text('Nearby Device Access', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: AppSizes.paddingMd),
                Text(
                  'This lets your phone relay an alert through nearby devices when you have no signal.',
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
                  onPressed: () {
                    if (defaultTargetPlatform == TargetPlatform.android) {
                      context.go(AppRoutes.batteryOptimization);
                    } else {
                      context.go(AppRoutes.main);
                    }
                  },
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