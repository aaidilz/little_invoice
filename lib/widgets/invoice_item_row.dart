import 'package:flutter/material.dart';
import 'package:little_invoice/core/theme/app_colors.dart';
import 'package:little_invoice/core/theme/app_text_styles.dart';
import 'package:little_invoice/core/theme/app_theme.dart';
import 'package:little_invoice/core/utils/currency_formatter.dart';
import 'package:little_invoice/models/invoice_item.dart';

/// Invoice line-item row matching the DESIGN "Item Row" pattern.
/// Description on top, qty × price = total on the bottom row.
class InvoiceItemRow extends StatelessWidget {
  final InvoiceItem item;
  final ValueChanged<InvoiceItem> onChanged;
  final VoidCallback onDelete;

  const InvoiceItemRow({
    super.key,
    required this.item,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.space16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          // ── Description + delete ──
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: item.description,
                  decoration: InputDecoration(
                    hintText: 'Service or product name',
                    hintStyle: AppTextStyles.bodyMd.copyWith(
                      color: AppColors.outline,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                    filled: false,
                  ),
                  style: AppTextStyles.bodyMd,
                  onChanged: (val) {
                    onChanged(item.copyWith(description: val));
                  },
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: AppColors.outline,
                  size: 20,
                ),
                onPressed: onDelete,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                tooltip: 'Remove item',
              ),
            ],
          ),
          const SizedBox(height: AppTheme.space12),

          // ── Qty, Price, Total ──
          Row(
            children: [
              SizedBox(
                width: 72,
                child: TextFormField(
                  initialValue: item.quantity.toString(),
                  decoration: InputDecoration(
                    labelText: 'QTY',
                    labelStyle: AppTextStyles.labelBold.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 10,
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    filled: true,
                    fillColor: AppColors.surfaceContainerLow,
                  ),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMd,
                  onChanged: (val) {
                    final qty = int.tryParse(val) ?? 0;
                    final lineTotal = qty * item.price;
                    onChanged(
                      item.copyWith(quantity: qty, lineTotal: lineTotal),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.space8),
                child: Text(
                  '×',
                  style: AppTextStyles.bodyMd.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
              Expanded(
                child: TextFormField(
                  initialValue: item.price.toString(),
                  decoration: InputDecoration(
                    labelText: 'PRICE',
                    labelStyle: AppTextStyles.labelBold.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 10,
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    filled: true,
                    fillColor: AppColors.surfaceContainerLow,
                    prefixText: 'Rp ',
                    prefixStyle: AppTextStyles.labelBold.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  textAlign: TextAlign.right,
                  style: AppTextStyles.bodyMd,
                  onChanged: (val) {
                    final price = double.tryParse(val) ?? 0.0;
                    final lineTotal = item.quantity * price;
                    onChanged(
                      item.copyWith(price: price, lineTotal: lineTotal),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.space8),
                child: Text(
                  '=',
                  style: AppTextStyles.bodyMd.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
              SizedBox(
                width: 90,
                child: Text(
                  CurrencyFormatter.format(item.lineTotal),
                  style: AppTextStyles.labelBold.copyWith(
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
