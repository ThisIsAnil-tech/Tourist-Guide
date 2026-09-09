import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/app_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/utils/validators.dart';
import '../../models/emergency_contact_model.dart';
import '../../services/api/users_api.dart';
import '../../widgets/glass/glass_container.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/inputs/app_text_field.dart';

class EmergencyContactsSetupScreen extends StatefulWidget {
  const EmergencyContactsSetupScreen({super.key});

  @override
  State<EmergencyContactsSetupScreen> createState() =>
      _EmergencyContactsSetupScreenState();
}

class _EmergencyContactsSetupScreenState
    extends State<EmergencyContactsSetupScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final List<EmergencyContactModel> _contacts = [];
  bool _isSubmitting = false;

  void _addContact() {
    if (_nameController.text.trim().isEmpty || _phoneController.text.trim().isEmpty) return;
    setState(() {
      _contacts.add(EmergencyContactModel(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
      ));
      _nameController.clear();
      _phoneController.clear();
    });
  }

  Future<void> _handleContinue() async {
    setState(() => _isSubmitting = true);
    try {
      for (final contact in _contacts) {
        await UsersApi.instance.addEmergencyContact(contact);
      }
      if (mounted) context.go(AppRoutes.micPermission);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emergency Contacts')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.gradientLightStart, AppColors.gradientLightEnd],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.paddingLg),
            child: Column(
              children: [
                Text(
                  'Add at least one person we can notify if you need help.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSizes.paddingLg),
                GlassContainer(
                  padding: const EdgeInsets.all(AppSizes.paddingMd),
                  child: Column(
                    children: [
                      AppTextField(label: 'Name', controller: _nameController),
                      const SizedBox(height: AppSizes.paddingSm),
                      AppTextField(
                        label: 'Phone Number',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: AppSizes.paddingSm),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: _addContact,
                          child: const Text('Add Contact'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.paddingMd),
                Expanded(
                  child: ListView.separated(
                    itemCount: _contacts.length,
                    separatorBuilder: (_, __) => const SizedBox(height: AppSizes.paddingSm),
                    itemBuilder: (context, index) {
                      final contact = _contacts[index];
                      return GlassContainer(
                        padding: const EdgeInsets.all(AppSizes.paddingMd),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(contact.name, style: Theme.of(context).textTheme.titleMedium),
                                  Text(contact.phone, style: Theme.of(context).textTheme.bodyMedium),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: AppColors.danger),
                              onPressed: () => setState(() => _contacts.removeAt(index)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                PrimaryButton(
                  label: 'Continue',
                  isLoading: _isSubmitting,
                  onPressed: _contacts.isEmpty ? null : _handleContinue,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}