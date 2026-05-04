import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:invoice_app/core/theme/app_colors.dart';
import 'package:invoice_app/core/theme/app_text_styles.dart';
import 'package:invoice_app/core/theme/app_theme.dart';
import 'package:invoice_app/core/utils/currency_formatter.dart';
import 'package:invoice_app/core/utils/date_formatter.dart';
import 'package:invoice_app/models/invoice.dart';
import 'package:invoice_app/providers/invoice_provider.dart';
import 'package:invoice_app/providers/seller_provider.dart';
import 'package:invoice_app/providers/buyer_provider.dart';
import 'package:invoice_app/widgets/status_badge_widget.dart';
import 'package:invoice_app/widgets/calculation_summary_widget.dart';
import 'package:invoice_app/features/pdf/pdf_generator.dart';
import 'package:invoice_app/core/services/file_service.dart';
import 'package:invoice_app/screens/pdf_preview_screen.dart';
import 'package:invoice_app/screens/invoice_form_screen.dart';

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
      await context.read<InvoiceProvider>().getItemsForInvoice(widget.invoiceId);
      setState(() => _isLoading = false);
    });
  }

  Future<void> _generatePdf(Invoice invoice) async {
    final seller = context.read<SellerProvider>().profile;
    final buyers = context.read<BuyerProvider>().buyers;
    final buyer = buyers.firstWhere(
      (b) => b.id == invoice.buyerId,
      orElse: () => throw Exception('Buyer not found'),
    );
    final items = context.read<InvoiceProvider>().currentItems;

    if (seller == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please set up your seller profile first')),
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

  Future<void> _shareInvoice(Invoice invoice) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share functionality coming soon')),
    );
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
          orElse: () => throw Exception('Buyer not found'),
        );

        final discountAmount = invoice.subtotal * (invoice.discount / 100);
        final afterDiscount = invoice.subtotal - discountAmount;
        final taxAmount = afterDiscount * (invoice.tax / 100);

        return Scaffold(
          appBar: AppBar(
            title: Text(invoice.invoiceNumber),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
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
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _deleteInvoice(invoice),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppTheme.space24),
                _StatusBanner(
                  status: invoice.status,
                  onToggle: () => provider.toggleStatus(invoice.id!),
                ),
                const SizedBox(height: AppTheme.space24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.space16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _InfoRow(
                                label: 'Seller',
                                value: seller?.name ?? 'Not set',
                              ),
                            ),
                            Expanded(
                              child: _InfoRow(
                                label: 'Buyer',
                                value: buyer.name,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppTheme.space12),
                        Row(
                          children: [
                            Expanded(
                              child: _InfoRow(
                                label: 'Issue Date',
                                value: invoice.cityDate,
                              ),
                            ),
                            Expanded(
                              child: _InfoRow(
                                label: 'Due Date',
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
                ),
                const SizedBox(height: AppTheme.space24),
                Text(
                  'Items',
                  style: AppTextStyles.headline,
                ),
                const SizedBox(height: AppTheme.space12),
                Card(
                  child: Column(
                    children: [
                      _ItemTableHeader(),
                      ...items.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;
                        return _ItemTableRow(
                          index: index + 1,
                          item: item,
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: AppTheme.space24),
                CalculationSummaryWidget(
                  subtotal: invoice.subtotal,
                  discountPercent: invoice.discount,
                  discountAmount: discountAmount,
                  taxPercent: invoice.tax,
                  taxAmount: taxAmount,
                  dpAmount: invoice.dp,
                  total: invoice.total,
                ),
                if (invoice.notes != null && invoice.notes!.isNotEmpty) ...[
                  const SizedBox(height: AppTheme.space24),
                  Card(
                    color: AppColors.surfaceVariant,
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.space16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Notes',
                            style: AppTextStyles.label,
                          ),
                          const SizedBox(height: AppTheme.space8),
                          Text(
                            invoice.notes!,
                            style: AppTextStyles.body,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _generatePdf(invoice),
                    child: const Text('Generate PDF'),
                  ),
                ),
                const SizedBox(width: AppTheme.space12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _shareInvoice(invoice),
                    child: const Text('Share'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatusBanner extends StatelessWidget {
  final InvoiceStatus status;
  final VoidCallback onToggle;

  const _StatusBanner({
    required this.status,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isPaid = status == InvoiceStatus.paid;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.space16,
        vertical: AppTheme.space12,
      ),
      decoration: BoxDecoration(
        color: isPaid ? AppColors.paidContainer : AppColors.unpaidContainer,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StatusBadgeWidget(status: status),
          TextButton(
            onPressed: onToggle,
            child: Text(
              isPaid ? 'Mark as Unpaid' : 'Mark as Paid',
              style: AppTextStyles.label.copyWith(
                color: isPaid ? AppColors.paid : AppColors.unpaid,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption,
        ),
        const SizedBox(height: AppTheme.space4),
        Text(
          value,
          style: AppTextStyles.body,
        ),
      ],
    );
  }
}

class _ItemTableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.space16,
        vertical: AppTheme.space12,
      ),
      color: AppColors.surfaceVariant,
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              'No.',
              style: AppTextStyles.label,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              'Description',
              style: AppTextStyles.label,
            ),
          ),
          SizedBox(
            width: 60,
            child: Text(
              'Qty',
              style: AppTextStyles.label,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 80,
            child: Text(
              'Price',
              style: AppTextStyles.label,
              textAlign: TextAlign.right,
            ),
          ),
          SizedBox(
            width: 80,
            child: Text(
              'Total',
              style: AppTextStyles.label,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemTableRow extends StatelessWidget {
  final int index;
  final dynamic item;

  const _ItemTableRow({
    required this.index,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.space16,
        vertical: AppTheme.space12,
      ),
      color: index % 2 == 0 ? Colors.white : AppColors.surfaceVariant,
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              index.toString(),
              style: AppTextStyles.body,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              item.description,
              style: AppTextStyles.body,
            ),
          ),
          SizedBox(
            width: 60,
            child: Text(
              item.quantity.toString(),
              style: AppTextStyles.body,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 80,
            child: Text(
              CurrencyFormatter.format(item.price),
              style: AppTextStyles.body,
              textAlign: TextAlign.right,
            ),
          ),
          SizedBox(
            width: 80,
            child: Text(
              CurrencyFormatter.format(item.lineTotal),
              style: AppTextStyles.body,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
