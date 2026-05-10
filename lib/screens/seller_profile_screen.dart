import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:little_invoice/core/theme/app_colors.dart';
import 'package:little_invoice/core/theme/app_text_styles.dart';
import 'package:little_invoice/core/theme/app_theme.dart';
import 'package:little_invoice/models/seller_profile.dart';
import 'package:little_invoice/providers/seller_provider.dart';
import 'package:little_invoice/widgets/image_picker_widget.dart';

class SellerProfileScreen extends StatefulWidget {
  const SellerProfileScreen({super.key});

  @override
  State<SellerProfileScreen> createState() => _SellerProfileScreenState();
}

class _SellerProfileScreenState extends State<SellerProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _bankController;
  String? _logoPath;
  String? _stampPath;
  String? _signaturePath;

  @override
  void initState() {
    super.initState();
    final profile = context.read<SellerProvider>().profile;
    _nameController = TextEditingController(text: profile?.name ?? '');
    _addressController = TextEditingController(text: profile?.address ?? '');
    _phoneController = TextEditingController(text: profile?.phone ?? '');
    _emailController = TextEditingController(text: profile?.email ?? '');
    _bankController = TextEditingController(text: profile?.bank ?? '');
    _logoPath = profile?.logoPath;
    _stampPath = profile?.stampPath;
    _signaturePath = profile?.signaturePath;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _bankController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final profile = context.read<SellerProvider>().profile;
      final newProfile = SellerProfile(
        id: profile?.id,
        name: _nameController.text,
        address: _addressController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        bank: _bankController.text,
        logoPath: _logoPath,
        stampPath: _stampPath,
        signaturePath: _signaturePath,
      );
      context.read<SellerProvider>().saveProfile(newProfile).then((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile saved successfully')),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SellerProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.space16),
            children: [
              const SizedBox(height: AppTheme.space16),

              // ── Page header ──
              Text(
                'Seller Profile',
                style: AppTextStyles.h1.copyWith(color: AppColors.primary),
              ),
              const SizedBox(height: AppTheme.space4),
              Text(
                'Manage your business identity and financial details for professional invoicing.',
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppTheme.space24),

              // ── Business Assets Section (matching DESIGN) ──
              Container(
                padding: const EdgeInsets.all(AppTheme.space16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.branding_watermark_outlined,
                          size: 18,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: AppTheme.space8),
                        Text(
                          'BUSINESS ASSETS',
                          style: AppTextStyles.labelBold.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.space16),
                    Row(
                      children: [
                        Expanded(
                          child: ImagePickerWidget(
                            label: 'Logo',
                            currentPath: _logoPath,
                            onImageSelected: (path) {
                              setState(() => _logoPath = path);
                            },
                          ),
                        ),
                        const SizedBox(width: AppTheme.space12),
                        Expanded(
                          child: ImagePickerWidget(
                            label: 'Stamp',
                            currentPath: _stampPath,
                            onImageSelected: (path) {
                              setState(() => _stampPath = path);
                            },
                          ),
                        ),
                        const SizedBox(width: AppTheme.space12),
                        Expanded(
                          child: ImagePickerWidget(
                            label: 'Signature',
                            currentPath: _signaturePath,
                            onImageSelected: (path) {
                              setState(() => _signaturePath = path);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppTheme.space16),

              // ── General Information (matching DESIGN) ──
              Container(
                padding: const EdgeInsets.all(AppTheme.space24),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                  border: Border.all(color: AppColors.surfaceContainer),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'General Information',
                      style: AppTextStyles.h2.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppTheme.space16),

                    const _FieldLabel('BUSINESS NAME'),
                    const SizedBox(height: AppTheme.space4),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your business name',
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: AppTheme.space16),

                    const _FieldLabel('BUSINESS ADDRESS'),
                    const SizedBox(height: AppTheme.space4),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your business address',
                      ),
                      maxLines: 2,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: AppTheme.space16),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _FieldLabel('EMAIL ADDRESS'),
                              const SizedBox(height: AppTheme.space4),
                              TextFormField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  hintText: 'Email',
                                ),
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppTheme.space12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _FieldLabel('PHONE NUMBER'),
                              const SizedBox(height: AppTheme.space4),
                              TextFormField(
                                controller: _phoneController,
                                decoration: const InputDecoration(
                                  hintText: 'Phone',
                                ),
                                keyboardType: TextInputType.phone,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppTheme.space16),

              // ── Bank Information (matching DESIGN) ──
              Container(
                padding: const EdgeInsets.all(AppTheme.space24),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                  border: Border.all(color: AppColors.surfaceContainer),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: AppColors.tertiaryFixed,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.account_balance,
                            size: 20,
                            color: AppColors.onTertiaryFixed,
                          ),
                        ),
                        const SizedBox(width: AppTheme.space12),
                        Text(
                          'Bank Information',
                          style: AppTextStyles.h2.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.space16),

                    const _FieldLabel('BANK ACCOUNT'),
                    const SizedBox(height: AppTheme.space4),
                    TextFormField(
                      controller: _bankController,
                      decoration: const InputDecoration(
                        hintText: 'Bank name and account number',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppTheme.space24),

              // ── Action Buttons (matching DESIGN) ──
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: _save,
                        icon: const Icon(Icons.save_outlined, size: 20),
                        label: const Text('SAVE PROFILE'),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppTheme.space100),
            ],
          ),
        );
      },
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.labelBold.copyWith(
        color: AppColors.onSurfaceVariant,
      ),
    );
  }
}
