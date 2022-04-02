
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
  Future<Database> get database async{
    if(_database != null) {
      return _database!;
    } else{
      _database = await _initDb('translate.db');
      return _database!;
    }
  }

  /// init database
  Future<Database> _initDb(String filePath) async{
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  /// create database
  Future _createDB(Database db, int version) async{
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const notNull = 'NOT NULL';
    /// create history table
    await db.execute('''
    CREATE TABLE ${HistoryFields.tableHistory} (
      ${HistoryFields.id} $idType,
      ${HistoryFields.timestamp} integer $notNull,
      ${HistoryFields.originalText} text $notNull,
      ${HistoryFields.translationText} text $notNull,
      ${HistoryFields.originalTextCode} text $notNull,
      ${HistoryFields.translationTextCode} text $notNull,
      ${HistoryFields.isFavorite} boolean $notNull
    );
    ''');
  }

  /// create

  /// close database connection
  Future close() async{
    final db = await instance.database;
    db.close();
  }
}