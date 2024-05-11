import 'package:flutter_translate_app/src/data/models/favourite.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/History.dart';

class TranslateDataBase {
  /// class instance
  static final TranslateDataBase instance = TranslateDataBase._init();

  /// database instance
  static Database? _database;

  TranslateDataBase._init();

  /// get database
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDb('translate.db');
      return _database!;
    }
  }

  /// init database
  Future<Database> _initDb(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  /// create database
  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL';
    const notNull = 'NOT NULL';

    /// create history table
    await db.execute('''
    CREATE TABLE ${HistoryFields.tableHistory} (
      ${HistoryFields.id} $idType,
      ${HistoryFields.timestamp} INTEGER $notNull,
      ${HistoryFields.originalText} TEXT $notNull,
      ${HistoryFields.translationText} TEXT $notNull,
      ${HistoryFields.originalTextCode} TEXT $notNull,
      ${HistoryFields.translationTextCode} TEXT $notNull,
      ${HistoryFields.isFavorite} TEXT $notNull
    )
    ''');

    await db.execute('''
    CREATE TABLE ${FavouriteFields.tableFavourite} (
      ${FavouriteFields.id} $idType,
      ${FavouriteFields.historyId} INTEGER $notNull,
      ${FavouriteFields.timestamp} INTEGER $notNull,
      ${FavouriteFields.originalText} TEXT $notNull,
      ${FavouriteFields.translationText} TEXT $notNull,
      ${FavouriteFields.originalTextCode} TEXT $notNull,
      ${FavouriteFields.translationTextCode} TEXT $notNull,
      ${FavouriteFields.isFavorite} TEXT $notNull
    )
    ''');
  }

  /// insert
  Future<History> insertHistory(History history) async {
    final db = await instance.database;
    final id = await db.insert(HistoryFields.tableHistory, history.toJson());
    return history.copy(id: id);
  }

  Future<Favourite> insertFavourite(Favourite favourite) async {
    final db = await instance.database;
    final id =
        await db.insert(FavouriteFields.tableFavourite, favourite.toJson());
    return favourite.copy(id: id);
  }

  /// get all data
  Future<List<History>> readHistory() async {
    final db = await instance.database;

    const orderBy = '${HistoryFields.timestamp} ASC';
    final res = await db.query(HistoryFields.tableHistory, orderBy: orderBy);
    return res.map((data) => History.fromJson(data)).toList();
  }

  Future<List<Favourite>> readFavourite() async {
    final db = await instance.database;

    const orderBy = '${FavouriteFields.timestamp} ASC';
    final res =
        await db.query(FavouriteFields.tableFavourite, orderBy: orderBy);
    return res.map((data) => Favourite.fromJson(data)).toList();
  }

  Future<bool> getSingleHistory(int id) async {
    final db = await instance.database;
    final res = await db.rawQuery(
        'SELECT * FROM ${HistoryFields.tableHistory} WHERE _id = $id');
    if (res.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  /// update isFavorite field
  Future<int> updateHistory(History history) async {
    final db = await instance.database;

    return db.update(HistoryFields.tableHistory, history.toJson(),
        where: '${HistoryFields.id} = ?', whereArgs: [history.id]);
  }

  /// delete a single element
  Future<int> deleteHistoryField(int? id) async {
    final db = await instance.database;
    return db.delete(HistoryFields.tableHistory,
        where: '${HistoryFields.id} = ?', whereArgs: [id]);
  }

  Future<int> deleteFavouriteFieldHistoryId(int? id) async {
    final db = await instance.database;
    return db.delete(FavouriteFields.tableFavourite,
        where: '${FavouriteFields.historyId} = ?', whereArgs: [id]);
  }

  Future<int> deleteFavouriteField(int? id) async {
    final db = await instance.database;
    return db.delete(FavouriteFields.tableFavourite,
        where: '${FavouriteFields.id} = ?', whereArgs: [id]);
  }

  /// delete all data (history)
  Future<int> deleteAllHistory() async {
    final db = await instance.database;

    return db.rawDelete('DELETE FROM ${HistoryFields.tableHistory}');
  }

  /// close database connection
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
