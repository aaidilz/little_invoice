import 'package:flutter_test/flutter_test.dart';
import 'package:little_invoice/core/database/dao/buyer_dao.dart';
import 'package:little_invoice/core/database/dao/invoice_dao.dart';
import 'package:little_invoice/core/database/dao/invoice_item_dao.dart';
import 'package:little_invoice/core/database/dao/seller_dao.dart';
import 'package:little_invoice/models/buyer.dart';
import 'package:little_invoice/models/invoice.dart';
import 'package:little_invoice/models/invoice_item.dart';
import 'package:little_invoice/models/seller_profile.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('Database CRUD', () {
    test('Seller Profile CRUD', () async {
      final dao = SellerDao();
      final profile = SellerProfile(
        name: 'Seller 1',
        address: 'Addr',
        phone: '123',
        email: 'e@e.com',
        bank: 'Bank',
      );
      final id = await dao.insert(profile);
      expect(id, isNotNull);

      final fetched = await dao.get(id);
      expect(fetched?.name, 'Seller 1');

      await dao.update(fetched!.copyWith(name: 'Seller 2'));
      final updated = await dao.get(id);
      expect(updated?.name, 'Seller 2');

      await dao.delete(id);
      final deleted = await dao.get(id);
      expect(deleted, isNull);
    });

    test('Buyer CRUD', () async {
      final dao = BuyerDao();
      final buyer = Buyer(name: 'Buyer 1', address: 'Addr', phone: '1', email: 'e');
      final id = await dao.insert(buyer);
      expect(id, isNotNull);

      final fetched = await dao.get(id);
      expect(fetched?.name, 'Buyer 1');

      final all = await dao.getAll();
      expect(all.isNotEmpty, true);

      await dao.delete(id);
      final deleted = await dao.get(id);
      expect(deleted, isNull);
    });

    test('Invoice and Item CRUD', () async {
      final sellerDao = SellerDao();
      final buyerDao = BuyerDao();
      final invoiceDao = InvoiceDao();
      final itemDao = InvoiceItemDao();

      final sellerId = await sellerDao.insert(SellerProfile(name: 'S', address: 'A', phone: 'P', email: 'E', bank: 'B'));
      final buyerId = await buyerDao.insert(Buyer(name: 'B', address: 'A', phone: 'P', email: 'E'));

      final invoice = Invoice(
        sellerId: sellerId,
        buyerId: buyerId,
        invoiceNumber: 'INV-TEST',
        cityDate: 'City',
        dueDate: DateTime.now(),
        status: InvoiceStatus.unpaid,
        subtotal: 100,
        discount: 0,
        tax: 0,
        dp: 0,
        total: 100,
      );

      final invoiceId = await invoiceDao.insert(invoice);
      expect(invoiceId, isNotNull);

      final item = InvoiceItem(
        invoiceId: invoiceId,
        description: 'Item 1',
        quantity: 1,
        price: 100,
        lineTotal: 100,
      );

      final itemId = await itemDao.insert(item);
      expect(itemId, isNotNull);

      final items = await itemDao.getByInvoice(invoiceId);
      expect(items.length, 1);

      await invoiceDao.delete(invoiceId);
      
      final itemsAfterDelete = await itemDao.getByInvoice(invoiceId);
      expect(itemsAfterDelete.isEmpty, true);
    });
  });
}
