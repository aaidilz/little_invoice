import 'package:flutter/material.dart';
import 'package:little_invoice/core/theme/app_colors.dart';
import 'package:little_invoice/core/theme/app_text_styles.dart';
import 'package:little_invoice/core/theme/app_theme.dart';
import 'package:little_invoice/core/utils/currency_formatter.dart';

/// Calculation summary card matching the DESIGN "Summary Card" pattern.
/// Uses the primary-container dark background with amber accent total.
class CalculationSummaryWidget extends StatelessWidget {
  final double subtotal;
  final double discountPercent;
  final double discountAmount;
  final double taxPercent;
  final double taxAmount;
  final double dpAmount;
  final double total;

  const CalculationSummaryWidget({
    super.key,
    required this.subtotal,
    required this.discountPercent,
    required this.discountAmount,
    required this.taxPercent,
    required this.taxAmount,
    required this.dpAmount,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.space24),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildRow(
            'Subtotal',
            CurrencyFormatter.format(subtotal),
          ),
          const SizedBox(height: AppTheme.space8),
          _buildRow(
            'Discount (${discountPercent.toStringAsFixed(1)}%)',
            '– ${CurrencyFormatter.format(discountAmount)}',
          ),
          const SizedBox(height: AppTheme.space8),
          _buildRow(
            'Tax (${taxPercent.toStringAsFixed(1)}%)',
            '+ ${CurrencyFormatter.format(taxAmount)}',
          ),
          const SizedBox(height: AppTheme.space8),
          _buildRow(
            'Down Payment',
            '– ${CurrencyFormatter.format(dpAmount)}',
          ),
          const SizedBox(height: AppTheme.space12),
          Container(
            height: 1,
            color: AppColors.onPrimaryContainer.withValues(alpha: 0.2),
          ),
          const SizedBox(height: AppTheme.space12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Due',
                style: AppTextStyles.h2.copyWith(
                  color: Colors.white,
                ),
              ),
              Text(
                CurrencyFormatter.format(total),
                style: AppTextStyles.statDisplay.copyWith(
                  color: AppColors.secondaryContainer,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMd.copyWith(
            color: AppColors.onPrimaryContainer,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.labelBold.copyWith(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
