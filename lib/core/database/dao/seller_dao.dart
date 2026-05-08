import 'package:little_invoice/core/database/database_helper.dart';
import 'package:little_invoice/models/seller_profile.dart';
import 'package:little_invoice/core/database/database_exception.dart';
import 'package:sqflite/sqflite.dart' hide DatabaseException;

class SellerDao {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insert(SellerProfile profile) async {
    try {
      final db = await dbHelper.database;
      return await db.insert('seller_profiles', profile.toMap());
    } catch (e) {
      throw DatabaseException('Failed to insert seller profile', e);
    }
  }

  Future<SellerProfile?> get(int id) async {
    try {
      final db = await dbHelper.database;
      final maps = await db.query(
        'seller_profiles',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (maps.isNotEmpty) {
        return SellerProfile.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      throw DatabaseException('Failed to get seller profile', e);
    }
  }

  Future<SellerProfile?> getFirst() async {
    try {
      final db = await dbHelper.database;
      final maps = await db.query('seller_profiles', limit: 1);
      if (maps.isNotEmpty) {
        return SellerProfile.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      throw DatabaseException('Failed to get first seller profile', e);
    }
  }

  Future<int> update(SellerProfile profile) async {
    try {
      final db = await dbHelper.database;
      return await db.update(
        'seller_profiles',
        profile.toMap(),
        where: 'id = ?',
        whereArgs: [profile.id],
      );
    } catch (e) {
      throw DatabaseException('Failed to update seller profile', e);
    }
  }

  Future<void> delete(int id) async {
    try {
      final db = await dbHelper.database;
      await db.delete(
        'seller_profiles',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw DatabaseException('Failed to delete seller profile', e);
    }
  }
}
