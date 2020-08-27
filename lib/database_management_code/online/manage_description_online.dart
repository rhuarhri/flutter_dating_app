import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterdatingapp/database_management_code/internal/DataModels.dart';

import '../database.dart';


class OnlineDescriptionManager
{

  final databaseReference = Firestore.instance;

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

  Future<DocumentSnapshot> getUserDescription(String id) async
  {
    DocumentSnapshot result;
    QuerySnapshot foundData = await databaseReference.collection("users").document(id)
        .collection("basicInfo").getDocuments();

    result = foundData.documents[0];

    return result;
  }

  void updateDescription(String userDescription)
  {
    //the add and update code is the same
    addUserDescription(userDescription);

  }

  void updateDescriptionStyle()
  {
    addDescriptionStyle();
  }
}