import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterdatingapp/database_management_code/internal/DataModels.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutterdatingapp/location_manager.dart';

import '../database.dart';

class OnlineUserManager
{
  final databaseReference = Firestore.instance;
  addNewAccount(String name, int age, String gender, String lookingFor) async
  {
    Position userPosition = await LocationManager().getCurrentLocation();

    double lat = userPosition.latitude;
    double long = userPosition.longitude;

    await databaseReference.collection("users").add({
      "age":age,
      "lat":lat,
      "long":long,
      "gender":gender.toLowerCase(),
      "lookingFor":lookingFor.toLowerCase(),
      "likes":[],
      "hates":[],
      "mustHaves":[],
      "mustNotHaves":[],
      "descriptionStyle":"",
      "categories":[],
      "faceShape":"",
      "lastUpdate": Timestamp.now(),
      "name":name,

    }).then((value) => {

      _addToInternalDatabase(value.documentID, age, gender, lookingFor, lat, long),

      Firestore.instance.collection("users").document(value.documentID).collection("basicInfo").add({
        "description":"",
        "image":"",
        "video":"",
      })
    });
  }

  void _addToInternalDatabase(String id, int age, String gender, String lookingFor, double latitude, double longitude)
  {
    UserInfo userInfo = UserInfo();
    userInfo.onlineLocation = id;
    userInfo.minAge = 18;
    userInfo.maxAge = age + 5;
    userInfo.lookingFor = lookingFor.toLowerCase();
    userInfo.gender = gender.toLowerCase();
    userInfo.descriptionStyle = "";
    userInfo.distance = 100;
    userInfo.accuracy = 20;
    DBProvider.db.addUser(userInfo);
  }

  updateUserAccount(String name, int age, String gender, String lookingFor) async
  {
    Position userPosition = await LocationManager().getCurrentLocation();

    double lat = userPosition.latitude;
    double long = userPosition.longitude;

    UserInfo user = await DBProvider.db.getUser();

    databaseReference.collection("users").document(user.onlineLocation).updateData(
        {
          "age": age,
          "lat": lat,
          "long": long,
          "gender": gender,
          "lookingFor": lookingFor,
          "lastUpdate": Timestamp.now(),
          "name":name,
        }
    );


    _updateInternalDatabase(lookingFor);
  }

  void _updateInternalDatabase(String lookingFor) async
  {
    UserInfo user = await DBProvider.db.getUser();
    user.lookingFor = lookingFor;

    DBProvider.db.updateUser(user);
  }

}