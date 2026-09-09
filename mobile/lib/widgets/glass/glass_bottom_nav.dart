import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import 'glass_container.dart';

class GlassBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onSosPressed;

  const GlassBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    required this.onSosPressed,
  });

  static const _icons = [
    Icons.home_outlined,
    Icons.map_outlined,
    Icons.person_outline,
    Icons.settings_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.navBarHeight,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          GlassContainer(
            borderRadius: 32,
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMd),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _navIcon(context, 0),
                _navIcon(context, 1),
                const SizedBox(width: AppSizes.sosButtonSize - 20),
                _navIcon(context, 2),
                _navIcon(context, 3),
              ],
            ),
          ),
          Positioned(
            top: -28,
            child: GestureDetector(
              onTap: onSosPressed,
              child: Container(
                width: AppSizes.sosButtonSize,
                height: AppSizes.sosButtonSize,
                decoration: BoxDecoration(
                  color: AppColors.danger,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.danger.withOpacity(0.4),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: const Icon(Icons.warning_rounded, color: Colors.white, size: 36),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navIcon(BuildContext context, int index) {
    final isActive = currentIndex == index;
    return GestureDetector(
      onTap: () => onTabSelected(index),
      child: Icon(
        _icons[index],
        size: AppSizes.iconSize,
        color: isActive ? AppColors.primary : AppColors.lightTextMuted,
      ),
    );
  }
}