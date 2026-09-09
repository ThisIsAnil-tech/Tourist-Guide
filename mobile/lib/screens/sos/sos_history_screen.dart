import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../providers/sos_provider.dart';
import '../../widgets/glass/glass_card.dart';
import '../../widgets/common/loading_view.dart';
import '../../widgets/common/empty_view.dart';

class SosHistoryScreen extends StatefulWidget {
  const SosHistoryScreen({super.key});

  @override
  State<SosHistoryScreen> createState() => _SosHistoryScreenState();
}

class _SosHistoryScreenState extends State<SosHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SosProvider>().loadHistory();
    });
  }

  Color _statusColor(String status) {
    return status == 'active' ? AppColors.danger : AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    final sosProvider = context.watch<SosProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('SOS History')),
      body: sosProvider.isLoadingHistory
          ? const LoadingView()
          : sosProvider.history.isEmpty
              ? const EmptyView(message: 'No past alerts.')
              : ListView.separated(
                  padding: const EdgeInsets.all(AppSizes.paddingMd),
                  itemCount: sosProvider.history.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSizes.paddingSm),
                  itemBuilder: (context, index) {
                    final event = sosProvider.history[index];
                    return GlassCard(
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: _statusColor(event.status),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: AppSizes.paddingSm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      event.eventType,
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                    if (event.isTest) ...[
                                      const SizedBox(width: AppSizes.paddingXs),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.accent.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(999),
                                        ),
                                        child: const Text(
                                          'TEST',
                                          style: TextStyle(fontSize: 10, color: AppColors.accent),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                Text(
                                  '${event.deliveredVia} • ${event.createdAt.toLocal()}',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}