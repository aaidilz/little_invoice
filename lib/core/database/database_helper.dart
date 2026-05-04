import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('invoice_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onConfigure: _onConfigure,
    );
  }

  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE seller_profiles (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  address TEXT NOT NULL,
  phone TEXT NOT NULL,
  email TEXT NOT NULL,
  bank TEXT NOT NULL,
  logo_path TEXT,
  stamp_path TEXT,
  signature_path TEXT
);
''');

    await db.execute('''
CREATE TABLE buyers (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  address TEXT NOT NULL,
  phone TEXT NOT NULL,
  email TEXT NOT NULL
);
''');

    await db.execute('''
CREATE TABLE invoices (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  seller_id INTEGER NOT NULL,
  buyer_id INTEGER NOT NULL,
  invoice_number TEXT NOT NULL UNIQUE,
  city_date TEXT NOT NULL,
  due_date TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'unpaid',
  subtotal REAL NOT NULL DEFAULT 0,
  discount REAL NOT NULL DEFAULT 0,
  tax REAL NOT NULL DEFAULT 0,
  dp REAL NOT NULL DEFAULT 0,
  total REAL NOT NULL DEFAULT 0,
  notes TEXT,
  FOREIGN KEY (seller_id) REFERENCES seller_profiles(id),
  FOREIGN KEY (buyer_id) REFERENCES buyers(id)
);
''');

    await db.execute('''
CREATE TABLE invoice_items (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  invoice_id INTEGER NOT NULL,
  description TEXT NOT NULL,
  quantity INTEGER NOT NULL,
  price REAL NOT NULL,
  line_total REAL NOT NULL,
  FOREIGN KEY (invoice_id) REFERENCES invoices(id) ON DELETE CASCADE
);
''');
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
