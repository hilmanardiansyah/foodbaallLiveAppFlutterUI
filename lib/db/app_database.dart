import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase._();
  static final AppDatabase instance = AppDatabase._();

  Database? _db;

  Future<Database> get database async {
    if (kIsWeb) {
      throw UnsupportedError("SQLite tidak tersedia di Flutter Web");
    }
    _db ??= await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'soccer_live.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE favorites(
            match_id INTEGER PRIMARY KEY,
            home_name TEXT NOT NULL,
            away_name TEXT NOT NULL,
            status TEXT NOT NULL,
            utc_date TEXT NOT NULL,
            home_crest TEXT,
            away_crest TEXT,
            home_score INTEGER,
            away_score INTEGER
          )
        ''');
      },
    );
  }
}
