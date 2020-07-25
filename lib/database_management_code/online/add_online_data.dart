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
      "gender":gender.toLowerCase(),
      "lookingFor":lookingFor.toLowerCase(),
      "likes":[],
      "hates":[],
      "mustHaves":[],
      "mustNotHaves":[],
      "descriptionStyle":"",
      "faceShape":"",
      "lastUpdate": Timestamp.now(),

    }).then((value) => {

      _addToInternalDatabase(value.documentID, age, lookingFor, lat, long),

      Firestore.instance.collection("users").document(value.documentID).collection("basicInfo").add({
        "name":name,
        "description":"",
        "image":"",
        "video":"",
      })
    });
  }

  void _addToInternalDatabase(String id, int age, String lookingFor, double latitude, double longitude)
  {
    UserInfo userInfo = UserInfo();
    userInfo.onlineLocation = id;
    userInfo.minAge = 18;
    userInfo.maxAge = age + 5;
    userInfo.lookingFor = lookingFor.toLowerCase();
    userInfo.descriptionStyle = "";
    userInfo.distance = 100;
    userInfo.accuracy = 20;
    DBProvider.db.addUser(userInfo);
  }


  Future<bool> addUserDescription(String userDescription) async
  {
    UserInfo user = await DBProvider.db.getUser();


    String userInfoLocation = user.onlineLocation;
    databaseReference.collection("users").document(userInfoLocation).collection("basicInfo")
        .getDocuments().then((value) => {
      _addDescription(value.documents[0].documentID, userInfoLocation, userDescription),

    });

    bool isDone = true;
    return isDone;

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
        "descriptionStyle":style.toLowerCase(),
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

    String imageLocation = "";
    StorageReference imageRef;

    upload.onComplete.then((value) async => {

      imageRef = FirebaseStorage.instance.ref().child(fileName),
      imageLocation = await imageRef.getDownloadURL(),
      _recordImageLocation(Uri.parse(imageLocation), userId),
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

  void _updateImage(String location, String userId, String id) async
  {

    databaseReference.collection("users").document(userId).collection("basicInfo").document(id)
        .updateData(
        {
          "image":location,
        }
    );
  }

  void addUserVideo(File video) async
  {
    UserInfo user = await DBProvider.db.getUser();
    String userId = user.onlineLocation;
    String fileName = userId + "Video";

    StorageReference ref = FirebaseStorage.instance.ref().child(fileName);

    StorageUploadTask upload = ref.putFile(video);

    String videoLocation = "";
    StorageReference imageRef;

    upload.onComplete.then((value) async => {

      imageRef = FirebaseStorage.instance.ref().child(fileName),
      videoLocation = await imageRef.getDownloadURL(),
      _recordVideoLocation(Uri.parse(videoLocation), userId),
    });
  }

  void _recordVideoLocation(Uri location, String id)
  {
    String imageLocation = location.toString();

    databaseReference.collection("users").document(id).collection("basicInfo")
        .getDocuments().then((value) => {
      _updateVideo(imageLocation, id, value.documents[0].documentID),

    });
  }

  void _updateVideo(String location, String userId, String id) async
  {

    databaseReference.collection("users").document(userId).collection("basicInfo").document(id)
        .updateData(
        {
          "video":location,
        }
    );
  }

  void addFaceShape(String shape) async
  {
    UserInfo user = await DBProvider.db.getUser();
    String userId = user.onlineLocation;

    databaseReference.collection("users").document(userId).updateData(
      {
        "faceShape": shape,
        "lastUpdate": Timestamp.now(),
      }
    );
  }

  Future<bool> addDescriptionValues(double dealBreakerFreshHold) async
  {
    print("deal breaker fresh hold is " + dealBreakerFreshHold.toString());
    List<DescriptionValue> hates = await DBProvider.db.getNegativeDescriptionValue(freshHold: (dealBreakerFreshHold - (dealBreakerFreshHold * 2)));

    List<String> hatedItems = [];

    if (hates.isEmpty == false)
      {
        hates.forEach((element) {
          //if (element.matchable == 1) {
            hatedItems.add(element.name);
          //}
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
          "lastUpdate": Timestamp.now(),
        }
    );

    bool isDone = true;
    return isDone;

  }

  void addOneDescriptionValue(String name, double dealBreakerFreshHold) async
  {
    DescriptionValue newValue = await DBProvider.db.getOneDescriptionValue(name);

    UserInfo user = await DBProvider.db.getUser();
    String userId = user.onlineLocation;

    if (newValue.sentiment > (dealBreakerFreshHold - (dealBreakerFreshHold * 2)) &&
        newValue.sentiment < 0)
      {
        //if a hate value
        DocumentSnapshot document = await databaseReference.collection("users").document(userId).get();

        List<String> allHates = document.data["hates"];
        allHates.add(newValue.name);

        databaseReference.collection("users").document(userId).updateData(
            {"hates":allHates, "lastUpdate": Timestamp.now(),});
      }
    else if (newValue.sentiment < (dealBreakerFreshHold - (dealBreakerFreshHold * 2)))
    {
      //if a must not have value
      DocumentSnapshot document = await databaseReference.collection("users").document(userId).get();

      List<String> allMustNotHaves = document.data["mustNotHaves"];
      allMustNotHaves.add(newValue.name);
      databaseReference.collection("users").document(userId).updateData(
          {"mustNotHaves":allMustNotHaves, "lastUpdate": Timestamp.now(),});
    }
    else if (newValue.sentiment < dealBreakerFreshHold && newValue.sentiment > 0)
      {
        //if is a like value
        DocumentSnapshot document = await databaseReference.collection("users").document(userId).get();

        List<String> allLikes = document.data["likes"];
        allLikes.add(newValue.name);
        databaseReference.collection("users").document(userId).updateData(
            {"likes":allLikes, "lastUpdate": Timestamp.now(),});
      }
    else if (newValue.sentiment > dealBreakerFreshHold)
      {
        //if is a must have value
        DocumentSnapshot document = await databaseReference.collection("users").document(userId).get();

        List<String> allMustHaves = document.data["mustHaves"];
        allMustHaves.add(newValue.name);
        databaseReference.collection("users").document(userId).updateData(
            {"mustHaves":allMustHaves, "lastUpdate": Timestamp.now(),});
      }
  }
  
  void addUserInterest(String name, bool isLiked)
  {
    int liked = 0;
    int hated = 0;
    
    if (isLiked == true)
      {
        liked++;
      }
    else
      {
        hated++;
      }
    
    databaseReference.collection("interests").add({
      "name":name,
      "likes":liked,
      "hates":hated,
    });
  }
}