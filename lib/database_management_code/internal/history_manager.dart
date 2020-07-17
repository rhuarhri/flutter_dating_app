import 'package:sqflite/sqflite.dart';
import './DataModels.dart';

class AddToHistory
{
  addHistory(Database db, String lastId) async
  {
    History newHistory = History();
    newHistory.lastID = lastId;

    var res = await db.query("History");
    List<History> foundHistory =
    res.isNotEmpty ? res.map((h) => History.fromMap(h)).toList() : [];

    if (foundHistory.isEmpty == true)
    {
      await db.insert("History", newHistory.toMap());
    }
    else
    {
      newHistory = foundHistory[0];
      newHistory.lastID = lastId;
      await db.update("History", newHistory.toMap());
    }

    return res;

  }
}

class GetFromHistory
{

  Future<History> getHistory(Database db) async
  {
    History emptyHistory = History();
    emptyHistory.lastID = "";
    emptyHistory.id = 0;

    var res = await db.query("History");
    History foundHistory =
    res.isNotEmpty ? res.map((h) => History.fromMap(h)).toList()[0] : emptyHistory;

    return foundHistory;
  }

}

class UpdateToHistory
{

  updateHistory(Database db, String lastId)
  {
    History newHistory = History();
    newHistory.lastID = lastId;
    newHistory.id = 0;

    db.update("History", newHistory.toMap(), where: "id = ?", whereArgs: [newHistory.id]);
  }

}

class DeleteFromHistory
{
  void deleteAll(Database db)
  {
    db.delete("History");
  }
}