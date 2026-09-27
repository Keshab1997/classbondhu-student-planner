import 'dart:convert';

import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
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

/// Key-value backed store for the web build, where sqflite has no
/// implementation. The payload stays the same versioned JSON snapshot, so the
/// web preview persists exactly what the mobile build writes to SQLite.
class PreferencesAppStorage implements AppStorage {
  PreferencesAppStorage({this.key = 'app_state'});

  final String key;
  Future<SharedPreferences>? _preferences;

  Future<SharedPreferences> get _prefs async => _preferences ??= SharedPreferences.getInstance();

  @override
  Future<Map<String, dynamic>?> load() async {
    final encoded = (await _prefs).getString(key);
    if (encoded == null) return null;
    final decoded = jsonDecode(encoded);
    if (decoded is! Map) return null;
    return Map<String, dynamic>.from(decoded);
  }

  @override
  Future<void> save(Map<String, dynamic> state) async {
    await (await _prefs).setString(key, jsonEncode(state));
  }
}
