import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:invoice_app/core/theme/app_theme.dart';
import 'package:invoice_app/models/invoice.dart';
import 'package:invoice_app/providers/invoice_provider.dart';
import 'package:invoice_app/screens/invoice_form_screen.dart';
import 'package:invoice_app/screens/invoice_detail_screen.dart';
import 'package:invoice_app/widgets/invoice_card.dart';
import 'package:invoice_app/widgets/empty_state_widget.dart';

class InvoiceListScreen extends StatefulWidget {
  final int? initialInvoiceId;

  const InvoiceListScreen({
    super.key,
    this.initialInvoiceId,
  });

  @override
  State<InvoiceListScreen> createState() => _InvoiceListScreenState();
}

class _InvoiceListScreenState extends State<InvoiceListScreen> {
  InvoiceStatus? _filterStatus;

  @override
  void initState() {
    super.initState();
    if (widget.initialInvoiceId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => InvoiceDetailScreen(
              invoiceId: widget.initialInvoiceId!,
            ),
          ),
        );
      });
    }
  }

  List<Invoice> _getFilteredInvoices(List<Invoice> invoices) {
    if (_filterStatus == null) {
      return invoices;
    }
    return invoices.where((i) => i.status == _filterStatus).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoices'),
      ),
      body: Consumer<InvoiceProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.invoices.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final filteredInvoices = _getFilteredInvoices(provider.invoices);

          return Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.space16,
                  vertical: AppTheme.space12,
                ),
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'All',
                      isSelected: _filterStatus == null,
                      onTap: () {
                        setState(() {
                          _filterStatus = null;
                        });
                      },
                    ),
                    const SizedBox(width: AppTheme.space8),
                    _FilterChip(
                      label: 'Unpaid',
                      isSelected: _filterStatus == InvoiceStatus.unpaid,
                      onTap: () {
                        setState(() {
                          _filterStatus = InvoiceStatus.unpaid;
                        });
                      },
                    ),
                    const SizedBox(width: AppTheme.space8),
                    _FilterChip(
                      label: 'Paid',
                      isSelected: _filterStatus == InvoiceStatus.paid,
                      onTap: () {
                        setState(() {
                          _filterStatus = InvoiceStatus.paid;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: filteredInvoices.isEmpty
                    ? EmptyStateWidget(
                        icon: Icons.receipt_long_outlined,
                        headline: 'No invoices',
                        body: _filterStatus == null
                            ? 'Create your first invoice'
                            : 'No ${_filterStatus!.name} invoices',
                        ctaLabel: 'Create Invoice',
                        onCta: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const InvoiceFormScreen(),
                            ),
                          );
                        },
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.space16,
                          vertical: AppTheme.space12,
                        ),
                        itemCount: filteredInvoices.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppTheme.space12),
                        itemBuilder: (ctx, idx) {
                          final invoice = filteredInvoices[idx];
                          return InvoiceCard(
                            invoice: invoice,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => InvoiceDetailScreen(
                                    invoiceId: invoice.id!,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const InvoiceFormScreen()),
          );
        },
        label: const Text('New Invoice'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: Theme.of(context).colorScheme.primary,
      labelStyle: TextStyle(
        color: isSelected
            ? Theme.of(context).colorScheme.onPrimary
            : Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
