import 'package:sqflite/sqflite.dart';

class DatabaseCreator
{

  void createInternalDatabase(Database db) async
  {
    _createUserInfoTable(db);
    _createDescriptionValueTable(db);
    _createHistoryTable(db);
  }

  void _createUserInfoTable(Database db) async
  {
    await db.execute("CREATE TABLE UserInfo (" +
        "id INTEGER PRIMARY KEY AUTOINCREMENT," +
        "online_location TEXT," +
        "age INTEGER," +
        "lookingFor TEXT," +
        "descriptionStyle TEXT," +
        "latitude DOUBLE," +
        "longitude DOUBLE" +
        ")");
  }

  void _createDescriptionValueTable(Database db) async
  {
    await db.execute("CREATE TABLE DescriptionValue (" +
        "id INTEGER PRIMARY KEY AUTOINCREMENT," +
        "name TEXT,"+
        "sentiment DOUBLE" +
        ")");
  }

  void _createHistoryTable(Database db) async
  {
    //this contains the last id of the chunk of data the user is currently looking through

    await db.execute("CREATE TABLE History (" +
        "id INTEGER PRIMARY KEY AUTOINCREMENT," +
        "lastId TEXT)");
  }

}