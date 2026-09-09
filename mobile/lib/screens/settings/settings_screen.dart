import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/router/app_router.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/glass/glass_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.paddingMd,
          AppSizes.paddingMd,
          AppSizes.paddingMd,
          140,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Settings', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: AppSizes.paddingLg),
            _SettingsTile(
              icon: Icons.tune,
              label: 'Detection Sensitivity',
              onTap: () => context.push(AppRoutes.sensitivity),
            ),
            _SettingsTile(
              icon: Icons.notifications_outlined,
              label: 'Notifications',
              onTap: () => context.push(AppRoutes.notifications),
            ),
            _SettingsTile(
              icon: Icons.security,
              label: 'Permissions',
              onTap: () => context.push(AppRoutes.permissions),
            ),
            _SettingsTile(
              icon: Icons.cloud_off_outlined,
              label: 'Offline Data',
              onTap: () => context.push(AppRoutes.offlineData),
            ),
            _SettingsTile(
              icon: Icons.privacy_tip_outlined,
              label: 'Privacy & Data',
              onTap: () => context.push(AppRoutes.privacy),
            ),
            _SettingsTile(
              icon: Icons.language,
              label: 'Language',
              onTap: () => context.push(AppRoutes.language),
            ),
            _SettingsTile(
              icon: Icons.info_outline,
              label: 'About',
              onTap: () => context.push(AppRoutes.about),
            ),
            const SizedBox(height: AppSizes.paddingMd),
            _SettingsTile(
              icon: Icons.logout,
              label: 'Log Out',
              color: AppColors.danger,
              onTap: () async {
                await context.read<AuthProvider>().logout();
                if (context.mounted) context.go(AppRoutes.login);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final tileColor = color ?? AppColors.primary;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.paddingSm),
      child: GlassCard(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, color: tileColor),
            const SizedBox(width: AppSizes.paddingSm),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: tileColor),
              ),
            ),
            if (color == null) const Icon(Icons.chevron_right, color: AppColors.lightTextMuted),
          ],
        ),
      ),
    );
  }
}