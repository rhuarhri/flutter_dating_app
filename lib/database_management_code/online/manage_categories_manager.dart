

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterdatingapp/database_management_code/internal/DataModels.dart';

import '../database.dart';

class OnlineCategoriesManager
{

  final databaseReference = Firestore.instance;

  void addCategories() async
  {
    UserInfo user = await DBProvider.db.getUser();
    String userId = user.onlineLocation;

    List<String> categories = await DBProvider.db.getAllCategories();

    databaseReference.collection("users").document(userId).updateData(
        {
          "categories":categories,
        }
    );

  }
}