import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/candi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Untuk Web platform
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
      return await openDatabase(
        'wisata_candi.db',
        version: 1,
        onCreate: _onCreate,
      );
    }

    if (io.Platform.isWindows || io.Platform.isLinux || io.Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      final appDocumentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(appDocumentsDirectory.path, 'wisata_candi.db');
      print('📁 Database location (Desktop): $path');
      return await openDatabase(path, version: 1, onCreate: _onCreate);
    }

    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'wisata_candi.db');
    print('📁 Database location (Mobile): $path');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE candi (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      location TEXT NOT NULL,
      description TEXT NOT NULL,
      built TEXT NOT NULL,
      type TEXT NOT NULL,
      imageAsset TEXT NOT NULL,
      imageUrls TEXT NOT NULL,
      isFavorite INTEGER NOT NULL DEFAULT 0
    )
  ''');
  }

  // Insert single record
  Future<int> insertCandi(Candi candi) async {
    final db = await database;
    return await db.insert('candi', candi.toMap());
  }

  // Insert batch (untuk migrasi data)
  Future<void> insertCandiList(List<Candi> candiList) async {
    final db = await database;
    Batch batch = db.batch();
    for (var candi in candiList) {
      batch.insert('candi', candi.toMap());
    }
    await batch.commit(noResult: true);
  }

  // Get all
  Future<List<Candi>> getAllCandi() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('candi');
    return List.generate(maps.length, (i) {
      return Candi.fromMap(maps[i]);
    });
  }

  // Get by ID
  Future<Candi?> getCandiById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'candi',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return Candi.fromMap(maps[0]);
  }

  // Get favorites
  Future<List<Candi>> getFavoriteCandi() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'candi',
      where: 'isFavorite = ?',
      whereArgs: [1],
    );
    return List.generate(maps.length, (i) {
      return Candi.fromMap(maps[i]);
    });
  }

  // Update full record
  Future<int> updateCandi(Candi candi) async {
    final db = await database;
    return await db.update(
      'candi',
      candi.toMap(),
      where: 'id = ?',
      whereArgs: [candi.id],
    );
  }

  // Toggle favorite
  Future<int> toggleFavorite(int id, bool isFavorite) async {
    final db = await database;
    return await db.update(
      'candi',
      {'isFavorite': isFavorite ? 0 : 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Update specific fields
  Future<int> updateCandiField(int id, Map<String, dynamic> data) async {
    final db = await database;
    return await db.update('candi', data, where: 'id = ?', whereArgs: [id]);
  }

  // Delete by ID
  Future<int> deleteCandi(int id) async {
    final db = await database;
    return await db.delete('candi', where: 'id = ?', whereArgs: [id]);
  }

  // Delete all
  Future<int> deleteAllCandi() async {
    final db = await database;
    return await db.delete('candi');
  }

  Future<List<Candi>> searchCandi(String keyword) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'candi',
      where: 'name LIKE ? OR location LIKE ?',
      whereArgs: ['%$keyword%', '%$keyword%'],
    );
    return List.generate(maps.length, (i) {
      return Candi.fromMap(maps[i]);
    });
  }

  // Check if database empty
  Future<bool> isDatabaseEmpty() async {
    final db = await database;
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM candi'),
    );
    return count == 0;
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
