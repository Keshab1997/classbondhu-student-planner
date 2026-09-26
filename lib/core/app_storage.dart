import 'dart:convert';

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

abstract interface class AppStorage {
  Future<Map<String, dynamic>?> load();
  Future<void> save(Map<String, dynamic> state);
}

/// SQLite-backed local store. The JSON payload is versioned by the controller;
/// a single upsert keeps each user action atomic while the model is still small.
class SqliteAppStorage implements AppStorage {
  SqliteAppStorage({this.databaseName = 'classbondhu.db'});

  final String databaseName;
  Database? _database;

  Future<Database> get _db async {
    if (_database != null) return _database!;
    final basePath = await getDatabasesPath();
    final database = await openDatabase(
      p.join(basePath, databaseName),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE app_state (
            id INTEGER PRIMARY KEY CHECK (id = 1),
            payload TEXT NOT NULL
          )
        ''');
      },
    );
    _database = database;
    return database;
  }

  @override
  Future<Map<String, dynamic>?> load() async {
    final rows = await (await _db).query('app_state', where: 'id = ?', whereArgs: [1], limit: 1);
    if (rows.isEmpty) return null;
    final decoded = jsonDecode(rows.first['payload']! as String);
    if (decoded is! Map) return null;
    return Map<String, dynamic>.from(decoded);
  }

  @override
  Future<void> save(Map<String, dynamic> state) async {
    await (await _db).insert(
      'app_state',
      {'id': 1, 'payload': jsonEncode(state)},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> close() async {
    final database = _database;
    if (database != null) {
      await database.close();
      _database = null;
    }
  }
}

/// Lightweight in-memory store for widget tests and isolated previews.
class MemoryAppStorage implements AppStorage {
  Map<String, dynamic>? _state;

  @override
  Future<Map<String, dynamic>?> load() async {
    final state = _state;
    if (state == null) return null;
    return Map<String, dynamic>.from(jsonDecode(jsonEncode(state)) as Map);
  }

  @override
  Future<void> save(Map<String, dynamic> state) async {
    _state = Map<String, dynamic>.from(jsonDecode(jsonEncode(state)) as Map);
  }
}
