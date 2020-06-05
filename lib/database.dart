

import 'dart:io';
//import './ClientModel.dart';
import './DataModels.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider
{

  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null)
      return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async
  {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = "" + documentsDirectory.path + "appDB.db";
    return await openDatabase(path, version: 1, onOpen: (db) {
    }, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE UserInfo (" +
          "id INTEGER PRIMARY KEY AUTOINCREMENT," +
          "online_location TEXT," +
          "age INTEGER," +
          "lookingFor TEXT" +
          ")");


      await db.execute("CREATE TABLE DescriptionValue (" +
          "id INTEGER PRIMARY KEY AUTOINCREMENT," +
          "name TEXT,"+
          "sentiment DOUBLE" +
          ")");

    });
  }

  Future<List<UserInfo>> getUser() async
  {
    final db = await database;
    var res =await  db.query("UserInfo");
    List<UserInfo> list =
    res.isNotEmpty ? res.map((I) => UserInfo.fromMap(I)).toList() : [];
    return list;
  }

  addUser(UserInfo user) async
  {
    final db = await database;
    var res = await db.insert("UserInfo", user.toMap());
    return res;
  }

  Future<List<DescriptionValue>> getDescriptionValues() async
  {
    final db = await database;
    var res = await db.query("DescriptionValue");
    List<DescriptionValue> list =
    res.isNotEmpty ? res.map((d) => DescriptionValue.fromMap(d)).toList() : [];
    return list;
  }

  Future<List<DescriptionValue>> getPositiveDescriptionValue() async
  {
    //sentiment is a value show how much people like something
    //if it is greater than zero then they like it if not then they dislike it.

    final db = await database;

    var res =await  db.query("DescriptionValue", where: "sentiment > 0");

    List<DescriptionValue> list =
    res.isNotEmpty ? res.map((d) => DescriptionValue.fromMap(d)).toList() : [];
    return list;
  }

  Future<List<DescriptionValue>> getNegativeDescriptionValue() async
  {
    final db = await database;

    var res =await  db.query("DescriptionValue", where: "sentiment < 0");

    List<DescriptionValue> list =
    res.isNotEmpty ? res.map((d) => DescriptionValue.fromMap(d)).toList() : [];
    return list;
  }

  addDescriptionValue(DescriptionValue descriptionValue) async
  {
    final db = await database;
    var res = await db.insert("DescriptionValue", descriptionValue.toMap());
    return res;
  }

  deleteDescriptionValue(String name) async {
    final db = await database;
    db.delete("DescriptionValue", where: "name = ?", whereArgs: [name]);
  }

  /*
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = "" + documentsDirectory.path + "TestDB.db";
    return await openDatabase(path, version: 1, onOpen: (db) {
    }, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Client ("
          "id INTEGER PRIMARY KEY,"
          "first_name TEXT,"
          "last_name TEXT,"
          "blocked BIT"
          ")");
    });
  }

  getClient(int id) async {

    final db = await database;
    var res =await  db.query("Client", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Client.fromMap(res.first) : Null ;
  }

  newClient(Client newClient) async {
    final db = await database;
    var res = await db.insert("Client", newClient.toMap());
    return res;
  }*/

}