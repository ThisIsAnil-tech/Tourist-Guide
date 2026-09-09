import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_sizes.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/glass/glass_card.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingMd),
          child: GlassCard(
            child: SwitchListTile(
              title: const Text('Push Notifications'),
              subtitle: const Text('Alerts about zone risk changes and account activity'),
              value: settings.notificationsEnabled,
              onChanged: (value) {
                context.read<SettingsProvider>().setNotificationsEnabled(value);
              },
            ),
          ),
        ),
      ),
    );
  }
}