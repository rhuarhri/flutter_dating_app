import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutterdatingapp/database_management_code/internal/DataModels.dart';
import 'package:flutterdatingapp/location_manager.dart';
import 'package:geolocator/geolocator.dart';
import './add_online_data.dart';

import '../database.dart';

class UpdateOnlineDatabase
{

  final databaseReference = Firestore.instance;
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
          }
      );

      databaseReference.collection("users").document(user.onlineLocation).collection("basicInfo").getDocuments()
          .then((value) => {
            databaseReference.collection("users").document(user.onlineLocation)
        .collection("basicInfo").document(value.documents[0].documentID).updateData({
              "name":name,
            })
      });

      _updateInternalDatabase(lookingFor);
  }

  void _updateInternalDatabase(String lookingFor) async
  {
    UserInfo user = await DBProvider.db.getUser();
    user.lookingFor = lookingFor;

    DBProvider.db.updateUser(user);
  }

  void updateDescription(String userDescription)
  {
    //the add and update code is the same
    AddOnlineManager addManager = AddOnlineManager();
    addManager.addUserDescription(userDescription);

  }

  void updateDescriptionStyle()
  {
    AddOnlineManager addManager = AddOnlineManager();
    addManager.addDescriptionStyle();
  }

  void updateImage(File image) async
  {
    UserInfo user = await DBProvider.db.getUser();
    String userId = user.onlineLocation;
    String fileName = userId + "Image";

    StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
    ref.delete();

    AddOnlineManager addManager = AddOnlineManager();
    addManager.addUserImage(image);

  }

  void updateVideo(File video) async
  {
    UserInfo user = await DBProvider.db.getUser();
    String userId = user.onlineLocation;
    String fileName = userId + "Video";

    StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
    ref.delete();

    AddOnlineManager addManager = AddOnlineManager();
    addManager.addUserImage(video);
  }

  void updateLikedInterest(String documentId, int likes)
  {
    databaseReference.collection("interests").document(documentId).updateData(
    {
      "likes":likes,
      "lastUpdate": Timestamp.now(),
    });

  }

  void updateHatedInterests(String documentId, int hates)
  {
    databaseReference.collection("interests").document(documentId).updateData(
        {
          "hates":hates,
          "lastUpdate": Timestamp.now(),
        });
  }



}