import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

import 'package:user_data/user.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String userTable = 'user_table';
  String colId = 'id';
  String colFirstName = 'firstName';
  String colLastName = 'lastName';
  String colEmail = 'email';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDB();
    }
    return _database;
  }

  Future<Database> initDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'users.db';

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  void _createDB(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $userTable ($colId INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$colFirstName TEXT, $colLastName TEXT, $colEmail TEXT)');
  }

  //Fetch all User from Database
  Future<List<User>> getUserList() async {
    Database db = await this.database;

    var result = await db.query(userTable);

    //Convert to List Object
    int count = result.length;
    List<User> userList = List<User>();
    for (int i = 0; i < count; i++) {
      userList.add(User.fromMap(result[i]));
    }

    return userList;
  }

  //Insert into Database
  Future<int> insertUser(User user) async {
    Database db = await this.database;
    var result = db.insert(userTable, user.toMap());
    return result;
  }

  //Delete User from Database
  Future<int> deleteUser(int id) async {
    Database db = await this.database;
    var result = db.rawDelete('DELETE FROM $userTable WHERE $colId = $id');
    return result;
  }
}
