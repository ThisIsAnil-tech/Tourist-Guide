import 'package:flutter/material.dart';
import '../../core/constants/app_sizes.dart';
import '../../widgets/glass/glass_card.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingMd),
          child: GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tourist Safety', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: AppSizes.paddingSm),
                const Text('Version 1.0.0'),
                const SizedBox(height: AppSizes.paddingMd),
                const Text(
                  'Smart Tourist Safety & Incident Response System — Project Phase I/II',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}