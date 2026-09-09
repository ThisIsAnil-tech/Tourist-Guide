import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

class SosButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double size;

  const SosButton({super.key, required this.onPressed, this.size = AppSizes.sosButtonSize});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.danger,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: AppColors.danger.withOpacity(0.4), blurRadius: 16, spreadRadius: 2),
          ],
        ),
        child: Icon(Icons.warning_rounded, color: Colors.white, size: size * 0.4),
      ),
    );
  }
}