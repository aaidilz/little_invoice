import 'package:invoice_app/core/database/database_helper.dart';
import 'package:invoice_app/models/buyer.dart';
import 'package:invoice_app/core/database/database_exception.dart';
import 'package:sqflite/sqflite.dart' hide DatabaseException;

class BuyerDao {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insert(Buyer buyer) async {
    try {
      final db = await dbHelper.database;
      return await db.insert('buyers', buyer.toMap());
    } catch (e) {
      throw DatabaseException('Failed to insert buyer', e);
    }
  }

  Future<Buyer?> get(int id) async {
    try {
      final db = await dbHelper.database;
      final maps = await db.query(
        'buyers',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (maps.isNotEmpty) {
        return Buyer.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      throw DatabaseException('Failed to get buyer', e);
    }
  }

  Future<List<Buyer>> getAll() async {
    try {
      final db = await dbHelper.database;
      final maps = await db.query('buyers');
      return maps.map((map) => Buyer.fromMap(map)).toList();
    } catch (e) {
      throw DatabaseException('Failed to get all buyers', e);
    }
  }

  Future<int> update(Buyer buyer) async {
    try {
      final db = await dbHelper.database;
      return await db.update(
        'buyers',
        buyer.toMap(),
        where: 'id = ?',
        whereArgs: [buyer.id],
      );
    } catch (e) {
      throw DatabaseException('Failed to update buyer', e);
    }
  }

  Future<void> delete(int id) async {
    try {
      final db = await dbHelper.database;
      await db.delete(
        'buyers',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw DatabaseException('Failed to delete buyer', e);
    }
  }
}
