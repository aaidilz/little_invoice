import 'package:little_invoice/core/database/database_helper.dart';
import 'package:little_invoice/models/invoice.dart';
import 'package:little_invoice/core/database/database_exception.dart';

class InvoiceDao {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insert(Invoice invoice) async {
    try {
      final db = await dbHelper.database;
      return await db.insert('invoices', invoice.toMap());
    } catch (e) {
      throw DatabaseException('Failed to insert invoice', e);
    }
  }

  Future<Invoice?> get(int id) async {
    try {
      final db = await dbHelper.database;
      final maps = await db.query(
        'invoices',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (maps.isNotEmpty) {
        return Invoice.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      throw DatabaseException('Failed to get invoice', e);
    }
  }

  Future<List<Invoice>> getAll() async {
    try {
      final db = await dbHelper.database;
      final maps = await db.query('invoices', orderBy: 'id DESC');
      return maps.map((map) => Invoice.fromMap(map)).toList();
    } catch (e) {
      throw DatabaseException('Failed to get all invoices', e);
    }
  }

  Future<List<Invoice>> getByStatus(InvoiceStatus status) async {
    try {
      final db = await dbHelper.database;
      final maps = await db.query(
        'invoices',
        where: 'status = ?',
        whereArgs: [status.name],
      );
      return maps.map((map) => Invoice.fromMap(map)).toList();
    } catch (e) {
      throw DatabaseException('Failed to get invoices by status', e);
    }
  }

  Future<List<Invoice>> getDueByDate(DateTime date) async {
    try {
      final db = await dbHelper.database;
      // we need due_date == date and status == 'unpaid'
      final maps = await db.query(
        'invoices',
        where: 'status = ? AND due_date = ?',
        whereArgs: ['unpaid', date.toIso8601String()],
      );
      return maps.map((map) => Invoice.fromMap(map)).toList();
    } catch (e) {
      throw DatabaseException('Failed to get invoices due by date', e);
    }
  }

  Future<int> update(Invoice invoice) async {
    try {
      final db = await dbHelper.database;
      return await db.update(
        'invoices',
        invoice.toMap(),
        where: 'id = ?',
        whereArgs: [invoice.id],
      );
    } catch (e) {
      throw DatabaseException('Failed to update invoice', e);
    }
  }

  Future<void> delete(int id) async {
    try {
      final db = await dbHelper.database;
      await db.delete(
        'invoices',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw DatabaseException('Failed to delete invoice', e);
    }
  }
}
