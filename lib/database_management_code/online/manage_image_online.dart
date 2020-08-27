import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutterdatingapp/database_management_code/internal/DataModels.dart';

import '../database.dart';

class OnlineImageManager
{

  final databaseReference = Firestore.instance;


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

  void updateImage(File image) async
  {
    UserInfo user = await DBProvider.db.getUser();
    String userId = user.onlineLocation;
    String fileName = userId + "Image";

    StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
    ref.delete();

    addUserImage(image);

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

}