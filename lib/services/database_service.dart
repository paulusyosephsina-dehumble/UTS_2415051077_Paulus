import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../models/saved_kos_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;
  static const String tableName = 'saved_kos';
  static const String dbName = 'kosfinder_database.db';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Inisialisasi sqflite ffi jika berjalan di platform Desktop (Windows/Linux/macOS)
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, dbName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        student_id TEXT NOT NULL,
        kos_id INTEGER NOT NULL,
        kos_name TEXT NOT NULL,
        address TEXT NOT NULL,
        price INTEGER NOT NULL,
        type TEXT NOT NULL,
        note TEXT NOT NULL,
        rating REAL NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    // Tambahkan data awal dummy untuk simulasi testing jika kosong
    await db.insert(tableName, {
      'student_id': '2415051077',
      'kos_id': 1,
      'kos_name': 'Kos Singaraja Asri',
      'address': 'Jl. Udayana No. 12, Singaraja, Bali',
      'price': 750000,
      'type': 'Campur',
      'note': 'Sangat dekat dengan kampus Undiksha, pemilik ramah.',
      'rating': 5.0,
      'created_at': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
    });
  }

  /// Create: Menambahkan kos ke daftar tersimpan
  Future<int> insertSavedKos(SavedKosModel item) async {
    final db = await database;
    return await db.insert(
      tableName,
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Read: Mengambil seluruh kos tersimpan
  Future<List<SavedKosModel>> getAllSavedKos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      orderBy: 'id DESC',
    );
    return maps.map((map) => SavedKosModel.fromMap(map)).toList();
  }

  /// Update: Memperbarui data catatan atau rating kos tersimpan
  Future<int> updateSavedKos(SavedKosModel item) async {
    final db = await database;
    if (item.id == null) return 0;
    return await db.update(
      tableName,
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  /// Delete: Menghapus data kos tersimpan berdasarkan ID
  Future<int> deleteSavedKos(int id) async {
    final db = await database;
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Cek apakah kos dengan kos_id tertentu sudah tersimpan
  Future<bool> isKosSaved(int kosId) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      tableName,
      where: 'kos_id = ?',
      whereArgs: [kosId],
      limit: 1,
    );
    return result.isNotEmpty;
  }
}
