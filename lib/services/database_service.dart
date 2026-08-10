import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../models/clothing.dart';
import '../models/outfit.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'outfito.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Table des vêtements
    await db.execute('''
      CREATE TABLE clothing(
        id TEXT PRIMARY KEY,
        name TEXT,
        imagePath TEXT,
        category TEXT,
        color TEXT,
        seasons TEXT,
        isAvailable INTEGER,
        isFavorite INTEGER
      )
    ''');

    // Table des tenues
    await db.execute('''
      CREATE TABLE outfits(
        id TEXT PRIMARY KEY,
        name TEXT,
        clothingIds TEXT,
        occasion TEXT,
        isFavorite INTEGER,
        dateCreated TEXT
      )
    ''');
  }

  // ========== VÊTEMENTS ==========

  Future<void> insertClothing(Clothing clothing) async {
    final db = await database;
    await db.insert(
      'clothing',
      clothing.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Clothing>> getAllClothing() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('clothing');
    return List.generate(maps.length, (i) => Clothing.fromMap(maps[i]));
  }

  Future<void> deleteClothing(String id) async {
    final db = await database;
    await db.delete('clothing', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateClothing(Clothing clothing) async {
    final db = await database;
    await db.update(
      'clothing',
      clothing.toMap(),
      where: 'id = ?',
      whereArgs: [clothing.id],
    );
  }

  // ========== TENUES ==========

  Future<void> insertOutfit(Outfit outfit) async {
    final db = await database;
    await db.insert(
      'outfits',
      outfit.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Outfit>> getAllOutfits() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('outfits');
    return List.generate(maps.length, (i) => Outfit.fromMap(maps[i]));
  }

  Future<void> deleteOutfit(String id) async {
    final db = await database;
    await db.delete('outfits', where: 'id = ?', whereArgs: [id]);
  }
}
