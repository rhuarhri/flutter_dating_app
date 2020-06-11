
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

    updateUserDescriptionStyle(Database db, String newStyle) async
    {
      UserInfo existingUser = await GetFromUser().getUser(db);

      existingUser.descriptionStyle = newStyle;

      _updateUser(db, existingUser);
    }

    updateUserLocation(Database db, lat, long) async
    {
      UserInfo existingUser = await GetFromUser().getUser(db);

      existingUser.latitude = lat;
      existingUser.longitude = long;

      _updateUser(db, existingUser);


    }

    _updateUser(Database db, UserInfo newUserInfo)
    {
      db.update("UserInfo", newUserInfo.toMap(), where: "id = ?", whereArgs: [newUserInfo.id]);
    }
}

class DeleteFromUser
{

}