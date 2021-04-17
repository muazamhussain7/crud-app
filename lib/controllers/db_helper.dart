import 'dart:async';
import 'dart:io' as io;

import 'package:flutter/material.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import '../models/employee.dart';

class DBHelper with ChangeNotifier {
  static Database _db;
  static const String ID = 'id';
  static const String NAME = 'name';
  static const String TABLE = 'Employee';
  static const String DB_NAME = 'employee1.db';

  var _isUpdating = false;

  void setIsUpdating(bool isUpdating) {
    _isUpdating = isUpdating;
    notifyListeners();
  }

  bool get getIsUpdating {
    return _isUpdating;
  }

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db
        .execute("CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $NAME TEXT)");
  }

  Future<void> save(Employee employee) async {
    var dbClient = await db;
    employee.id = await dbClient.insert(TABLE, employee.toMap());
    notifyListeners();
  }

  Future<List<Employee>> getEmployees() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE, columns: [ID, NAME]);
    List<Employee> employees = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        employees.add(Employee.fromMap(maps[i]));
      }
    }
    return employees;
  }

  Future<void> delete(int id) async {
    var dbClient = await db;
    await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
    notifyListeners();
  }

  Future<void> update(Employee employee) async {
    var dbClient = await db;
    await dbClient.update(
      TABLE,
      employee.toMap(),
      where: '$ID = ?',
      whereArgs: [employee.id],
    );
    notifyListeners();
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
