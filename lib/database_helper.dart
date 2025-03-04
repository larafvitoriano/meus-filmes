import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'movie.dart';
import 'movie_contract.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String? databasesPath = await getDatabasesPath();
    databasesPath ??= "";
    String path = join(databasesPath, "movies.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int newerVersion) async {
        await db.execute(
          "CREATE TABLE ${MovieContract.movieTable}(${MovieContract.idColumn} INTEGER PRIMARY KEY AUTOINCREMENT, "
          " ${MovieContract.titleColumn} TEXT, "
          " ${MovieContract.directorColumn} TEXT, "
          " ${MovieContract.yearColumn} INTEGER, "
          " ${MovieContract.synopsisColumn} TEXT, "
          " ${MovieContract.ratingColumn} REAL, "
          " ${MovieContract.posterUrlColumn} TEXT)",
        );
      },
    );
  }

  Future<int> insertMovie(Movie movie) async {
    final db = await database;
    return db.insert(MovieContract.movieTable, movie.toMap());
  }

  Future<List<Movie>> getMovies() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      MovieContract.movieTable,
    );
    return List.generate(maps.length, (i) {
      return Movie.fromMap(maps[i]);
    });
  }

  Future<int> updateMovie(Movie movie) async {
    final db = await database;
    return db.update(
      MovieContract.movieTable,
      movie.toMap(),
      where: '${MovieContract.idColumn} = ?',
      whereArgs: [movie.id],
    );
  }

  Future<int> deleteMovie(int id) async {
    final db = await database;
    return db.delete(
      MovieContract.movieTable,
      where: '${MovieContract.idColumn} = ?',
      whereArgs: [id],
    );
  }
}
