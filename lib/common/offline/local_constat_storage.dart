import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalConstatStorage {
  Future<Database> database;

  Future<void> init() async {
    database = openDatabase(
        join(await getDatabasesPath(), 'constat_amiable_database.db'),
        onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE constats(id INTEGER PRIMARY KEY AUTOINCREMENT, a TEXT, b INTEGER)",
      );
    },
    version: 1);
  }

  Future<void> insertConstat(LocalConstat constat) async {
    final Database db = await database;
    await db.insert(
      'constats',
      constat.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteConstat(int id) async {
    final db = await database;
    await db.delete(
      'constats',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<List<LocalConstat>> constats() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('constats');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return LocalConstat(
        id: maps[i]['id'],
        a: maps[i]['a'],
        b: maps[i]['b'],
      );
    });
  }
}

class LocalConstat {
  final int id;
  final String a;
  final String b;

  LocalConstat({this.id, this.a, this.b});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'a': a,
      'b': b,
    };
  }
}
