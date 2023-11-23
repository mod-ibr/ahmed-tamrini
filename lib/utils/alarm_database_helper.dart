import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/alarm_model.dart';

class AlarmDatabaseHelper {
  static const _databaseName = "alarm_database.db";
  static const _databaseVersion = 5;

  static const table = 'alarms';

  static const columnId = '_id';
  static const columnAlarmName = 'alarmName';
  static const columnAlarmTime = 'alarmTime';
  static const columnIsSwitchedOn = 'isSwitchedOn';
  static const columnWaterQuantity = 'waterQuantity';

  // Make this class a singleton to ensure only one instance of the database
  AlarmDatabaseHelper._privateConstructor();
  static final AlarmDatabaseHelper instance =
      AlarmDatabaseHelper._privateConstructor();

  // The reference to the database
  static Database? _database;

  // Get the database, creating it if necessary
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // Create the alarms table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT , 
        $columnAlarmName TEXT NOT NULL, 
        $columnAlarmTime TEXT NOT NULL, 
        $columnIsSwitchedOn INTEGER NOT NULL, 
        $columnWaterQuantity INTEGER NOT NULL
      )
      ''');
  }

  // Insert an alarm into the database
  Future<int> insert(AlarmModel alarm) async {
    Database db = await instance.database;
    return await db.insert(table, alarm.toMap());
  }

  // Retrieve all alarms from the database
  Future<List<AlarmModel>> getAllAlarms() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(table);
    return maps.map((map) {
      AlarmModel alarm = AlarmModel.fromMap(map);
      return alarm;
    }).toList();
  }

  // Update an alarm by its ID
  Future<int> updateAlarm(AlarmModel alarm) async {
    Database db = await instance.database;
    int id = alarm.id!;
    return await db
        .update(table, alarm.toMap(), where: '$columnId = ?', whereArgs: [id]);
  }

  // Delete an alarm by its ID
  Future<int> deleteAlarm(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  // Update the water quantity for a specific alarm by its ID
  Future<int> updateWaterQuantity(int id, int waterQuantity) async {
    Database db = await instance.database;
    return await db.update(table, {columnWaterQuantity: waterQuantity},
        where: '$columnId = ?', whereArgs: [id]);
  }
}
