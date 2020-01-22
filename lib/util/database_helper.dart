import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wishlist/src/datamodels/alarm_model.dart';

class DatabaseHelper {
  static final _databaseName = "MyDatabase.db";
  final String tableAlarms = 'alarms';
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tableAlarms (
                _id INTEGER PRIMARY KEY,
                _title TEXT NOT NULL,
                _when INTEGER NOT NULL
              )
              ''');
  }

  // Database helper methods:

  Future<int> insert(AlarmModel alarm) async {
    Database db = await database;
    int id = await db.insert(tableAlarms, alarm.toMap());
    return id;
  }

  Future<AlarmModel> queryAlarm(int id) async {
    print(id);
    Database db = await database;
    List<Map> maps = await db.query(tableAlarms,
        columns: ["_id", "_title", "_when"], where: '_id = ?', whereArgs: [id]);
    if (maps.length > 0) {
      return AlarmModel.fromMap(maps.first);
    }
    return null;
  }
}
