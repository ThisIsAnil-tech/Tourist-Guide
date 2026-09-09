import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../models/emergency_contact_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/api/users_api.dart';
import '../../widgets/glass/glass_card.dart';
import '../../widgets/inputs/app_text_field.dart';

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({super.key});

  @override
  State<EmergencyContactsScreen> createState() => _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isAdding = false;

  Future<void> _handleAdd() async {
    if (_nameController.text.trim().isEmpty || _phoneController.text.trim().isEmpty) return;
    setState(() => _isAdding = true);

    try {
      await UsersApi.instance.addEmergencyContact(
        EmergencyContactModel(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
        ),
      );
      await context.read<AuthProvider>().refreshUser();
      _nameController.clear();
      _phoneController.clear();
    } finally {
      if (mounted) setState(() => _isAdding = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final contacts = context.watch<AuthProvider>().user?.emergencyContacts ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Emergency Contacts')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingMd),
          child: Column(
            children: [
              GlassCard(
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
                        onPressed: _isAdding ? null : _handleAdd,
                        child: Text(_isAdding ? 'Adding...' : 'Add Contact'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.paddingMd),
              Expanded(
                child: ListView.separated(
                  itemCount: contacts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSizes.paddingSm),
                  itemBuilder: (context, index) {
                    final contact = contacts[index];
                    return GlassCard(
                      child: Row(
                        children: [
                          const Icon(Icons.person_outline, color: AppColors.primary),
                          const SizedBox(width: AppSizes.paddingSm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(contact.name, style: Theme.of(context).textTheme.titleMedium),
                                Text(contact.phone, style: Theme.of(context).textTheme.bodyMedium),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}