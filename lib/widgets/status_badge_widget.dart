import 'package:flutter/material.dart';
import 'package:little_invoice/core/theme/app_colors.dart';
import 'package:little_invoice/core/theme/app_text_styles.dart';
import 'package:little_invoice/core/theme/app_theme.dart';
import 'package:little_invoice/models/invoice.dart';

/// Pill-shaped status badge matching the DESIGN status indicators.
/// Uses a dot + label pattern (e.g. ● PAID) with color-coded backgrounds.
class StatusBadgeWidget extends StatelessWidget {
  final InvoiceStatus status;

  const StatusBadgeWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final isPaid = status == InvoiceStatus.paid;
    final color = isPaid ? AppColors.paid : AppColors.unpaid;
    final bgColor = isPaid ? AppColors.paidContainer : AppColors.unpaidContainer;
    final text = isPaid ? 'PAID' : 'UNPAID';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.space12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusBadge),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: AppTextStyles.labelBold.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
