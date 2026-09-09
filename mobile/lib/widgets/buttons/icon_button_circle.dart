import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class IconButtonCircle extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;

  const IconButtonCircle({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: (color ?? AppColors.primary).withOpacity(0.12),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: color ?? AppColors.primary, size: 20),
        ),
      ),
    );
  }
}