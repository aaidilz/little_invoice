import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: Consumer<SellerProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.space16),
              children: [
                const SizedBox(height: AppTheme.space24),
                Text(
                  'Business Info',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: AppTheme.space12),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Business Name',
                    hintText: 'Enter your business name',
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: AppTheme.space12),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    hintText: 'Enter your business address',
                  ),
                  maxLines: 2,
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: AppTheme.space12),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    hintText: 'Enter your phone number',
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: AppTheme.space12),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email address',
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: AppTheme.space12),
                TextFormField(
                  controller: _bankController,
                  decoration: const InputDecoration(
                    labelText: 'Bank Account',
                    hintText: 'Bank name and account number',
                  ),
                ),
                const SizedBox(height: AppTheme.space24),
                Text(
                  'Branding',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: AppTheme.space12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          ImagePickerWidget(
                            label: 'Logo',
                            currentPath: _logoPath,
                            onImageSelected: (path) {
                              setState(() => _logoPath = path);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppTheme.space12),
                    Expanded(
                      child: Column(
                        children: [
                          ImagePickerWidget(
                            label: 'Stamp',
                            currentPath: _stampPath,
                            onImageSelected: (path) {
                              setState(() => _stampPath = path);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppTheme.space12),
                    Expanded(
                      child: Column(
                        children: [
                          ImagePickerWidget(
                            label: 'Signature',
                            currentPath: _signaturePath,
                            onImageSelected: (path) {
                              setState(() => _signaturePath = path);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.space100),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppTheme.space16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _save,
            child: const Text('Save Profile'),
          ),
        ),
      ),
    );
  }
}
