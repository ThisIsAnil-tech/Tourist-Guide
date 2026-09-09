import 'package:flutter/material.dart';
import '../../core/constants/app_sizes.dart';
import 'glass_container.dart';

class GlassBottomSheet extends StatelessWidget {
  final Widget child;

  const GlassBottomSheet({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: AppSizes.paddingMd,
        right: AppSizes.paddingMd,
        top: AppSizes.paddingMd,
      ),
      child: GlassContainer(
        borderRadius: AppSizes.radiusSheet,
        padding: const EdgeInsets.all(AppSizes.paddingLg),
        child: SafeArea(top: false, child: child),
      ),
    );
  }
}