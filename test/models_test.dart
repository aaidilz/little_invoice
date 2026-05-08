import 'package:flutter_test/flutter_test.dart';
import 'package:little_invoice/models/buyer.dart';
import 'package:little_invoice/models/invoice.dart';
import 'package:little_invoice/models/invoice_item.dart';
import 'package:little_invoice/models/seller_profile.dart';

void main() {
  group('Models Serialization', () {
    test('SellerProfile fromMap and toMap', () {
      final profile = SellerProfile(
        id: 1,
        name: 'John Doe',
        address: '123 Main St',
        phone: '555-1234',
        email: 'john@example.com',
        bank: 'Bank 123',
      );
      final map = profile.toMap();
      final decoded = SellerProfile.fromMap(map);
      expect(decoded.id, profile.id);
      expect(decoded.name, profile.name);
    });

    test('Buyer fromMap and toMap', () {
      final buyer = Buyer(
        id: 1,
        name: 'Jane Smith',
        address: '456 Side St',
        phone: '555-5678',
        email: 'jane@example.com',
      );
      final map = buyer.toMap();
      final decoded = Buyer.fromMap(map);
      expect(decoded.name, buyer.name);
    });

    test('Invoice fromMap and toMap', () {
      final invoice = Invoice(
        id: 1,
        sellerId: 1,
        buyerId: 1,
        invoiceNumber: 'INV-001',
        cityDate: 'City, Date',
        dueDate: DateTime(2025, 1, 1),
        status: InvoiceStatus.unpaid,
        subtotal: 100,
        discount: 0,
        tax: 10,
        dp: 0,
        total: 110,
      );
      final map = invoice.toMap();
      final decoded = Invoice.fromMap(map);
      expect(decoded.invoiceNumber, invoice.invoiceNumber);
      expect(decoded.dueDate, invoice.dueDate);
      expect(decoded.status, invoice.status);
    });

    test('InvoiceItem fromMap and toMap', () {
      final item = InvoiceItem(
        id: 1,
        invoiceId: 1,
        description: 'Item 1',
        quantity: 2,
        price: 50,
        lineTotal: 100,
      );
      final map = item.toMap();
      final decoded = InvoiceItem.fromMap(map);
      expect(decoded.description, item.description);
    });
  });
}
