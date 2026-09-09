import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class CountdownRing extends StatelessWidget {
  final int secondsLeft;
  final int totalSeconds;

  const CountdownRing({super.key, required this.secondsLeft, required this.totalSeconds});

  @override
  Widget build(BuildContext context) {
    final progress = secondsLeft / totalSeconds;

    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 120,
            height: 120,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 8,
              backgroundColor: AppColors.danger.withOpacity(0.15),
              valueColor: const AlwaysStoppedAnimation(AppColors.danger),
            ),
          ),
          Text(
            '$secondsLeft',
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.danger),
          ),
        ],
      ),
    );
  }
}