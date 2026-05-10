import 'package:flutter_test/flutter_test.dart';
import 'package:little_invoice/core/services/invoice_calculator.dart';
import 'package:little_invoice/models/invoice_item.dart';

void main() {
  late InvoiceCalculator calculator;

  setUp(() {
    calculator = InvoiceCalculator();
  });

  group('Invoice Calculator Tests (Edge Cases)', () {
    test('Basic total: 2 items, 0 discount, 0 tax, 0 dp', () {
      final items = [
        InvoiceItem(invoiceId: 1, description: 'Item 1', quantity: 3, price: 100000, lineTotal: 300000),
        InvoiceItem(invoiceId: 1, description: 'Item 2', quantity: 1, price: 50000, lineTotal: 50000),
      ];

      final result = calculator.calculateAll(
        items: items,
        discountPercent: 0,
        taxPercent: 0,
        dpAmount: 0,
      );

      expect(result['subtotal'], 350000);
      expect(result['total'], 350000);
    });

    test('With discount', () {
      const subtotal = 350000.0;
      final afterDiscount = calculator.applyDiscount(subtotal, 10);
      expect(afterDiscount, 315000);
    });

    test('With tax', () {
      const afterDiscount = 315000.0;
      final afterTax = calculator.applyTax(afterDiscount, 11);
      expect(afterTax, 349650);
    });

    test('With DP', () {
      const afterTax = 349650.0;
      final total = calculator.applyDP(afterTax, 100000);
      expect(total, 249650);
    });

    test('DP exceeds total (clamped)', () {
      const afterTax = 100000.0;
      final total = calculator.applyDP(afterTax, 150000);
      expect(total, 0);
    });
  });
}
