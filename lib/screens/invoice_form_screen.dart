import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:invoice_app/core/theme/app_text_styles.dart';
import 'package:invoice_app/core/theme/app_theme.dart';
import 'package:invoice_app/models/buyer.dart';
import 'package:invoice_app/models/invoice.dart';
import 'package:invoice_app/models/invoice_item.dart';
import 'package:invoice_app/providers/buyer_provider.dart';
import 'package:invoice_app/providers/invoice_provider.dart';
import 'package:invoice_app/providers/seller_provider.dart';
import 'package:invoice_app/widgets/calculation_summary_widget.dart';
import 'package:invoice_app/widgets/invoice_item_row.dart';
import 'package:invoice_app/core/services/invoice_calculator.dart';
import 'package:invoice_app/core/utils/constants.dart';
import 'package:intl/intl.dart';

class InvoiceFormScreen extends StatefulWidget {
  final int? invoiceId;

  const InvoiceFormScreen({
    super.key,
    this.invoiceId,
  });

  @override
  State<InvoiceFormScreen> createState() => _InvoiceFormScreenState();
}

class _InvoiceFormScreenState extends State<InvoiceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _calculator = InvoiceCalculator();

  Buyer? _selectedBuyer;
  late TextEditingController _cityDateController;
  late TextEditingController _notesController;
  late TextEditingController _discountController;
  late TextEditingController _taxController;
  late TextEditingController _dpController;

  DateTime _dueDate = DateTime.now().add(const Duration(days: 7));
  List<InvoiceItem> _items = [];
  Map<String, double> _calcResult = {
    'subtotal': 0,
    'afterDiscount': 0,
    'afterTax': 0,
    'total': 0
  };

  @override
  void initState() {
    super.initState();
    final todayStr = DateFormat('d MMMM yyyy').format(DateTime.now());
    _cityDateController =
        TextEditingController(text: 'Jakarta, $todayStr');
    _notesController = TextEditingController(text: '');
    _discountController = TextEditingController(text: '0');
    _taxController = TextEditingController(text: '0');
    _dpController = TextEditingController(text: '0');

    if (widget.invoiceId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final provider = context.read<InvoiceProvider>();
        final invoice = provider.invoices.firstWhere(
          (i) => i.id == widget.invoiceId,
        );
        final items = await provider.getItemsForInvoice(widget.invoiceId!);
        final buyers = context.read<BuyerProvider>().buyers;
        final buyer = buyers.firstWhere(
          (b) => b.id == invoice.buyerId,
          orElse: () => throw Exception('Buyer not found'),
        );

        setState(() {
          _selectedBuyer = buyer;
          _cityDateController.text = invoice.cityDate;
          _dueDate = invoice.dueDate;
          _notesController.text = invoice.notes ?? '';
          _discountController.text = invoice.discount.toString();
          _taxController.text = invoice.tax.toString();
          _dpController.text = invoice.dp.toString();
          _items = items;
          _recalculate();
        });
      });
    } else {
      _items.add(InvoiceItem(
        invoiceId: 0,
        description: '',
        quantity: 1,
        price: 0,
        lineTotal: 0,
      ));
    }
  }

  void _recalculate() {
    final discount = double.tryParse(_discountController.text) ?? 0;
    final tax = double.tryParse(_taxController.text) ?? 0;
    final dp = double.tryParse(_dpController.text) ?? 0;

    setState(() {
      _calcResult = _calculator.calculateAll(
        items: _items,
        discountPercent: discount,
        taxPercent: tax,
        dpAmount: dp,
      );
    });
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      if (_selectedBuyer == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a buyer')),
        );
        return;
      }
      if (_items.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one item')),
        );
        return;
      }

      final seller = context.read<SellerProvider>().profile;
      if (seller == null || seller.id == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please create a seller profile first')),
        );
        return;
      }

      final discount = double.tryParse(_discountController.text) ?? 0;
      final tax = double.tryParse(_taxController.text) ?? 0;
      final dp = double.tryParse(_dpController.text) ?? 0;

      final invoice = Invoice(
        id: widget.invoiceId,
        sellerId: seller.id!,
        buyerId: _selectedBuyer!.id!,
        invoiceNumber: widget.invoiceId != null
            ? context
                    .read<InvoiceProvider>()
                    .invoices
                    .firstWhere((i) => i.id == widget.invoiceId)
                    .invoiceNumber
            : generateInvoiceNumber(),
        cityDate: _cityDateController.text,
        dueDate: _dueDate,
        status: widget.invoiceId != null
            ? context
                    .read<InvoiceProvider>()
                    .invoices
                    .firstWhere((i) => i.id == widget.invoiceId)
                    .status
            : InvoiceStatus.unpaid,
        subtotal: _calcResult['subtotal']!,
        discount: discount,
        tax: tax,
        dp: dp,
        total: _calcResult['total']!,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );

      final provider = context.read<InvoiceProvider>();
      if (widget.invoiceId == null) {
        provider.createInvoice(invoice, _items).then((_) {
          if (mounted) Navigator.pop(context);
        });
      } else {
        provider.updateInvoice(invoice, _items).then((_) {
          if (mounted) Navigator.pop(context);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final buyers = context.watch<BuyerProvider>().buyers;
    final subtotal = _calcResult['subtotal']!;
    final discountPercent = double.tryParse(_discountController.text) ?? 0;
    final discountAmount = subtotal * (discountPercent / 100);
    final taxPercent = double.tryParse(_taxController.text) ?? 0;
    final taxAmount = _calcResult['afterDiscount']! * (taxPercent / 100);
    final dpAmount = double.tryParse(_dpController.text) ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.invoiceId == null ? 'New Invoice' : 'Edit Invoice'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.space16),
          children: [
            const SizedBox(height: AppTheme.space24),
            Text(
              'Invoice Info',
              style: AppTextStyles.headline,
            ),
            const SizedBox(height: AppTheme.space12),
            DropdownButtonFormField<Buyer>(
              value: _selectedBuyer,
              decoration: const InputDecoration(
                labelText: 'Buyer',
                hintText: 'Select a buyer',
              ),
              items: buyers
                  .map((b) => DropdownMenuItem(
                        value: b,
                        child: Text(b.name),
                      ))
                  .toList(),
              onChanged: (b) => setState(() => _selectedBuyer = b),
              validator: (v) => v == null ? 'Required' : null,
            ),
            const SizedBox(height: AppTheme.space12),
            TextFormField(
              controller: _cityDateController,
              decoration: const InputDecoration(
                labelText: 'City & Date',
                hintText: 'e.g. Jakarta, 1 July 2025',
              ),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: AppTheme.space12),
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _dueDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 3650)),
                );
                if (date != null) {
                  setState(() => _dueDate = date);
                }
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Due Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                baseStyle: AppTextStyles.body,
                child: Text(
                  DateFormat('dd MMM yyyy').format(_dueDate),
                  style: AppTextStyles.body,
                ),
              ),
            ),
            const SizedBox(height: AppTheme.space24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Items',
                  style: AppTextStyles.headline,
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _items.add(InvoiceItem(
                        invoiceId: 0,
                        description: '',
                        quantity: 1,
                        price: 0,
                        lineTotal: 0,
                      ));
                    });
                  },
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('Add Item'),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.space12),
            ..._items.asMap().entries.map((e) {
              final idx = e.key;
              final item = e.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.space8),
                child: InvoiceItemRow(
                  item: item,
                  onChanged: (newItem) {
                    setState(() {
                      _items[idx] = newItem;
                      _recalculate();
                    });
                  },
                  onDelete: () {
                    setState(() {
                      _items.removeAt(idx);
                      _recalculate();
                    });
                  },
                ),
              );
            }),
            const SizedBox(height: AppTheme.space24),
            Text(
              'Calculations',
              style: AppTextStyles.headline,
            ),
            const SizedBox(height: AppTheme.space12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _discountController,
                    decoration: const InputDecoration(
                      labelText: 'Discount %',
                      hintText: '0',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _recalculate(),
                  ),
                ),
                const SizedBox(width: AppTheme.space12),
                Expanded(
                  child: TextFormField(
                    controller: _taxController,
                    decoration: const InputDecoration(
                      labelText: 'Tax %',
                      hintText: '0',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _recalculate(),
                  ),
                ),
                const SizedBox(width: AppTheme.space12),
                Expanded(
                  child: TextFormField(
                    controller: _dpController,
                    decoration: const InputDecoration(
                      labelText: 'Down Payment',
                      hintText: '0',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _recalculate(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.space12),
            CalculationSummaryWidget(
              subtotal: subtotal,
              discountPercent: discountPercent,
              discountAmount: discountAmount,
              taxPercent: taxPercent,
              taxAmount: taxAmount,
              dpAmount: dpAmount,
              total: _calcResult['total']!,
            ),
            const SizedBox(height: AppTheme.space24),
            Text(
              'Notes',
              style: AppTextStyles.headline,
            ),
            const SizedBox(height: AppTheme.space12),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                hintText: 'Optional notes...',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
              minLines: 4,
            ),
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
        child: Consumer<InvoiceProvider>(
          builder: (context, provider, child) {
            return SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: provider.isLoading ? null : _save,
                child: provider.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Save Invoice'),
              ),
            );
          },
        ),
      ),
    );
  }
}
