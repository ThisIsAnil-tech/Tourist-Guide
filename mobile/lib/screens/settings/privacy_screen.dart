import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../providers/auth_provider.dart';
import '../../services/api/users_api.dart';
import '../../widgets/glass/glass_card.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'This permanently removes your personal data. This cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await UsersApi.instance.deleteAccount();
      await context.read<AuthProvider>().logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy & Data')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingMd),
          child: Column(
            children: [
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('How Your Identity Is Protected', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: AppSizes.paddingSm),
                    Text(
                      'Your name, phone, and medical details stay locked by default. They are only unlocked for a verified emergency responder during an active SOS event you triggered, and are locked again as soon as it is resolved.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.paddingMd),
              GlassCard(
                onTap: () => _confirmDelete(context),
                child: const Row(
                  children: [
                    Icon(Icons.delete_outline, color: AppColors.danger),
                    SizedBox(width: AppSizes.paddingSm),
                    Text('Delete My Account', style: TextStyle(color: AppColors.danger)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}