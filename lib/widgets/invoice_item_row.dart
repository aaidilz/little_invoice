import 'package:flutter/material.dart';
import 'package:little_invoice/core/theme/app_colors.dart';
import 'package:little_invoice/core/theme/app_text_styles.dart';
import 'package:little_invoice/core/theme/app_theme.dart';
import 'package:little_invoice/core/utils/currency_formatter.dart';
import 'package:little_invoice/models/invoice_item.dart';

/// Invoice line-item row matching the DESIGN "Item Row" pattern.
/// Description on top, qty × price = total on the bottom row.
///
/// Uses internal TextEditingControllers to avoid state loss on parent rebuild.
class InvoiceItemRow extends StatefulWidget {
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
  State<InvoiceItemRow> createState() => _InvoiceItemRowState();
}

class _InvoiceItemRowState extends State<InvoiceItemRow> {
  late final TextEditingController _descController;
  late final TextEditingController _qtyController;
  late final TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _descController = TextEditingController(text: widget.item.description);
    _qtyController =
        TextEditingController(text: widget.item.quantity.toString());
    _priceController =
        TextEditingController(text: widget.item.price.toString());
  }

  @override
  void dispose() {
    _descController.dispose();
    _qtyController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _onDescriptionChanged(String val) {
    widget.onChanged(widget.item.copyWith(description: val));
  }

  void _onQtyChanged(String val) {
    final qty = int.tryParse(val) ?? 0;
    final lineTotal = qty * widget.item.price;
    widget.onChanged(
      widget.item.copyWith(quantity: qty, lineTotal: lineTotal),
    );
  }

  void _onPriceChanged(String val) {
    final price = double.tryParse(val) ?? 0.0;
    final lineTotal = widget.item.quantity * price;
    widget.onChanged(
      widget.item.copyWith(price: price, lineTotal: lineTotal),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.space16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(
            color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          // ── Description + delete ──
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _descController,
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
                  onChanged: _onDescriptionChanged,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: AppColors.outline,
                  size: 20,
                ),
                onPressed: widget.onDelete,
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
                  controller: _qtyController,
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
                  onChanged: _onQtyChanged,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppTheme.space8),
                child: Text(
                  '×',
                  style: AppTextStyles.bodyMd.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: _priceController,
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
                  onChanged: _onPriceChanged,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppTheme.space8),
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
                  CurrencyFormatter.format(widget.item.lineTotal),
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
