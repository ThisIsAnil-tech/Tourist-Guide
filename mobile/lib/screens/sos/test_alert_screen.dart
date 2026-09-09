import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../widgets/buttons/primary_button.dart';
import 'sos_confirmation_sheet.dart';

class TestAlertScreen extends StatelessWidget {
  const TestAlertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Alert')),
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
                const Icon(Icons.science_outlined, size: 72, color: AppColors.primary),
                const SizedBox(height: AppSizes.paddingLg),
                Text('Try a Test Alert', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: AppSizes.paddingMd),
                Text(
                  'This runs the full alert pipeline exactly like a real emergency, but it is marked as a test. Your emergency contacts and responders will not be notified.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Spacer(),
                PrimaryButton(
                  label: 'Start Test Alert',
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const SosConfirmationSheet(
                        eventType: 'MANUAL',
                        isTest: true,
                      ),
                    );
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