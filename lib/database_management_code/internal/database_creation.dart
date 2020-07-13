import 'package:sqflite/sqflite.dart';

class DatabaseCreator
{

  void createInternalDatabase(Database db) async
  {
    _createUserInfoTable(db);
    _createDescriptionValueTable(db);
    _createHistoryTable(db);
    _createBlockedTable(db);
    _createMatchesTable(db);
    _createMessageAmountTable(db);
  }

  void _createUserInfoTable(Database db) async
  {
    await db.execute("CREATE TABLE UserInfo (" +
        "id INTEGER PRIMARY KEY AUTOINCREMENT," +
        "online_location TEXT," +
        "minAge INTEGER," +
        "maxAge INTEGER," +
        "lookingFor TEXT," +
        "descriptionStyle TEXT," +
        "faceShape TEXT, " +
        "accuracy INTEGER,"
        "distance DOUBLE " +
        ")");
  }

  void _createDescriptionValueTable(Database db) async
  {
    await db.execute("CREATE TABLE DescriptionValue (" +
        "id INTEGER PRIMARY KEY AUTOINCREMENT," +
        "name TEXT, "+
        "sentiment DOUBLE, " +
        "matchable INTEGER, " +
        "interestScore INTEGER "+
        ")");
  }

  void _createHistoryTable(Database db) async
  {
    //this contains the last id of the chunk of data the user is currently looking through

    await db.execute("CREATE TABLE History (" +
        "id INTEGER PRIMARY KEY AUTOINCREMENT," +
        "lastId TEXT)");
  }

  void _createBlockedTable(Database db) async
  {
    db.execute("CREATE TABLE Blocked (" +
        "id INTEGER PRIMARY KEY AUTOINCREMENT," +
        "blockedId TEXT)");
  }

  void _createMatchesTable(Database db)
  {
    db.execute("CREATE TABLE Matched (" +
    "id INTEGER PRIMARY KEY AUTOINCREMENT," +
        "accountId TEXT, " +
        "rating INTEGER, " +
        "isTalkingTo INTEGER, "+
        "name TEXT, "+
        "image TEXT, " +
        "description TEXT " +
    ")"
    );
  }

  void _createMessageAmountTable(Database db)
  {
    db.execute("CREATE TABLE Messages (" +
        "id INTEGER PRIMARY KEY AUTOINCREMENT," +
        "messageAmount INTEGER )"
    );
  }

}