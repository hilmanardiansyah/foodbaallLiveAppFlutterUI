import 'package:flutter/foundation.dart';
import 'package:foodball_app/db/app_database.dart';
import 'package:foodball_app/model/favorite_match.dart';
import 'package:sqflite/sqflite.dart';

class FavoritesRepository {
 
  final List<FavoriteMatch> _memory = [];

  Future<List<FavoriteMatch>> getAll() async {
    if (kIsWeb) return List.unmodifiable(_memory);

    final db = await AppDatabase.instance.database;
    final rows = await db.query('favorites', orderBy: 'utc_date ASC');
    return rows.map((e) => FavoriteMatch.fromMap(e)).toList();
  }

  Future<void> add(FavoriteMatch fav) async {
    if (kIsWeb) {
      _memory.removeWhere((x) => x.matchId == fav.matchId);
      _memory.add(fav);
      return;
    }

    final db = await AppDatabase.instance.database;
    await db.insert(
      'favorites',
      fav.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> remove(int matchId) async {
    if (kIsWeb) {
      _memory.removeWhere((x) => x.matchId == matchId);
      return;
    }

    final db = await AppDatabase.instance.database;
    await db.delete('favorites', where: 'match_id = ?', whereArgs: [matchId]);
  }
}
