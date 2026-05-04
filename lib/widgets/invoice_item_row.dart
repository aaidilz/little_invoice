import 'package:flutter/material.dart';
import 'package:invoice_app/core/theme/app_colors.dart';
import 'package:invoice_app/core/theme/app_text_styles.dart';
import 'package:invoice_app/core/theme/app_theme.dart';
import 'package:invoice_app/core/utils/currency_formatter.dart';
import 'package:invoice_app/models/invoice_item.dart';

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
    return Card(
      margin: const EdgeInsets.symmetric(vertical: AppTheme.space4),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.space12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: item.description,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: AppTextStyles.body,
                    onChanged: (val) {
                      onChanged(item.copyWith(description: val));
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: AppColors.error),
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                )
              ],
            ),
            const SizedBox(height: AppTheme.space8),
            Row(
              children: [
                SizedBox(
                  width: 80,
                  child: TextFormField(
                    initialValue: item.quantity.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Qty',
                      isDense: true,
                    ),
                    keyboardType: TextInputType.number,
                    style: AppTextStyles.body,
                    onChanged: (val) {
                      final qty = int.tryParse(val) ?? 0;
                      final lineTotal = qty * item.price;
                      onChanged(item.copyWith(quantity: qty, lineTotal: lineTotal));
                    },
                  ),
                ),
                const SizedBox(width: AppTheme.space8),
                Text('×', style: AppTextStyles.body),
                const SizedBox(width: AppTheme.space8),
                Expanded(
                  child: TextFormField(
                    initialValue: item.price.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      isDense: true,
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: AppTextStyles.body,
                    onChanged: (val) {
                      final price = double.tryParse(val) ?? 0.0;
                      final lineTotal = item.quantity * price;
                      onChanged(item.copyWith(price: price, lineTotal: lineTotal));
                    },
                  ),
                ),
                const SizedBox(width: AppTheme.space8),
                Text('=', style: AppTextStyles.body),
                const SizedBox(width: AppTheme.space8),
                SizedBox(
                  width: 80,
                  child: Text(
                    CurrencyFormatter.format(item.lineTotal),
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
