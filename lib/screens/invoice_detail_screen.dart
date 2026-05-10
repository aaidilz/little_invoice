import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:little_invoice/core/theme/app_colors.dart';
import 'package:little_invoice/core/theme/app_text_styles.dart';
import 'package:little_invoice/core/theme/app_theme.dart';
import 'package:little_invoice/core/utils/currency_formatter.dart';
import 'package:little_invoice/core/utils/date_formatter.dart';
import 'package:little_invoice/models/invoice.dart';
import 'package:little_invoice/models/buyer.dart';
import 'package:little_invoice/providers/invoice_provider.dart';
import 'package:little_invoice/providers/seller_provider.dart';
import 'package:little_invoice/providers/buyer_provider.dart';
import 'package:little_invoice/widgets/status_badge_widget.dart';
import 'package:little_invoice/widgets/calculation_summary_widget.dart';
import 'package:little_invoice/features/pdf/pdf_generator.dart';
import 'package:little_invoice/core/services/file_service.dart';
import 'package:little_invoice/screens/pdf_preview_screen.dart';
import 'package:little_invoice/screens/invoice_form_screen.dart';

class InvoiceDetailScreen extends StatefulWidget {
  final int invoiceId;

  const InvoiceDetailScreen({
    super.key,
    required this.invoiceId,
  });

  @override
  State<InvoiceDetailScreen> createState() => _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends State<InvoiceDetailScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context
          .read<InvoiceProvider>()
          .getItemsForInvoice(widget.invoiceId);
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
  }

  Future<void> _generatePdf(Invoice invoice) async {
    final seller = context.read<SellerProvider>().profile;
    final buyers = context.read<BuyerProvider>().buyers;
    final buyer = buyers.firstWhere(
      (b) => b.id == invoice.buyerId,
      orElse: () => Buyer(id: invoice.buyerId, name: 'Unknown Client', address: '-', phone: '-', email: '-'),
    );
    final items = context.read<InvoiceProvider>().currentItems;

    if (seller == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please set up your seller profile first'),
          ),
        );
      }
      return;
    }

    final generator = PdfGenerator(FileService());
    try {
      final pdfBytes = await generator.generate(
        invoice: invoice,
        seller: seller,
        buyer: buyer,
        items: items,
        templateIndex: 0,
      );

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PdfPreviewScreen(
              pdfBytes: pdfBytes,
              invoiceNumber: invoice.invoiceNumber,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to generate PDF: $e')),
        );
      }
    }
  }

  Future<void> _deleteInvoice(Invoice invoice) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Invoice'),
        content: Text(
          'Are you sure you want to delete ${invoice.invoiceNumber}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await context.read<InvoiceProvider>().deleteInvoice(invoice.id!);
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Consumer<InvoiceProvider>(
      builder: (context, provider, child) {
        final invoice = provider.invoices.firstWhere(
          (i) => i.id == widget.invoiceId,
        );
        final items = provider.currentItems;
        final seller = context.watch<SellerProvider>().profile;
        final buyers = context.watch<BuyerProvider>().buyers;
        final buyer = buyers.firstWhere(
          (b) => b.id == invoice.buyerId,
          orElse: () => Buyer(id: invoice.buyerId, name: 'Unknown Client', address: '-', phone: '-', email: '-'),
        );

        final discountAmount = invoice.subtotal * (invoice.discount / 100);
        final afterDiscount = invoice.subtotal - discountAmount;
        final taxAmount = afterDiscount * (invoice.tax / 100);

        return Scaffold(
          appBar: AppBar(
            title: Text(invoice.invoiceNumber),
            actions: [
              // Edit button matching DESIGN
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => InvoiceFormScreen(
                        invoiceId: invoice.id,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: Text(
                  'Edit',
                  style: AppTextStyles.labelBold,
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppTheme.space16),

                // ── Status & Actions Card (matching DESIGN) ──
                Container(
                  padding: const EdgeInsets.all(AppTheme.space24),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                    border: Border.all(color: AppColors.surfaceVariant),
                    boxShadow: AppTheme.cardShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        invoice.invoiceNumber,
                        style: AppTextStyles.labelBold.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppTheme.space8),
                      Row(
                        children: [
                          StatusBadgeWidget(status: invoice.status),
                          const SizedBox(width: AppTheme.space12),
                          TextButton(
                            onPressed: () =>
                                provider.toggleStatus(invoice.id!),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Change Status',
                                  style: AppTextStyles.labelBold.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.swap_horiz,
                                  size: 16,
                                  color: AppColors.primary,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.space16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _generatePdf(invoice),
                              icon: const Icon(Icons.download, size: 18),
                              label: const Text('Export PDF'),
                            ),
                          ),
                          const SizedBox(width: AppTheme.space12),
                          SizedBox(
                            height: 56,
                            child: OutlinedButton(
                              onPressed: () => _deleteInvoice(invoice),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: AppColors.error,
                                ),
                                foregroundColor: AppColors.error,
                              ),
                              child: const Icon(Icons.delete_outline),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppTheme.space16),

                // ── Billing Details Card (matching DESIGN) ──
                Container(
                  padding: const EdgeInsets.all(AppTheme.space24),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                    border: Border.all(color: AppColors.surfaceVariant),
                    boxShadow: AppTheme.cardShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Billing Details',
                        style: AppTextStyles.h2.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: AppTheme.space4),
                      const Divider(),
                      const SizedBox(height: AppTheme.space16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _LabeledInfo(
                              label: 'FROM',
                              value: seller?.name ?? 'Not set',
                              subtitle: seller?.address,
                            ),
                          ),
                          const SizedBox(width: AppTheme.space16),
                          Expanded(
                            child: _LabeledInfo(
                              label: 'BILL TO',
                              value: buyer.name,
                              subtitle: buyer.address,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppTheme.space16),

                // ── Quick Info Card ──
                Container(
                  padding: const EdgeInsets.all(AppTheme.space24),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                    border: Border.all(color: AppColors.surfaceVariant),
                    boxShadow: AppTheme.cardShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quick Info',
                        style: AppTextStyles.h2.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: AppTheme.space4),
                      const Divider(),
                      const SizedBox(height: AppTheme.space16),
                      Row(
                        children: [
                          Expanded(
                            child: _LabeledInfo(
                              label: 'ISSUE DATE',
                              value: invoice.cityDate,
                            ),
                          ),
                          Expanded(
                            child: _LabeledInfo(
                              label: 'DUE DATE',
                              value: DateFormatter.formatShortDate(
                                invoice.dueDate,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppTheme.space16),

                // ── Items Table (matching DESIGN) ──
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                    border: Border.all(color: AppColors.surfaceVariant),
                    boxShadow: AppTheme.cardShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.all(AppTheme.space24),
                        decoration: const BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          border: Border(
                            bottom: BorderSide(
                              color: AppColors.surfaceVariant,
                            ),
                          ),
                        ),
                        child: Text(
                          'Services & Items',
                          style: AppTextStyles.h2.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),

                      // Table Header
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.space24,
                          vertical: AppTheme.space12,
                        ),
                        color: AppColors.surfaceContainerLow.withValues(alpha: 0.5),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                'DESCRIPTION',
                                style: AppTextStyles.labelBold.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 48,
                              child: Text(
                                'QTY',
                                style: AppTextStyles.labelBold.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              width: 80,
                              child: Text(
                                'PRICE',
                                style: AppTextStyles.labelBold.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            SizedBox(
                              width: 80,
                              child: Text(
                                'TOTAL',
                                style: AppTextStyles.labelBold.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Item Rows
                      ...items.map((item) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.space24,
                              vertical: AppTheme.space16,
                            ),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: AppColors.surfaceVariant,
                                  width: 0.5,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    item.description,
                                    style: AppTextStyles.bodyMd.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 48,
                                  child: Text(
                                    item.quantity.toString(),
                                    style: AppTextStyles.bodyMd,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(
                                  width: 80,
                                  child: Text(
                                    CurrencyFormatter.format(item.price),
                                    style: AppTextStyles.bodyMd,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                SizedBox(
                                  width: 80,
                                  child: Text(
                                    CurrencyFormatter.format(item.lineTotal),
                                    style: AppTextStyles.bodyMd.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),

                const SizedBox(height: AppTheme.space16),

                // ── Calculation Summary ──
                CalculationSummaryWidget(
                  subtotal: invoice.subtotal,
                  discountPercent: invoice.discount,
                  discountAmount: discountAmount,
                  taxPercent: invoice.tax,
                  taxAmount: taxAmount,
                  dpAmount: invoice.dp,
                  total: invoice.total,
                ),

                // ── Notes ──
                if (invoice.notes != null && invoice.notes!.isNotEmpty) ...[
                  const SizedBox(height: AppTheme.space16),
                  Container(
                    padding: const EdgeInsets.all(AppTheme.space24),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                      border: Border.all(color: AppColors.surfaceVariant),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'REMARKS',
                          style: AppTextStyles.labelBold.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: AppTheme.space8),
                        Text(
                          invoice.notes!,
                          style: AppTextStyles.bodyMd.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: AppTheme.space100),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Labeled info block matching DESIGN's FROM / BILL TO pattern.
class _LabeledInfo extends StatelessWidget {
  final String label;
  final String value;
  final String? subtitle;

  const _LabeledInfo({
    required this.label,
    required this.value,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelBold.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppTheme.space4),
        Text(
          value,
          style: AppTextStyles.bodyMd.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: AppTheme.space2),
          Text(
            subtitle!,
            style: AppTextStyles.bodyMd.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}
