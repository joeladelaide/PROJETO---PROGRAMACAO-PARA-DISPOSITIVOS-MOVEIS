import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final pathDB = await getDatabasesPath();
    final dbPath = join(pathDB, 'filmes.db');

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE filmes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT,
            diretor TEXT,
            nota REAL
          )
        ''');
      },
    );
  }

  static Future<int> inserirFilme(Map<String, dynamic> filme) async {
    final db = await database;
    return await db.insert('filmes', filme);
  }

  static Future<List<Map<String, dynamic>>> listarFilmes() async {
    final db = await database;
    return await db.query('filmes');
  }
}
