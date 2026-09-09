import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../widgets/glass/glass_card.dart';

class MapPreviewCard extends StatelessWidget {
  const MapPreviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => DefaultTabController.of(context)?.animateTo(1),
      child: GlassCard(
        padding: EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radiusCard),
          child: SizedBox(
            height: 160,
            width: double.infinity,
            child: Stack(
              children: [
                Container(color: Theme.of(context).colorScheme.surface),
                const Center(child: Icon(Icons.map_outlined, size: 40)),
                Positioned(
                  bottom: AppSizes.paddingSm,
                  right: AppSizes.paddingSm,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text('View Map', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}