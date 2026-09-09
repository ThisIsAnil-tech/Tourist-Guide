import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/utils/permission_helper.dart';
import '../../widgets/glass/glass_card.dart';
import '../../widgets/common/loading_view.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  Map<Permission, PermissionStatus>? _statuses;

  @override
  void initState() {
    super.initState();
    _loadStatuses();
  }

  Future<void> _loadStatuses() async {
    final statuses = await PermissionHelper.checkAllStatuses();
    if (mounted) setState(() => _statuses = statuses);
  }

  String _label(Permission permission) {
    if (permission == Permission.microphone) return 'Microphone';
    if (permission == Permission.locationAlways) return 'Location';
    if (permission == Permission.bluetoothScan) return 'Nearby Devices';
    return permission.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Permissions')),
      body: SafeArea(
        child: _statuses == null
            ? const LoadingView()
            : Padding(
                padding: const EdgeInsets.all(AppSizes.paddingMd),
                child: Column(
                  children: _statuses!.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSizes.paddingSm),
                      child: GlassCard(
                        onTap: openAppSettings,
                        child: Row(
                          children: [
                            Icon(
                              entry.value.isGranted ? Icons.check_circle : Icons.error_outline,
                              color: entry.value.isGranted ? Colors.green : Colors.orange,
                            ),
                            const SizedBox(width: AppSizes.paddingSm),
                            Expanded(child: Text(_label(entry.key))),
                            Text(entry.value.isGranted ? 'Granted' : 'Not Granted'),
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