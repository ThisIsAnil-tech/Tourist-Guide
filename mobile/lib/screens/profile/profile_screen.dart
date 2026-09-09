import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/router/app_router.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/glass/glass_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

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
            Text('Profile', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: AppSizes.paddingLg),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user?.name ?? '', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: AppSizes.paddingXs),
                  Text(user?.email ?? '', style: Theme.of(context).textTheme.bodyMedium),
                  Text(user?.phone ?? '', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.paddingMd),
            GlassCard(
              child: Row(
                children: [
                  Icon(
                    user?.isIdentityLocked ?? true ? Icons.lock : Icons.lock_open,
                    color: user?.isIdentityLocked ?? true ? AppColors.primary : AppColors.accent,
                  ),
                  const SizedBox(width: AppSizes.paddingSm),
                  Text(
                    user?.isIdentityLocked ?? true ? 'Identity: Locked' : 'Identity: Unlocked',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.paddingMd),
            _ProfileListTile(
              icon: Icons.contacts_outlined,
              label: 'Emergency Contacts',
              onTap: () => context.push(AppRoutes.emergencyContacts),
            ),
            _ProfileListTile(
              icon: Icons.medical_information_outlined,
              label: 'Medical Information',
              onTap: () => context.push(AppRoutes.medicalInfo),
            ),
            _ProfileListTile(
              icon: Icons.history,
              label: 'SOS History',
              onTap: () => context.push(AppRoutes.sosHistory),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileListTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ProfileListTile({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.paddingSm),
      child: GlassCard(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: AppSizes.paddingSm),
            Expanded(child: Text(label, style: Theme.of(context).textTheme.titleMedium)),
            const Icon(Icons.chevron_right, color: AppColors.lightTextMuted),
          ],
        ),
      ),
    );
  }
}