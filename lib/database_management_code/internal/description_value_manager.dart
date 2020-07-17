
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite/sqflite.dart';
import '../online_database.dart';
import './DataModels.dart';

int searchFreshHold = 5;

class AddToDescription
{

  _addDescriptionValue(Database db, DescriptionValue descriptionValue) async
  {
    var res = await db.insert("DescriptionValue", descriptionValue.toMap());
    print("new description value added called " + descriptionValue.name);
    return res;
  }

  void userAddDescriptionValue(Database db, DescriptionValue newDescriptionValue) async
  {
    //added through the description analysis or through the description screen
    newDescriptionValue.interestScore = searchFreshHold;
    newDescriptionValue.matchable = 0;
    await _addDescriptionValue(db, newDescriptionValue);

    bool isLiked = newDescriptionValue.sentiment > 0 ? true : false;

    //check that what the user has added can be matched in the online database
    _MatchHandler().checkForMatches(db, newDescriptionValue, isLiked);
  }

  void appAddDescriptionValue(Database db, String name, bool isLiked) async
  {
    DescriptionValue newDescriptionValue = DescriptionValue();

    newDescriptionValue = await GetFromDescription().getDescriptionValue(db, name);

    if (newDescriptionValue.name == "") {
      //add it to the data base
      newDescriptionValue.name = name;
      if (isLiked == true) {
        newDescriptionValue.sentiment = 0.4;
      }
      else {
        newDescriptionValue.sentiment = -0.4;
      }
      newDescriptionValue.matchable = 1;
      newDescriptionValue.interestScore = 1;
      await _addDescriptionValue(db, newDescriptionValue);

      //_MatchHandler().checkForMatches(db, newDescriptionValue, isLiked);
    }
    else
      {
        UpdateToDescription().updateDescriptionValueInterestScore(db, name);
      }
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

    var res = await
    db.query("DescriptionValue", where: "sentiment > 0 AND sentiment < ? AND interestScore = ?",
        whereArgs: [freshHold, searchFreshHold], orderBy: "interestScore DESC", limit: 10);

    List<DescriptionValue> list =
    res.isNotEmpty ? res.map((d) => DescriptionValue.fromMap(d)).toList() : [];
    return list;
  }

  Future<List<DescriptionValue>> getMustHaveDescriptionValue(Database db, double freshHold) async
  {

    //get the values that the user cannot live without.

    var res = await  db.query("DescriptionValue", where: "sentiment > ?",
        whereArgs: [freshHold]);

    List<DescriptionValue> list =
    res.isNotEmpty ? res.map((d) => DescriptionValue.fromMap(d)).toList() : [];
    return list;
  }

  Future<List<DescriptionValue>> getNegativeDescriptionValue(Database db, {double freshHold = -1.0}) async
  {

    //freshHold defaults to -1 which is the lowest it can go

    var res =await  db.query("DescriptionValue", where: "sentiment < 0 AND sentiment >= ? AND interestScore = ? ",
        whereArgs:[freshHold, searchFreshHold], orderBy: "interestScore DESC", limit: 10);

    List<DescriptionValue> list =
    res.isNotEmpty ? res.map((d) => DescriptionValue.fromMap(d)).toList() : [];
    return list;
  }

  Future<List<DescriptionValue>> getMustNotHaveDescriptionValue(Database db, double freshHold) async
  {

    //get the values that the user really hates and cannot live with.

    var res = await  db.query("DescriptionValue", where: "sentiment < ? ",
        whereArgs: [freshHold]);

    List<DescriptionValue> list =
    res.isNotEmpty ? res.map((d) => DescriptionValue.fromMap(d)).toList() : [];
    return list;

  }

  Future<List<DescriptionValue>> getNeutralDescriptionValue(Database db) async
  {

    var res =await  db.query("DescriptionValue", where: "sentiment = 0 AND interestScore = ? ",
        whereArgs: [searchFreshHold]);

    List<DescriptionValue> list =
    res.isNotEmpty ? res.map((d) => DescriptionValue.fromMap(d)).toList() : [];
    return list;
  }

  Future<DescriptionValue> getDescriptionValue(Database db, String name) async
  {
    var res =await  db.query("DescriptionValue", where: "name = ?" , whereArgs: [name]);

    DescriptionValue emptyResult = DescriptionValue();
    emptyResult.name = "";

    DescriptionValue result =
    res.isNotEmpty ? res.map((d) => DescriptionValue.fromMap(d)).toList()[0] : emptyResult;
    return result;
  }

}

class UpdateToDescription
{

  updateDescriptionValue(Database db, String name) async
  {
    DescriptionValue updatedValue = await GetFromDescription().getDescriptionValue(db, name);

    update(db, updatedValue);
  }

  void update(Database db, DescriptionValue updatedValue)
  {
    db.update("DescriptionValue", updatedValue.toMap(), where: "id = ?", whereArgs: [updatedValue.id]);
  }

  updateDescriptionValueInterestScore(Database db, String name) async
  {
    DescriptionValue currentValue = await GetFromDescription().getDescriptionValue(db, name);
    currentValue.interestScore++;
    update(db, currentValue);
  }

  updateDescriptionValueSentimentScore(Database db, String name, double sentiment) async
  {
    DescriptionValue currentValue = await GetFromDescription().getDescriptionValue(db, name);
    currentValue.sentiment = sentiment;
    update(db, currentValue);
  }
}

class DeleteFromDescription
{

  deleteDescriptionValue(Database db, String name) async {
    db.delete("DescriptionValue", where: "name = ?", whereArgs: [name]);
  }

  void deleteAll(Database db)
  {
    db.delete("DescriptionValue");
  }
}

class _MatchHandler
{

  void checkForMatches(Database db, DescriptionValue currentDescriptionValue, isLiked)
  {
    _matchFound(db, currentDescriptionValue.name, isLiked);
  }

  final _databaseReference = Firestore.instance;
  OnlineDatabaseManager _onlineManage = OnlineDatabaseManager();

  int _matchFreshHold = 1;
  /*
  This value determines how many people should be interested in something. As if there
  is not enough people then it would be unlikely that a match will be found in a given amount of time.
   */

  void _matchFound(Database db, String name, isLiked) async
  {
    DescriptionValue currentDescriptionValue = await GetFromDescription().getDescriptionValue(db, name);

    print("testing matchable");

    print("item name is " + currentDescriptionValue.name);

    Query query = _databaseReference.collection("interests").where(
        "name", isEqualTo: currentDescriptionValue.name);

    QuerySnapshot result = await query.getDocuments();

    if (result.documents.isEmpty) {
      //if not found in the online database then the user interest is unmatchable
      _onlineManage.addUserInterest(currentDescriptionValue.name, isLiked);
      _changeMatchable(db, currentDescriptionValue, false);
    }
    else {
      String id = result.documents.first.documentID;
      int oldValue = 0;

      //an interest value on the online database has a hate and a like value
      //this is because if the user hates something but no one else does then no match will be found
      if (isLiked == true) {
        oldValue = result.documents.first.data["likes"];
      }
      else {
        oldValue = result.documents.first.data["hates"];
      }

      if (oldValue < _matchFreshHold) {
        _changeMatchable(db, currentDescriptionValue, false);
      }
      else {
        _changeMatchable(db, currentDescriptionValue, true);
      }

      oldValue++;

      _onlineManage.updateUserInterest(id, isLiked, oldValue);

    }
  }

    void _changeMatchable(Database db, DescriptionValue currentValue, bool isMatchable)
    {
      DescriptionValue newDescriptionValue = currentValue;
      if (isMatchable == true)
      {
        newDescriptionValue.matchable = 1;
        print("matchable is true");
        //OnlineDatabaseManager().addDescriptionValue(currentValue.name);
      }
      else{
        newDescriptionValue.matchable = 0;
        print("matchable is false");
      }

      print("id is " + newDescriptionValue.id.toString());

      print("new matchable value is " + newDescriptionValue.matchable.toString());
      UpdateToDescription().update(db, newDescriptionValue);
    }
}