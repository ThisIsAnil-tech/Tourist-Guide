import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/router/app_router.dart';
import '../../core/utils/permission_helper.dart';
import '../../widgets/buttons/primary_button.dart';

class LocationPermissionScreen extends StatefulWidget {
  const LocationPermissionScreen({super.key});

  @override
  State<LocationPermissionScreen> createState() => _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends State<LocationPermissionScreen> {
  bool _isRequesting = false;

  Future<void> _handleAllow() async {
    setState(() => _isRequesting = true);
    await PermissionHelper.requestLocationAlways();
    if (mounted) context.go(AppRoutes.bluetoothPermission);
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
                  child: const Icon(Icons.location_on_outlined, size: 56, color: AppColors.primary),
                ),
                const SizedBox(height: AppSizes.paddingXl),
                Text('Location Access', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: AppSizes.paddingMd),
                Text(
                  'We need your location, even in the background, to detect if you have stopped moving in a high-risk area and to send it with an alert.',
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
                  onPressed: () => context.go(AppRoutes.bluetoothPermission),
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