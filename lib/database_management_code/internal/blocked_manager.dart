import 'package:sqflite/sqflite.dart';
import './DataModels.dart';

class AddToBlocked
{
  void add(Database db, String userId)
  {
    Blocked newBlocked = Blocked();
    newBlocked.blockedUserId = userId;

    db.insert("Blocked", newBlocked.toMap());
  }

}

class UpdateToBlocked
{

}

class GetFromBlocked
{

  Future<List<String>> getBlockedList(Database db) async
  {
    var res = await  db.query("Blocked");
    List<Blocked> list =
    res.isNotEmpty ? res.map((B) => Blocked.fromMap(B)).toList() : [];

    List<String> result = [];
    list.forEach((element) {
      result.add(element.blockedUserId);
    });

    return result;
  }

}

class DeleteFromBlocked
{
  deleteBlocked(Database db, String name) async {
    db.delete("Blocked", where: "blockedId = ?", whereArgs: [name]);
  }

  void deleteAll(Database db)
  {
    db.delete("Blocked");
  }
}