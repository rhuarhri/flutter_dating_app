import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutterdatingapp/database_management_code/internal/DataModels.dart';
import 'package:flutterdatingapp/location_manager.dart';
import 'package:geolocator/geolocator.dart';

import '../database.dart';

class AddOnlineManager
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
      "gender":gender,
      "lookingFor":lookingFor,
      "likes":[],
      "hates":[],
      "mustHaves":[],
      "mustNotHaves":[],
      "descriptionStyle":"",

    }).then((value) => {

      _addToInternalDatabase(value.documentID, age, lookingFor, lat, long),

      Firestore.instance.collection("users").document(value.documentID).collection("basicInfo").add({
        "name":name,
        "description":"",
        "image":"",
      })
    });
  }

  void _addToInternalDatabase(String id, int age, String lookingFor, double latitude, double longitude)
  {
    UserInfo userInfo = UserInfo();
    userInfo.onlineLocation = id;
    userInfo.age = age;
    userInfo.lookingFor = lookingFor;
    userInfo.descriptionStyle = "";
    userInfo.latitude = latitude;
    userInfo.longitude = longitude;
    DBProvider.db.addUser(userInfo);
  }


  void addUserDescription(String userDescription) async
  {
    UserInfo user = await DBProvider.db.getUser();


    String userInfoLocation = user.onlineLocation;
    databaseReference.collection("users").document(userInfoLocation).collection("basicInfo")
        .getDocuments().then((value) => {
      _addDescription(value.documents[0].documentID, userInfoLocation, userDescription),

    });

  }

  void _addDescription(String id, String userLocation, String description)
  {
    databaseReference.collection("users").document(userLocation).collection("basicInfo").document(id)
        .updateData(
        {
          "description":description,
        }
    );
  }

  void addDescriptionStyle() async
  {
    UserInfo user = await DBProvider.db.getUser();
    String style = user.descriptionStyle;

    String userInfoLocation = user.onlineLocation;
    databaseReference.collection("users").document(userInfoLocation).updateData(
      {
        "descriptionStyle":style,
      }
    );
  }

  void addUserImage(File image) async
  {
    UserInfo user = await DBProvider.db.getUser();
    String userId = user.onlineLocation;
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

  void addDescriptionValues(double dealBreakerFreshHold) async
  {
    print("deal breaker fresh hold is " + dealBreakerFreshHold.toString());
    List<DescriptionValue> hates = await DBProvider.db.getNegativeDescriptionValue(freshHold: (dealBreakerFreshHold - (dealBreakerFreshHold * 2)));

    List<String> hatedItems = [];

    if (hates.isEmpty == false)
      {
        hates.forEach((element) {
          hatedItems.add(element.name);
        });
      }

    List<DescriptionValue> mustNotHaves = await DBProvider.db.getMustNotHaveDescriptionValue((dealBreakerFreshHold - (dealBreakerFreshHold * 2)));

    List<String> mustNotHaveItems = [];

    if (mustNotHaves.isEmpty == false)
      {
        mustNotHaves.forEach((element) {
          mustNotHaveItems.add(element.name);
        });
      }

    List<DescriptionValue> likes = await DBProvider.db.getPositiveDescriptionValue(freshHold: dealBreakerFreshHold);

    List<String> likedItems = [];

    List<DescriptionValue> mustHaves = await DBProvider.db.getMustHaveDescriptionValue(dealBreakerFreshHold);

    List<String> mustHaveItems = [];

    if (likes.isEmpty == false) {
      likes.forEach((element) {
        likedItems.add(element.name);
      });
    }

    if (mustHaves.isEmpty == false) {
      mustHaves.forEach((element) {
        mustHaveItems.add(element.name);
      });
    }

    UserInfo user = await DBProvider.db.getUser();
    String userId = user.onlineLocation;

    databaseReference.collection("users").document(userId).updateData(
        {
          "likes":likedItems,
          "hates":hatedItems,
          "mustHaves":mustHaveItems,
          "mustNotHaves":mustNotHaveItems,
        }
    );
  }
}