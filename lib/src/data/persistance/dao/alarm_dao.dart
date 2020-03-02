import 'package:sqflite/sqflite.dart';
import 'package:wishlist/src/data/persistance/app_database.dart';
import 'package:wishlist/src/data/model/alarm_model.dart';

class AlarmDao {
  AppDatabase helper;

  AlarmDao._privateConstructor() {
    helper = AppDatabase.instance;
  }
  static final AlarmDao instance = AlarmDao._privateConstructor();

  Future<int> insertAlarm(AlarmModel alarm) async {
    Database db = await helper.database;
    int id = await db.insert(helper.tableAlarms, alarm.toMap());
    return id;
  }

  Future<int> updateAlarm(AlarmModel alarm) async {
    Database db = await helper.database;
    int id = await db.update(helper.tableAlarms, alarm.toMap(),
        where: '_id = ?', whereArgs: [alarm.id]);
    return id;
  }

  Future<bool> deleteAlarm(int id) async {
    Database db = await helper.database;
    int rows =
        await db.delete(helper.tableAlarms, where: '_id = ?', whereArgs: [id]);
    return rows != 0;
  }

  Future<AlarmModel> queryAlarm(int id) async {
    print(id);
    Database db = await helper.database;
    List<Map> maps = await db.query(helper.tableAlarms,
        columns: ["_id", "_title", "_when", "_alarmEnabled"],
        where: '_id = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return AlarmModel.fromMap(maps.first);
    }
    return null;
  }

  Future<List<AlarmModel>> queryAlarms() async {
    // Get a reference to the database.
    final Database db = await helper.database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps =
        await db.query('${helper.tableAlarms}');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return AlarmModel.fromMap(maps[i]);
    });
  }

  Future<List<int>> queryAlarmIds() async {
    // Get a reference to the database.
    final Database db = await helper.database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps =
        await db.query('${helper.tableAlarms}');
    print(maps);
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return maps[i]['_id'];
    });
  }
}
