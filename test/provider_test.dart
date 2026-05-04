import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_app/models/buyer.dart';
import 'package:invoice_app/models/seller_profile.dart';
import 'package:invoice_app/providers/buyer_provider.dart';
import 'package:invoice_app/providers/seller_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('Provider Tests', () {
    test('SellerProvider notifies listeners on change', () async {
      final provider = SellerProvider();
      int notifyCount = 0;
      provider.addListener(() {
        notifyCount++;
      });

      await provider.initialize();
      expect(notifyCount, greaterThan(0));

      final profile = SellerProfile(
        name: 'Seller', address: 'Addr', phone: '1', email: 'E', bank: 'B'
      );
      
      final previousCount = notifyCount;
      await provider.saveProfile(profile);
      expect(notifyCount, greaterThan(previousCount));
      expect(provider.profile?.name, 'Seller');
    });

    test('BuyerProvider notifies listeners on change', () async {
      final provider = BuyerProvider();
      int notifyCount = 0;
      provider.addListener(() {
        notifyCount++;
      });

      await provider.initialize();
      final initialCount = notifyCount;

      final buyer = Buyer(name: 'B1', address: 'A', phone: '1', email: 'E');
      await provider.addBuyer(buyer);
      
      expect(notifyCount, greaterThan(initialCount));
      expect(provider.buyers.length, greaterThan(0));
    });
  });
}
