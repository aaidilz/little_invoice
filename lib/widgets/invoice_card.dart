import 'package:flutter/material.dart';
import 'package:little_invoice/core/theme/app_colors.dart';
import 'package:little_invoice/core/theme/app_text_styles.dart';
import 'package:little_invoice/core/theme/app_theme.dart';
import 'package:little_invoice/core/utils/currency_formatter.dart';
import 'package:little_invoice/core/utils/date_formatter.dart';
import 'package:little_invoice/models/invoice.dart';

class InvoiceCard extends StatelessWidget {
  final Invoice invoice;
  final VoidCallback onTap;

  const InvoiceCard({
    super.key,
    required this.invoice,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    invoice.invoiceNumber,
                    style: AppTextStyles.title,
                  ),
                  _buildStatusBadge(),
                ],
              ),
              const SizedBox(height: AppTheme.space8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Buyer',
                    style: AppTextStyles.body.copyWith(
                      color: const Color(0xFF6E7D8A),
                    ),
                  ),
                  Text(
                    DateFormatter.formatShortDate(invoice.dueDate),
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
              const Divider(height: AppTheme.space24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: AppTextStyles.caption,
                  ),
                  Text(
                    CurrencyFormatter.format(invoice.total),
                    style: AppTextStyles.title.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    final isPaid = invoice.status == InvoiceStatus.paid;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.space8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: isPaid ? AppColors.paidContainer : AppColors.unpaidContainer,
        borderRadius: BorderRadius.circular(AppTheme.radiusBadge),
      ),
      child: Text(
        isPaid ? 'PAID' : 'UNPAID',
        style: AppTextStyles.label.copyWith(
          color: isPaid ? AppColors.paid : AppColors.unpaid,
        ),
      ),
    );
  }
}
