import 'package:geolocator/geolocator.dart';

import './location_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import './database.dart';
import './DataModels.dart';
import 'dart:io';

class OnlineDatabaseManager
{

  int _MinAgeForUser = 18;
  
  String add(String name, int age, String gender, String lookingFor)
  {
    String error = _checkInput(name, age);

    if (error == "")//error free
      {
        _addToDatabase(name, age, gender, lookingFor);
    }

    return error;
  }

  String _checkInput(String name, int age)
  {
    String error = "";

      if (name == "")
        {
          error = "No name added";
        }

      if (age > 100)
        {
          error = "No age greater than 100";
        }

      if (age < _MinAgeForUser)
        {
          error = "No age less than 18";
        }

      return error;

  }

  final databaseReference = Firestore.instance;
  void _addToDatabase(String name, int age, String gender, String lookingFor) async
  {

    Position userPosition = await LocationManager().getCurrentLocation();

    double lat = userPosition.latitude;
    double long = userPosition.longitude;

    await databaseReference.collection("users").add({
      "age":age,
      "lat":lat,
      "long":long,
      "gender":gender,
      "lookingFor":lookingFor,
      "interests":[],
    }).then((value) => {

      addToInternalDatabase(value.documentID, age, lookingFor),

      Firestore.instance.collection("users").document(value.documentID).collection("basicInfo").add({
        "name":name,
        "description":"",
        "image":"",
      })
    });

  }

  void addToInternalDatabase(String id, int age, String lookingFor)
  {
    UserInfo userInfo = UserInfo();
    userInfo.onlineLocation = id;
    userInfo.age = age;
    userInfo.lookingFor = lookingFor;
    DBProvider.db.addUser(userInfo);
  }

  void get() async
  {

    var foundData = await DBProvider.db.getUser();

    UserInfo user = foundData[0];
    _getAgeRange(user.age);
    _getLocationRange();

    var query = databaseReference.collection("users").
    where("age", isGreaterThanOrEqualTo: _MinAge).
    where("age", isLessThanOrEqualTo: _MaxAge).

    where("lat", isGreaterThanOrEqualTo: _minLat).
    where("lat", isLessThanOrEqualTo: _maxLat).
    where("long", isGreaterThanOrEqualTo: _minLong).
    where("long", isLessThanOrEqualTo: _maxLong).

    where("gender", isEqualTo: user.lookingFor);


    query.getDocuments().then((value) => {
      //TODO DO something with the returned data
    });



    //TODO implement getting user interests
    //.where("interests", arrayContainsAny: [user interests])
  }

  int _MaxAge = 0;
  int _MinAge = 0;
  void _getAgeRange(int age)
  {
    //TODO Find a better way to calculate age range

    _MaxAge = age + 5;
    _MinAge = age - 5;
    if (_MinAge < 18)
    {
      _MinAge = 18;
    }
  }

  int _minLat = 0;
  int _maxLat = 0;
  int _minLong = 0;
  int _maxLong = 0;
  //The location is a double but these aren't as there is no benefit from them
  //being accurate i.e. accurate but not 0.01 level accurate.
  void _getLocationRange() async
  {
    //TODO research how far people will go for love as 120 miles might be too far

    /*
    user some not see anyone who is greater than 1.5 degrees greater than the lat and long on their
    location. As 1.5 degree difference is 194 km or 120 miles.*/

    double difference = 1.5;

    Position userPosition = await LocationManager().getCurrentLocation();

    double lat = userPosition.latitude;
    double long = userPosition.longitude;

    _minLat = (lat - difference).round();
    _maxLat = (lat + difference).round();
    _minLong = (long - difference).round();
    _maxLong = (long + difference).round();

  }

  void addUserDescription(String userDescription) async
  {
    List<UserInfo> user = await DBProvider.db.getUser();


    String userInfoLocation = user[0].onlineLocation;
    databaseReference.collection("users").document(userInfoLocation).collection("basicInfo")
        .getDocuments().then((value) => {
      _updateDescription(value.documents[0].documentID, userInfoLocation, userDescription),

    });

  }

  void _updateDescription(String id, String userLocation, String description)
  {
    databaseReference.collection("users").document(userLocation).collection("basicInfo").document(id)
        .updateData(
      {
        "description":description,
      }
    );
  }

  void addImage(File image) async
  {
    List<UserInfo> user = await DBProvider.db.getUser();
    String userId = user[0].onlineLocation;
    String fileName = userId + "Image";

    StorageReference ref = FirebaseStorage.instance.ref().child(fileName);

    StorageUploadTask upload = ref.putFile(image);


    upload.onComplete.then((value) => {
      _recordImageLocation(value.uploadSessionUri, userId),
    });
  }

  void _recordImageLocation(Uri location, String id)
  {
    String imageLocation = location.toString();

    databaseReference.collection("users").document(id).collection("basicInfo")
        .getDocuments().then((value) => {
      _updateImage(imageLocation, id, value.documents[0].documentID),

    });
  }

  void _updateImage(String location, String userId, String id)
  {
    databaseReference.collection("users").document(userId).collection("basicInfo").document(id)
        .updateData(
        {
          "image":location,
        }
    );
  }


}