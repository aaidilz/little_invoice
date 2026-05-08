import 'package:little_invoice/core/database/database_helper.dart';
import 'package:little_invoice/models/invoice_item.dart';
import 'package:little_invoice/core/database/database_exception.dart';
import 'package:sqflite/sqflite.dart' hide DatabaseException;

class InvoiceItemDao {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insert(InvoiceItem item) async {
    try {
      final db = await dbHelper.database;
      return await db.insert('invoice_items', item.toMap());
    } catch (e) {
      throw DatabaseException('Failed to insert invoice item', e);
    }
  }

  Future<List<InvoiceItem>> getByInvoice(int invoiceId) async {
    try {
      final db = await dbHelper.database;
      final maps = await db.query(
        'invoice_items',
        where: 'invoice_id = ?',
        whereArgs: [invoiceId],
      );
      return maps.map((map) => InvoiceItem.fromMap(map)).toList();
    } catch (e) {
      throw DatabaseException('Failed to get items by invoice', e);
    }
  }

  Future<int> update(InvoiceItem item) async {
    try {
      final db = await dbHelper.database;
      return await db.update(
        'invoice_items',
        item.toMap(),
        where: 'id = ?',
        whereArgs: [item.id],
      );
    } catch (e) {
      throw DatabaseException('Failed to update invoice item', e);
    }
  }

  Future<void> delete(int id) async {
    try {
      final db = await dbHelper.database;
      await db.delete(
        'invoice_items',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw DatabaseException('Failed to delete invoice item', e);
    }
  }

  Future<void> deleteByInvoice(int invoiceId) async {
    try {
      final db = await dbHelper.database;
      await db.delete(
        'invoice_items',
        where: 'invoice_id = ?',
        whereArgs: [invoiceId],
      );
    } catch (e) {
      throw DatabaseException('Failed to delete items by invoice', e);
    }
  }
}
