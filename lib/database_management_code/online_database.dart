//import 'dart:html';

import 'package:flutterdatingapp/database_management_code/online/add_online_data.dart';
import 'package:flutterdatingapp/database_management_code/online/get_online_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';


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
  void _addToDatabase(String name, int age, String gender, String lookingFor) async
  {
    addOnlineManager.addNewAccount(name, age, gender, lookingFor);

  }


  void addUserDescription(String userDescription) async
  {
    addOnlineManager.addUserDescription(userDescription);

  }

  void addImage(File image) async
  {
      addOnlineManager.addUserImage(image);
  }



  void addLikesAndHates() async
  {
    double dealBreakerFreshHold = 0.5;
    addOnlineManager.addDescriptionValues(dealBreakerFreshHold);
  }

  addDescriptionStyle()
  {
    addOnlineManager.addDescriptionStyle();
  }

  //Getting from online database section
  Future<List<DocumentSnapshot>> getSearchResults() async
  {

    GetOnlineManager getOnlineManager = GetOnlineManager();
    return getOnlineManager.getSearchResults();

  }








}