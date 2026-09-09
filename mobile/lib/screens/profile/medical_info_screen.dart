import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_sizes.dart';
import '../../providers/auth_provider.dart';
import '../../services/api/users_api.dart';
import '../../widgets/glass/glass_card.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/inputs/app_text_field.dart';

class MedicalInfoScreen extends StatefulWidget {
  const MedicalInfoScreen({super.key});

  @override
  State<MedicalInfoScreen> createState() => _MedicalInfoScreenState();
}

class _MedicalInfoScreenState extends State<MedicalInfoScreen> {
  final _bloodGroupController = TextEditingController();
  final _conditionsController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final medicalInfo = context.read<AuthProvider>().user?.medicalInfo;
    _bloodGroupController.text = medicalInfo?.bloodGroup ?? '';
    _conditionsController.text = medicalInfo?.conditions.join(', ') ?? '';
  }

  Future<void> _handleSave() async {
    setState(() => _isSaving = true);
    try {
      await UsersApi.instance.updateMedicalInfo(
        bloodGroup: _bloodGroupController.text.trim(),
        conditions: _conditionsController.text
            .split(',')
            .map((c) => c.trim())
            .where((c) => c.isNotEmpty)
            .toList(),
      );
      await context.read<AuthProvider>().refreshUser();
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Medical Information')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingMd),
          child: GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'This is only shared with a verified responder during an active alert.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSizes.paddingMd),
                AppTextField(label: 'Blood Group', controller: _bloodGroupController),
                const SizedBox(height: AppSizes.paddingMd),
                AppTextField(
                  label: 'Conditions or Allergies (comma separated)',
                  controller: _conditionsController,
                  maxLines: 3,
                ),
                const SizedBox(height: AppSizes.paddingLg),
                PrimaryButton(
                  label: 'Save',
                  isLoading: _isSaving,
                  onPressed: _handleSave,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}