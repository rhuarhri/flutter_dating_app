

import 'dart:io';
//import './ClientModel.dart';
import 'internal/DataModels.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import './internal/database_creation.dart';
import './internal/user_table_manager.dart';
import './internal/description_value_manager.dart';
import './internal/history_manager.dart';

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

      DatabaseCreator creator = DatabaseCreator();
      creator.createInternalDatabase(db);
    });
  }

  //user table code
  AddToUser _addToUser = AddToUser();
  GetFromUser _getFromUser = GetFromUser();
  UpdateToUser _updateToUser = UpdateToUser();

  Future<UserInfo> getUser() async
  {
    final db = await database;
    return _getFromUser.getUser(db);
  }

  addUser(UserInfo user) async
  {
    final db = await database;
    _addToUser.addUser(db, user);
  }

  updateDescriptionStyle(String newStyle) async
  {
    final db = await database;
    _updateToUser.updateUserDescriptionStyle(db, newStyle);
  }


  //description table code
  GetFromDescription _getDescription = GetFromDescription();
  AddToDescription _addToDescription = AddToDescription();
  DeleteFromDescription _deleteFromDescription = DeleteFromDescription();

  Future<List<DescriptionValue>> getDescriptionValues() async
  {
    final db = await database;
    return _getDescription.getAllDescriptionValues(db);

  }

  Future<List<DescriptionValue>> getPositiveDescriptionValue({double freshHold = 1.0}) async
  {
    final db = await database;
    return _getDescription.getPositiveDescriptionValue(db, freshHold: freshHold);

  }

  Future<List<DescriptionValue>> getMustHaveDescriptionValue(double freshHold) async
  {

    final db = await database;

    return _getDescription.getMustHaveDescriptionValue(db, freshHold);

  }

  Future<List<DescriptionValue>> getNegativeDescriptionValue({double freshHold = -1.0}) async
  {

    final db = await database;

    return _getDescription.getNegativeDescriptionValue(db, freshHold: freshHold);

  }

  Future<List<DescriptionValue>> getMustNotHaveDescriptionValue(double freshHold) async
  {
    //get the values that the user really hates and cannot live with.
    final db = await database;
    return _getDescription.getMustNotHaveDescriptionValue(db, freshHold);
  }

  Future<List<DescriptionValue>> getNeutralDescriptionValue() async
  {
    final db = await database;
    return _getDescription.getNeutralDescriptionValue(db);
  }

  addDescriptionValue(DescriptionValue descriptionValue) async
  {
    final db = await database;
    _addToDescription.addDescriptionValue(db, descriptionValue);
  }

  deleteDescriptionValue(String name) async {
    final db = await database;
    _deleteFromDescription.deleteDescriptionValue(db, name);
  }

  //history table code
  AddToHistory _addToHistory = AddToHistory();
  GetFromHistory _getFromHistory = GetFromHistory();
  UpdateToHistory _updateToHistory = UpdateToHistory();
  addHistory(String lastId) async
  {
    final db = await database;
    _addToHistory.addHistory(db, lastId);
  }

  Future<History> getHistory() async
  {
    final db = await database;
    return _getFromHistory.getHistory(db);
  }

  Future<bool> isHistoryEmpty() async
  {
    final db = await database;
    var res = await db.query("History");

    return res.isEmpty;
  }


}