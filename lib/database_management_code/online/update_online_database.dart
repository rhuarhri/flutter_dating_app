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


  /*void updateDescription(String userDescription)
  {
    //the add and update code is the same
    AddOnlineManager addManager = AddOnlineManager();
    addManager.addUserDescription(userDescription);

  }*/

  /*void updateDescriptionStyle()
  {
    AddOnlineManager addManager = AddOnlineManager();
    addManager.addDescriptionStyle();
  }*/

  /*void updateImage(File image) async
  {
    UserInfo user = await DBProvider.db.getUser();
    String userId = user.onlineLocation;
    String fileName = userId + "Image";

    StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
    ref.delete();

    AddOnlineManager addManager = AddOnlineManager();
    addManager.addUserImage(image);

  }*/







}