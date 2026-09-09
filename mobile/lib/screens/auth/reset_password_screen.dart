import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/app_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/utils/validators.dart';
import '../../services/api/auth_api.dart';
import '../../widgets/glass/glass_container.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/inputs/app_text_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  bool _isSubmitting = false;
  String? _errorMessage;

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      await AuthApi.instance.resetPassword(
        token: _codeController.text.trim(),
        newPassword: _newPasswordController.text,
      );
      if (mounted) context.go(AppRoutes.login);
    } catch (e) {
      setState(() => _errorMessage = 'Invalid or expired code');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter New Password')),
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
            child: GlassContainer(
              padding: const EdgeInsets.all(AppSizes.paddingLg),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_errorMessage != null) ...[
                      Text(_errorMessage!, style: const TextStyle(color: AppColors.danger)),
                      const SizedBox(height: AppSizes.paddingSm),
                    ],
                    AppTextField(
                      label: 'Reset Code',
                      controller: _codeController,
                      validator: (v) => Validators.notEmpty(v, label: 'Reset code'),
                    ),
                    const SizedBox(height: AppSizes.paddingMd),
                    AppTextField(
                      label: 'New Password',
                      controller: _newPasswordController,
                      obscureText: true,
                      validator: Validators.password,
                    ),
                    const SizedBox(height: AppSizes.paddingLg),
                    PrimaryButton(
                      label: 'Reset Password',
                      isLoading: _isSubmitting,
                      onPressed: _handleSubmit,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}