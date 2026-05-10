import 'package:flutter/material.dart';
import 'package:little_invoice/core/theme/app_colors.dart';
import 'package:little_invoice/core/theme/app_text_styles.dart';
import 'package:little_invoice/core/theme/app_theme.dart';
import 'package:little_invoice/models/invoice.dart';

class StatusBadgeWidget extends StatelessWidget {
  final InvoiceStatus status;

  const StatusBadgeWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final isPaid = status == InvoiceStatus.paid;
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
