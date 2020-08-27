import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutterdatingapp/database_management_code/internal/DataModels.dart';

import '../database.dart';

class OnlineVideoManager
{
  final databaseReference = Firestore.instance;

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

  void updateVideo(File video) async
  {
    UserInfo user = await DBProvider.db.getUser();
    String userId = user.onlineLocation;
    String fileName = userId + "Video";

    StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
    ref.delete();

    addUserVideo(video);
  }
}