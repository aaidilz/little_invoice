import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:little_invoice/core/theme/app_colors.dart';
import 'package:little_invoice/core/theme/app_text_styles.dart';
import 'package:little_invoice/core/theme/app_theme.dart';
import 'package:little_invoice/models/buyer.dart';
import 'package:little_invoice/providers/buyer_provider.dart';

class BuyerFormScreen extends StatefulWidget {
  final Buyer? buyer;

  const BuyerFormScreen({
    super.key,
    this.buyer,
  });

  @override
  State<BuyerFormScreen> createState() => _BuyerFormScreenState();
}

class _BuyerFormScreenState extends State<BuyerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.buyer?.name ?? '');
    _addressController =
        TextEditingController(text: widget.buyer?.address ?? '');
    _phoneController = TextEditingController(text: widget.buyer?.phone ?? '');
    _emailController = TextEditingController(text: widget.buyer?.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final buyer = Buyer(
        id: widget.buyer?.id,
        name: _nameController.text.trim(),
        address: _addressController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
      );
      if (widget.buyer == null) {
        context.read<BuyerProvider>().addBuyer(buyer).then((savedBuyer) {
          if (mounted) Navigator.pop(context, savedBuyer);
        });
      } else {
        context.read<BuyerProvider>().updateBuyer(buyer).then((_) {
          if (mounted) Navigator.pop(context, buyer);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.buyer != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Client' : 'New Client'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.space16),
          children: [
            const SizedBox(height: AppTheme.space24),

            // ── Form card (matching DESIGN modal) ──
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
                    'Client Details',
                    style: AppTextStyles.h2.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppTheme.space24),

                  // Full Name
                  Text(
                    'FULL NAME',
                    style: AppTextStyles.labelBold.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppTheme.space4),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: 'Enter full name',
                    ),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: AppTheme.space16),

                  // Address
                  Text(
                    'ADDRESS',
                    style: AppTextStyles.labelBold.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppTheme.space4),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      hintText: 'Enter address (optional)',
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: AppTheme.space16),

                  // Phone
                  Text(
                    'PHONE NUMBER',
                    style: AppTextStyles.labelBold.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppTheme.space4),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      hintText: 'Enter phone number (optional)',
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: AppTheme.space16),

                  // Email
                  Text(
                    'EMAIL ADDRESS',
                    style: AppTextStyles.labelBold.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppTheme.space4),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: 'Enter email address (optional)',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return null;
                      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                      if (!emailRegex.hasMatch(v.trim())) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.space100),
          ],
        ),
      ),

      // ── Bottom action bar ──
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppTheme.space16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          boxShadow: AppTheme.bottomBarShadow,
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _save,
              child: Text(isEditing ? 'Update Client' : 'Save Client'),
            ),
          ),
        ),
      ),
    );
  }
}
