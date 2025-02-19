import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/warranty.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'warranty.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE warranties(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        warrantyCode TEXT UNIQUE,
        name TEXT,
        phone TEXT,
        damage TEXT,
        warrantyDuration INTEGER,
        expiryDate TEXT
      )
    ''');
  }

  Future<int> insertWarranty(Warranty warranty) async {
    Database db = await instance.database;
    return await db.insert('warranties', warranty.toMap());
  }

  Future<List<Warranty>> getAllWarranties() async {
    Database db = await instance.database;
    var warranties = await db.query('warranties', orderBy: 'id DESC');
    return warranties.isNotEmpty
        ? warranties.map((c) => Warranty.fromMap(c)).toList()
        : [];
  }

  Future<Warranty?> getWarrantyByCode(String code) async {
    Database db = await instance.database;
    var res = await db.query('warranties', where: 'warrantyCode = ?', whereArgs: [code]);
    return res.isNotEmpty ? Warranty.fromMap(res.first) : null;
  }

  Future<List<Warranty>> getWarrantyHistory() async {
    Database db = await instance.database;
    DateTime now = DateTime.now();
    DateTime sixtyDaysAgo = now.subtract(Duration(days: 60));
    var warranties = await db.query(
        'warranties',
        where: 'expiryDate < ? OR expiryDate BETWEEN ? AND ?',
        whereArgs: [now.toIso8601String(), sixtyDaysAgo.toIso8601String(), now.toIso8601String()],
        orderBy: 'expiryDate DESC'
    );
    return warranties.isNotEmpty
        ? warranties.map((c) => Warranty.fromMap(c)).toList()
        : [];
  }
}
