import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:little_invoice/core/theme/app_colors.dart';
import 'package:little_invoice/core/theme/app_text_styles.dart';
import 'package:little_invoice/core/theme/app_theme.dart';
import 'package:little_invoice/models/invoice.dart';
import 'package:little_invoice/providers/invoice_provider.dart';
import 'package:little_invoice/screens/invoice_form_screen.dart';
import 'package:little_invoice/screens/invoice_detail_screen.dart';
import 'package:little_invoice/widgets/invoice_card.dart';
import 'package:little_invoice/widgets/empty_state_widget.dart';

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
    return Consumer<InvoiceProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.invoices.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final filteredInvoices = _getFilteredInvoices(provider.invoices);

        return Column(
          children: [
            // ── Filter chips (matching DESIGN segmented control) ──
            Container(
              margin: const EdgeInsets.all(AppTheme.space16),
              padding: const EdgeInsets.all(AppTheme.space4),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                border: Border.all(color: AppColors.outlineVariant),
              ),
              child: Row(
                children: [
                  _FilterTab(
                    label: 'All',
                    isSelected: _filterStatus == null,
                    onTap: () => setState(() => _filterStatus = null),
                  ),
                  _FilterTab(
                    label: 'Unpaid',
                    isSelected: _filterStatus == InvoiceStatus.unpaid,
                    onTap: () => setState(
                      () => _filterStatus = InvoiceStatus.unpaid,
                    ),
                  ),
                  _FilterTab(
                    label: 'Paid',
                    isSelected: _filterStatus == InvoiceStatus.paid,
                    onTap: () => setState(
                      () => _filterStatus = InvoiceStatus.paid,
                    ),
                  ),
                ],
              ),
            ),

            // ── List ──
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
                        vertical: AppTheme.space8,
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
    );
  }
}

/// Segmented filter tab matching DESIGN's template selector.
class _FilterTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.surfaceContainerLowest
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            boxShadow: isSelected
                ? [
                    const BoxShadow(
                      color: AppColors.customShadow,
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    ),
                  ]
                : null,
            border: isSelected
                ? Border.all(color: AppColors.outlineVariant)
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.labelBold.copyWith(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
