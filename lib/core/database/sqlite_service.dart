import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class SQLiteService {
  SQLiteService._privateConstructor();
  static final SQLiteService instance = SQLiteService._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Platform-specific initialization for Desktop and Web
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    } else if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'coffee_pos.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDb,
      onUpgrade: _upgradeDb,
    );
  }

  Future<void> _upgradeDb(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE transactions ADD COLUMN amount_received REAL',
      );
      await db.execute('ALTER TABLE transactions ADD COLUMN change REAL');
    }
  }

  Future<void> _createDb(Database db, int version) async {
    // Products Table
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        category TEXT,
        type TEXT,
        buy_price REAL,
        sell_price REAL,
        stock REAL,
        unit TEXT,
        created_at TEXT
      )
    ''');

    // Transactions Table
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        invoice TEXT,
        total REAL,
        payment_method TEXT,
        payment_status TEXT,
        payment_ref TEXT,
        amount_received REAL,
        change REAL,
        created_at TEXT
      )
    ''');

    // Transaction Items Table
    await db.execute('''
      CREATE TABLE transaction_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        transaction_id INTEGER,
        product_id INTEGER,
        quantity REAL,
        price REAL,
        FOREIGN KEY (transaction_id) REFERENCES transactions (id) ON DELETE CASCADE,
        FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE SET NULL
      )
    ''');
  }

  // --- Generic CRUD Helpers ---

  // Insert
  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(table, data);
  }

  // Get All
  Future<List<Map<String, dynamic>>> getAll(String table) async {
    final db = await database;
    return await db.query(table);
  }

  // Get By ID
  Future<Map<String, dynamic>?> getById(String table, int id) async {
    final db = await database;
    final results = await db.query(
      table,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (results.isNotEmpty) return results.first;
    return null;
  }

  // Update
  Future<int> update(String table, Map<String, dynamic> data, int id) async {
    final db = await database;
    return await db.update(table, data, where: 'id = ?', whereArgs: [id]);
  }

  // Delete
  Future<int> delete(String table, int id) async {
    final db = await database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
