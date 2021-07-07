import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tasmee3/model/local_teachers_model.dart';
import 'package:tasmee3/model/user_model.dart';

class AdminDatabaseHelper {
  AdminDatabaseHelper._();
  static final AdminDatabaseHelper db = AdminDatabaseHelper._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null)
      return _database;
    else {
      _database = await initDb();
      return _database;
    }
  }

  initDb() async {
    String path = join(await getDatabasesPath(), "UserData.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
      CREATE TABLE users(
         groupName TEXT NOT NULL,
          name TEXT NOT NULL,
          id TEXT NOT NULL,
          username TEXT NOT NULL)
          ''');
    });
  }

  Future<void> insertUser(LocalTeacherModel user) async {
    var dbClient = await database;
    await dbClient.insert('users', user.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  updateUser(LocalTeacherModel user) async {
    var dbClient = await database;
    return await dbClient
        .update('users', user.toJson(), where: 'id =?', whereArgs: [user.id]);
  }

  Future<LocalTeacherModel> getUser(String id) async {
    var dbClient = await database;
    var result = await dbClient.query('users', where: 'id=?', whereArgs: [id]);
    List<LocalTeacherModel> list = result.isNotEmpty
        ? result.map((user) => LocalTeacherModel.fromJson(user)).toList()
        : [];
    return list[0];
  }

  Future<List<LocalTeacherModel>> getAllUsers() async {
    var dbClient = await database;
    List<Map> maps = await dbClient.query('users');
    List<LocalTeacherModel> list = maps.isNotEmpty
        ? maps.map((user) => LocalTeacherModel.fromJson(user)).toList()
        : [];
    return list;
  }

  Future<void> cleanDb() async {
    var dbClient = await database;
    await dbClient.delete('users');
  }
}
