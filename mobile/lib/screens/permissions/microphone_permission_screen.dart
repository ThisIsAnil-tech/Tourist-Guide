import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/router/app_router.dart';
import '../../core/utils/permission_helper.dart';
import '../../widgets/buttons/primary_button.dart';

class MicrophonePermissionScreen extends StatefulWidget {
  const MicrophonePermissionScreen({super.key});

  @override
  State<MicrophonePermissionScreen> createState() => _MicrophonePermissionScreenState();
}

class _MicrophonePermissionScreenState extends State<MicrophonePermissionScreen> {
  bool _isRequesting = false;

  Future<void> _handleAllow() async {
    setState(() => _isRequesting = true);
    await PermissionHelper.requestMicrophone();
    if (mounted) context.go(AppRoutes.locationPermission);
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
                  child: const Icon(Icons.mic_none, size: 56, color: AppColors.primary),
                ),
                const SizedBox(height: AppSizes.paddingXl),
                Text('Microphone Access', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: AppSizes.paddingMd),
                Text(
                  'We listen for distress sounds like screams entirely on your device. Audio is never streamed or stored unless an alert is triggered.',
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
                  onPressed: () => context.go(AppRoutes.locationPermission),
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