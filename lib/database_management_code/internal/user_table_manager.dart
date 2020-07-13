
import 'package:sqflite/sqflite.dart';
import './DataModels.dart';

class AddToUser
{

  addUser(Database db, UserInfo user) async
  {
    var res = await db.insert("UserInfo", user.toMap());
    return res;
  }

}

class GetFromUser
{
  Future<UserInfo> getUser(Database db) async
  {
    var res = await  db.query("UserInfo");
    List<UserInfo> list =
    res.isNotEmpty ? res.map((I) => UserInfo.fromMap(I)).toList() : [];
    return list[0];
  }
}

class UpdateToUser
{

    updateUserFaceShape(Database db, String shape) async
    {
      UserInfo existingUser = await GetFromUser().getUser(db);
      existingUser.faceShape = shape;
      updateUser(db, existingUser);
    }

    updateUserDescriptionStyle(Database db, String newStyle) async
    {
      UserInfo existingUser = await GetFromUser().getUser(db);

      existingUser.descriptionStyle = newStyle;

      updateUser(db, existingUser);
    }

    updateUserDistance(Database db, double distance) async
    {
      UserInfo existingUser = await GetFromUser().getUser(db);

      existingUser.distance = distance;

      updateUser(db, existingUser);

    }

    updateUserAgeRange(Database db, int minAge, int maxAge) async
    {
      UserInfo existingUser = await GetFromUser().getUser(db);

      existingUser.minAge = minAge;
      existingUser.maxAge = maxAge;

      updateUser(db, existingUser);
    }

    updateUserAccuracy(Database db, int accuracy) async
    {
      UserInfo existingUser = await GetFromUser().getUser(db);

      existingUser.accuracy = accuracy;

      updateUser(db, existingUser);
    }

    updateUser(Database db, UserInfo newUserInfo)
    {
      db.update("UserInfo", newUserInfo.toMap(), where: "id = ?", whereArgs: [newUserInfo.id]);
    }
}

class DeleteFromUser
{
  void deleteUser(Database db) async
  {
    UserInfo existingUser = await GetFromUser().getUser(db);

    //db.delete("UserInfo", where: "id = ?", whereArgs: [existingUser.id]);
    db.delete("UserInfo");

  }
}