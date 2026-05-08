import 'package:little_invoice/models/invoice_item.dart';

class InvoiceCalculator {
  double calculateSubtotal(List<InvoiceItem> items) {
    return items.fold(0.0, (sum, item) => sum + (item.quantity * item.price));
  }

  double applyDiscount(double subtotal, double discountPercent) {
    return subtotal - (subtotal * discountPercent / 100);
  }

  double applyTax(double discountedAmount, double taxPercent) {
    return discountedAmount + (discountedAmount * taxPercent / 100);
  }

  double applyDP(double totalAfterTax, double dpAmount) {
    final total = totalAfterTax - dpAmount;
    return total < 0 ? 0.0 : total;
  }

  Map<String, double> calculateAll({
    required List<InvoiceItem> items,
    required double discountPercent,
    required double taxPercent,
    required double dpAmount,
  }) {
    final subtotal = calculateSubtotal(items);
    final afterDiscount = applyDiscount(subtotal, discountPercent);
    final afterTax = applyTax(afterDiscount, taxPercent);
    final total = applyDP(afterTax, dpAmount);

    return {
      'subtotal': subtotal,
      'afterDiscount': afterDiscount,
      'afterTax': afterTax,
      'total': total,
    };
  }
}
