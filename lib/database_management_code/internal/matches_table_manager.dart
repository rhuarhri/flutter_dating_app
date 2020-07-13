import 'package:sqflite/sqflite.dart';
import './DataModels.dart';

class AddToMatched
{

  void addMatched(Database db, String id, int rating, String name, String image, String description) async
  {
    Matched newMatched = Matched();
    newMatched.accountId = id;
    newMatched.rating = rating;
    newMatched.isTalkingTo = 0;
    newMatched.name = name;
    newMatched.imageLocation = image;
    newMatched.description = description;

    db.insert("Matched", newMatched.toMap());

  }
}

class UpdateToMatched
{
  setIsTalkingValue(Database db, String accountId, bool isTalkingTo) async
  {
    Matched updatedValue = await GetFromMatched().getMatched(db, accountId);
    if (isTalkingTo == true)
      {
        updatedValue.isTalkingTo = 1;
      }
    else
      {
        updatedValue.isTalkingTo = 0;
      }

    db.update("DescriptionValue", updatedValue.toMap(), where: "id = ?", whereArgs: [updatedValue.id]);
  }

}

class GetFromMatched
{
  Future<List<Matched>> getAll(Database db) async
  {
    var res = await db.query("Matched", orderBy: "rating DESC");
    List<Matched> list =
    res.isNotEmpty ? res.map((m) => Matched.fromMap(m)).toList() : [];
    return list;
  }

  Future<Matched> getMatched(Database db, String accountId) async
  {
    var res = await db.query("Matched", where: "accountId = ?", whereArgs: [accountId]);
    List<Matched> list =
    res.isNotEmpty ? res.map((m) => Matched.fromMap(m)).toList() : [];

    return list[0];
  }

}

class DeleteFromMatched
{

  void deleteMatched(Database db, String accountId)
  {
    db.delete("Matched", where: "accountId = ?", whereArgs: [accountId]);
  }

  void deleteAll(Database db)
  {
    db.delete("Matched");
  }

}