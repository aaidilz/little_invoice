import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    _addressController = TextEditingController(text: widget.buyer?.address ?? '');
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
        name: _nameController.text,
        address: _addressController.text,
        phone: _phoneController.text,
        email: _emailController.text,
      );
      if (widget.buyer == null) {
        context.read<BuyerProvider>().addBuyer(buyer).then((_) {
          if (mounted) Navigator.pop(context);
        });
      } else {
        context.read<BuyerProvider>().updateBuyer(buyer).then((_) {
          if (mounted) Navigator.pop(context);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.buyer == null ? 'Add Buyer' : 'Edit Buyer'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.space16),
          children: [
            const SizedBox(height: AppTheme.space24),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Enter buyer name',
              ),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: AppTheme.space12),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
                hintText: 'Enter buyer address',
              ),
              maxLines: 2,
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: AppTheme.space12),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone',
                hintText: 'Enter phone number',
              ),
              keyboardType: TextInputType.phone,
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: AppTheme.space12),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter email address',
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: AppTheme.space100),
          ],
        ),
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
            child: const Text('Save Buyer'),
          ),
        ),
      ),
    );
  }
}
