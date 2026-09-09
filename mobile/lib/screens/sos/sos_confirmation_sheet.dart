import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/router/app_router.dart';
import '../../providers/sos_provider.dart';
import '../../services/api/zones_api.dart';
import '../../widgets/glass/glass_bottom_sheet.dart';
import '../../widgets/indicators/countdown_ring.dart';

class SosConfirmationSheet extends StatefulWidget {
  final String eventType;
  final bool isTest;

  const SosConfirmationSheet({
    super.key,
    required this.eventType,
    required this.isTest,
  });

  @override
  State<SosConfirmationSheet> createState() => _SosConfirmationSheetState();
}

class _SosConfirmationSheetState extends State<SosConfirmationSheet> {
  static const _countdownSeconds = 5;
  int _secondsLeft = _countdownSeconds;
  Timer? _timer;
  bool _isCancelled = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_isCancelled) {
        timer.cancel();
        return;
      }
      setState(() => _secondsLeft--);
      if (_secondsLeft <= 0) {
        timer.cancel();
        await _sendAlert();
      }
    });
  }

  Future<void> _sendAlert() async {
    if (!mounted) return;
    final position = await ZonesApi.instance.getCurrentPosition();

    final event = await context.read<SosProvider>().triggerSos(
          eventType: widget.eventType,
          lat: position.lat,
          lon: position.lon,
          isTest: widget.isTest,
        );

    if (!mounted) return;
    Navigator.of(context).pop();
    context.push(AppRoutes.sosActive, extra: event.id);
  }

  void _handleCancel() {
    setState(() => _isCancelled = true);
    _timer?.cancel();
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlassBottomSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.isTest ? 'Sending Test Alert' : 'Cancel Before Sending',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSizes.paddingLg),
          CountdownRing(secondsLeft: _secondsLeft, totalSeconds: _countdownSeconds),
          const SizedBox(height: AppSizes.paddingLg),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.danger,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusButton),
                ),
              ),
              onPressed: _handleCancel,
              child: const Text('Cancel'),
            ),
          ),
        ],
      ),
    );
  }
}