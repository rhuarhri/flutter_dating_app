
import 'package:sqflite/sqflite.dart';
import './DataModels.dart';

class AddToDescription
{

  addDescriptionValue(Database db, DescriptionValue descriptionValue) async
  {
    var res = await db.insert("DescriptionValue", descriptionValue.toMap());
    print("new description value added called " + descriptionValue.name);
    return res;
  }

}

class GetFromDescription
{

  Future<List<DescriptionValue>> getAllDescriptionValues(Database db) async
  {
    var res = await db.query("DescriptionValue");
    List<DescriptionValue> list =
    res.isNotEmpty ? res.map((d) => DescriptionValue.fromMap(d)).toList() : [];
    return list;
  }

  Future<List<DescriptionValue>> getPositiveDescriptionValue(Database db, {double freshHold = 1.0}) async
  {
    //freshHold defaults to 1 which is the highest it can go

    //sentiment is a value show how much people like something
    //if it is greater than zero then they like it if not then they dislike it.

    var res = await  db.query("DescriptionValue", where: "sentiment > 0 AND sentiment < ?", whereArgs: [freshHold]);

    List<DescriptionValue> list =
    res.isNotEmpty ? res.map((d) => DescriptionValue.fromMap(d)).toList() : [];
    return list;
  }

  Future<List<DescriptionValue>> getMustHaveDescriptionValue(Database db, double freshHold) async
  {
    //get the values that the user cannot live without.

    var res = await  db.query("DescriptionValue", where: "sentiment > ?", whereArgs: [freshHold]);

    List<DescriptionValue> list =
    res.isNotEmpty ? res.map((d) => DescriptionValue.fromMap(d)).toList() : [];
    return list;
  }

  Future<List<DescriptionValue>> getNegativeDescriptionValue(Database db, {double freshHold = -1.0}) async
  {
    //freshHold defaults to -1 which is the lowest it can go

    var res =await  db.query("DescriptionValue", where: "sentiment < 0 AND sentiment >= ?", whereArgs:[freshHold]);

    List<DescriptionValue> list =
    res.isNotEmpty ? res.map((d) => DescriptionValue.fromMap(d)).toList() : [];
    return list;
  }

  Future<List<DescriptionValue>> getMustNotHaveDescriptionValue(Database db, double freshHold) async
  {
    //get the values that the user really hates and cannot live with.

    var res = await  db.query("DescriptionValue", where: "sentiment < ?", whereArgs: [freshHold]);

    List<DescriptionValue> list =
    res.isNotEmpty ? res.map((d) => DescriptionValue.fromMap(d)).toList() : [];
    return list;

  }

  Future<List<DescriptionValue>> getNeutralDescriptionValue(Database db) async
  {
    var res =await  db.query("DescriptionValue", where: "sentiment = 0");

    List<DescriptionValue> list =
    res.isNotEmpty ? res.map((d) => DescriptionValue.fromMap(d)).toList() : [];
    return list;
  }


}

class UpdateToDescription
{


}

class DeleteFromDescription
{

  deleteDescriptionValue(Database db, String name) async {
    db.delete("DescriptionValue", where: "name = ?", whereArgs: [name]);
  }
}