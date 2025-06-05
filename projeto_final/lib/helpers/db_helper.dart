import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;

  DBHelper._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'filmes.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE filmes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT,
            genero TEXT,
            ano INTEGER,
            classificacao TEXT,
            imagem TEXT,
            nota DOUBLE
          )
        ''');
      },
    );
  }

  Future<int> inserirFilme(Map<String, dynamic> filme) async {
    final db = await database;
    return await db.insert('filmes', filme);
  }

  Future<List<Map<String, dynamic>>> listarFilmes() async {
    final db = await database;
    return await db.query('filmes');
  }

  Future<int> deletarFilme(int id) async {
    final db = await database;
    return await db.delete('filmes', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> atualizarFilme(Map<String, dynamic> filme) async {
    final db = await database;
    return await db.update('filmes', filme, where: 'id = ?', whereArgs: [filme['id']]);
  }
}

