import 'dart:io';
import 'package:flutterdatingapp/database_management_code/internal/blocked_manager.dart';
import 'package:flutterdatingapp/database_management_code/internal/category_manager.dart';
import 'package:flutterdatingapp/database_management_code/internal/matches_table_manager.dart';
import 'package:flutterdatingapp/database_management_code/internal/messages_table_manager.dart';

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

  Future<bool> isDatabaseEmpty() async
  {
    final db = await database;
    var res = await  db.query("UserInfo");
    List<UserInfo> list =
    res.isNotEmpty ? res.map((I) => UserInfo.fromMap(I)).toList() : [];

    if (list.isEmpty == true)
      {
        return true;
      }
    else
      {
        return false;
      }
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
    //this ensures the user will not get themselves
    addBlockedUser(user.onlineLocation);
  }

  updateUser(UserInfo user) async
  {
    final db = await database;
    _updateToUser.updateUser(db, user);
  }

  updateFaceShape(String faceShape) async
  {
    final db = await database;
    _updateToUser.updateUserFaceShape(db, faceShape);
  }

  updateDescriptionStyle(String newStyle) async
  {
    final db = await database;
    _updateToUser.updateUserDescriptionStyle(db, newStyle);
  }

  void updateAgeRange(int minAge, int maxAge) async
  {
    final db = await database;

    _updateToUser.updateUserAgeRange(db, minAge, maxAge);
  }

  void updateDistance(double distance) async
  {
    final db = await database;
    _updateToUser.updateUserDistance(db, distance);
  }

  void updateAccuracy(int accuracy) async
  {
    final db = await database;
    _updateToUser.updateUserAccuracy(db, accuracy);
  }


  //description table code
  GetFromDescription _getDescription = GetFromDescription();
  AddToDescription _addToDescription = AddToDescription();
  UpdateToDescription _updateToDescription = UpdateToDescription();
  DeleteFromDescription _deleteFromDescription = DeleteFromDescription();

  void updateDescriptionValue(DescriptionValue newDescriptionValue) async
  {
    final db = await database;
    _updateToDescription.updateDescriptionValue(db, newDescriptionValue.name);
  }

  void updateDescriptionValueInterestScore(String name) async
  {
    final db = await database;
    _updateToDescription.updateDescriptionValueInterestScore(db, name);
  }

  void updateDescriptionValueSentiment(String name, double newSentiment) async
  {
    final db = await database;
    _updateToDescription.updateDescriptionValueSentimentScore(db, name, newSentiment);
  }

  Future<List<DescriptionValue>> getDescriptionValues() async
  {
    final db = await database;
    return _getDescription.getAllDescriptionValues(db);

  }

  Future<DescriptionValue> getOneDescriptionValue(String name) async
  {
    final db = await database;
    return _getDescription.getDescriptionValue(db, name);
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

  userAddDescriptionValue(DescriptionValue descriptionValue) async
  {
    final db = await database;
    _addToDescription.userAddDescriptionValue(db, descriptionValue);
  }

  appAddDescription(String name, bool isLiked) async
  {
    final db = await database;
    _addToDescription.appAddDescriptionValue(db, name, isLiked);
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

  AddToBlocked _addBlocked = AddToBlocked();
  GetFromBlocked _getBlocked = GetFromBlocked();
  DeleteFromBlocked _deleteFromBlocked = DeleteFromBlocked();
  void addBlockedUser(String userId) async
  {
    final db = await database;
    _addBlocked.add(db, userId);
  }

  Future<List<String>> getBlockedUser() async
  {
    final db = await database;
    return _getBlocked.getBlockedList(db);
  }

  void deleteBlocked(String accountId) async
  {
    final db = await database;
    _deleteFromBlocked.deleteBlocked(db, accountId);
  }

  AddToMatched _addToMatched = AddToMatched();
  GetFromMatched _getFromMatched = GetFromMatched();
  DeleteFromMatched _deleteFromMatched = DeleteFromMatched();
  UpdateToMatched _updateToMatched = UpdateToMatched();


  void addMatched(String accountId, int rating, String name, String image, String description) async
  {
    final db = await database;

    _addToMatched.addMatched(db, accountId, rating, name, image, description);

  }

  Future<List<Matched>> getMatched() async
  {
    final db = await database;
    return _getFromMatched.getAll(db);
  }

  void updateIsTalkingTo(String accountId, isTalkingTo) async
  {
    final db = await database;
    _updateToMatched.setIsTalkingValue(db, accountId, isTalkingTo);
  }

  void deleteMatched(String id) async
  {
    final db = await database;
    _deleteFromMatched.deleteMatched(db, id);
  }

  GetFromMessages _getFromMessages = GetFromMessages();
  UpdateToMessages _updateToMessages = UpdateToMessages();
  AddToMessages _addToMessages = AddToMessages();

  Future<void> setupMessages() async
  {
    final db = await database;
    _addToMessages.addNewMessagesValue(db);
  }

  void oneMessageSent() async
  {
    final db = await database;
    _updateToMessages.oneMessageSent(db);
  }

  void updateMessageAmount(int additionalMessages) async
  {
    final db = await database;
    _updateToMessages.addMessages(db, additionalMessages);
  }

  Future<bool> canSendMessage() async
  {
    final db = await database;
    return _getFromMessages.canSendMessage(db);
  }

  Future<int> getMessageAmount() async
  {
    final db = await database;
    return _getFromMessages.getCurrentMessageAmount(db);
  }

  GetFromCategories _getFromCategories = GetFromCategories();
  AddToCategories _addToCategories = AddToCategories();
  UpdateFromCategories _updateFromCategories = UpdateFromCategories();

  void addCategories(List<String> userCategories) async
  {
    final db = await database;
    _addToCategories.addCategories(db, userCategories);
  }

  Future<List<String>> getAllCategories() async
  {
    final db = await database;
    return _getFromCategories.getAllCategories(db);
  }

  //delete all information
  //might not need below function as all info is deleted once uninstalled
  /*void deleteAll() async
  {
    final db = await database;
    DeleteFromHistory deleteHistory = DeleteFromHistory();
    deleteHistory.deleteAll(db);
    DeleteFromUser deleteFromUser = DeleteFromUser();
    deleteFromUser.deleteUser(db);
    DeleteFromDescription deleteFromDescription = DeleteFromDescription();
    deleteFromDescription.deleteAll(db);
    DeleteFromBlocked deleteFromBlocked = DeleteFromBlocked();
    deleteFromBlocked.deleteAll(db);
    DeleteFromMatched deleteFromMatched = DeleteFromMatched();
    deleteFromMatched.deleteAll(db);

  }*/

}