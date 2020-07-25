import 'package:flutterdatingapp/database_management_code/online/add_online_data.dart';
import 'package:flutterdatingapp/database_management_code/online/get_online_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

import 'package:flutterdatingapp/database_management_code/online/update_online_database.dart';

import 'database.dart';
import 'internal/DataModels.dart';


class OnlineDatabaseManager
{

  String add(String name, int age, String gender, String lookingFor)
  {
    String error = _checkInput(name, age);

    if (error == "")//error free
      {
        _addToDatabase(name, age, gender, lookingFor);
    }

    return error;
  }

  String update(String name, int age, String gender, String lookingFor)
  {
    String error = _checkInput(name, age);

    if (error == "")
      {
        _updateUserAccount(name, age, gender, lookingFor);
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

      int minAgeForUser = 18;
      if (age < minAgeForUser)
        {
          error = "No age less than 18";
        }

      return error;

  }

  final databaseReference = Firestore.instance;
  AddOnlineManager addOnlineManager = AddOnlineManager();
  UpdateOnlineDatabase updateManager = UpdateOnlineDatabase();

  void _addToDatabase(String name, int age, String gender, String lookingFor) async
  {
    addOnlineManager.addNewAccount(name, age, gender, lookingFor);

  }

  void _updateUserAccount(String name, int age, String gender, String lookingFor) async
  {
    updateManager.updateUserAccount(name, age, gender, lookingFor);
  }

  Future<bool> addUserDescription(String userDescription) async
  {
    bool isDone = await addOnlineManager.addUserDescription(userDescription);

    return isDone;
  }

  void addImage(File image) async
  {
      addOnlineManager.addUserImage(image);
  }

  void addVideo(File video) async
  {
    addOnlineManager.addUserVideo(video);
  }

  void updateImage(File image) async
  {
    updateManager.updateImage(image);
  }

  void updateVideo(File video) async
  {
    updateManager.updateVideo(video);
  }

  void addFaceShape(String faceShape) async
  {
    addOnlineManager.addFaceShape(faceShape);
  }

  Future<bool> addLikesAndHates() async
  {
    double dealBreakerFreshHold = 0.5;
    //ensures that the app awaits until function is complete
    return addOnlineManager.addDescriptionValues(dealBreakerFreshHold);
  }

  void addDescriptionValue(String name)
  {
    double dealBreakerFreshHold = 0.5;
    addOnlineManager.addOneDescriptionValue(name, dealBreakerFreshHold);
  }

  addDescriptionStyle()
  {
    addOnlineManager.addDescriptionStyle();
  }

  addUserInterest(String name, bool isLiked)
  {
    addOnlineManager.addUserInterest(name, isLiked);
  }

  updateUserInterest(String documentId, bool isLiked, int oldValue)
  {
    if (isLiked == true)
      {
        updateManager.updateLikedInterest(documentId, oldValue);
      }
    else
      {
        updateManager.updateHatedInterests(documentId, oldValue);
      }
  }

  //Getting from online database section
  Future<List<DocumentSnapshot>> getSearchResults(String documentId, bool startAfter) async
  {

    GetOnlineManager getOnlineManager = GetOnlineManager();
    return getOnlineManager.getSearchResults(documentId, startAfter);

  }

  Future<DocumentSnapshot> getDescription(String id) async
  {
    GetOnlineManager getOnlineManager = GetOnlineManager();
      return await getOnlineManager.getUserDescription(id);
  }

  void deleteOnlineInformation() async
  {

    UserInfo user = await DBProvider.db.getUser();

    databaseReference.collection("users").document(user.onlineLocation).delete();

  }

  Future<bool> checkDataIsUpToDate() async
  {
    /*someone can uninstall the app at any time so it is important that the user cannot talk to anyone
    that has uninstalled the app

    The way that app handles it is by looking at when the user last updated their information.
    If the last update was a long time ago then this could suggest that the someone is not using the app.
     */

    int inactivityPeriodLimit = 30;

    DateTime test = DateTime.now();
    test.difference(DateTime.now()).inDays;

    Timestamp lastTimeUpdated;

    UserInfo user = await DBProvider.db.getUser();

    DocumentSnapshot data = await databaseReference.collection("users").document(user.onlineLocation).get();

    lastTimeUpdated = data.data["lastUpdate"];

    DateTime lastUpdateDate = lastTimeUpdated.toDate();

    int inactivityPeriod = lastUpdateDate.difference(DateTime.now()).inDays;

    print("last update in days is " + inactivityPeriod.toString());

    if (inactivityPeriodLimit < inactivityPeriod)
      {
        return false;
      }
    else
      {
        return true;
      }

  }

}