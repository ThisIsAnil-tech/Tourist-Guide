import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_sizes.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/glass/glass_card.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  static const _languages = {'en': 'English', 'es': 'Español'};

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Language')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingMd),
          child: Column(
            children: _languages.entries.map((entry) {
              final isSelected = settings.languageCode == entry.key;
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.paddingSm),
                child: GlassCard(
                  onTap: () => context.read<SettingsProvider>().setLanguageCode(entry.key),
                  child: Row(
                    children: [
                      Expanded(child: Text(entry.value)),
                      if (isSelected) const Icon(Icons.check, color: Colors.teal),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}