import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterdatingapp/database_management_code/internal/DataModels.dart';

import '../database.dart';

class GetOnlineManager
{
  final databaseReference = Firestore.instance;

  Future<List<DocumentSnapshot>> getSearchResults(String documentId, bool startAfter) async
  {
    //bool isHistoryEmpty = await DBProvider.db.isHistoryEmpty();

    Query query = await _getOnlineDatabaseQuery();

    if(documentId != "")
    {
      print("history not empty");
      DocumentSnapshot document = await _documentFromID(documentId);

      if (startAfter == false) {
        query = query.startAtDocument(document);
      }
      else
        {
          query = query.startAfterDocument(document);
        }
      print("history has id of " + document.documentID);

    }
    else
      {
        print("history is empty");
      }

    List<DocumentSnapshot> searchResults = [];

    QuerySnapshot value = await query.getDocuments();
    searchResults = value.documents;

    //_updateHistory(searchResults.last);

    return searchResults;

  }

  void _updateHistory(DocumentSnapshot document)
  {
    DBProvider.db.addHistory(document.documentID);
  }

  Future<DocumentSnapshot> _documentFromID(String documentId) async
  {

    //String idOfLastViewedUser = "";

    /*
    await DBProvider.db.getHistory().then((value) => {
      idOfLastViewedUser = value.lastID,
    });*/

    /*History history = await DBProvider.db.getHistory();
    idOfLastViewedUser = history.lastID;*/

    //print("last id is " + idOfLastViewedUser);

    return databaseReference.collection("users").document(documentId).get();

  }

  double searchFreshHold = 0.5;
  Future<Query> _getOnlineDatabaseQuery() async
  {
    var foundData = await DBProvider.db.getUser();

    Query newQuery = databaseReference.collection("users");
    Query oldQuery;

    UserInfo user = foundData;
    print("user age is " + user.minAge.toString());
    print("user looking for " + user.lookingFor.toLowerCase());

    List<DescriptionValue> userLikedItem = await DBProvider.db
        .getMustHaveDescriptionValue(searchFreshHold);

    List<String> searchForLiked = [];

    //TODO uncomment in the future. But it is too unlikely that any match will be found.
    //firestore's array contains query can only accept up to 10 items
    //as result the u=number of the user's likes is limited here.
    //if (userLikedItem.isNotEmpty == true) {
      //for (int i = 0; i < 10 || i < userLikedItem.length; i++) {
        //searchForLiked.add(userLikedItem[i].name);
      //}

      // However it may be wise no to since the search algorithm will handle it
      //query.where("likes", arrayContainsAny: searchForLiked);
    //}


    /*The query is coded like this because of the reason explained here
  https://stackoverflow.com/questions/50316462/flutter-firestore-compound-query*/

    oldQuery = databaseReference.collection("users");
    newQuery = oldQuery.where("age", isGreaterThanOrEqualTo: user.minAge);
    oldQuery = newQuery;
    newQuery = oldQuery.where("gender", isEqualTo: user.lookingFor.toLowerCase());
    oldQuery = newQuery;
    newQuery = oldQuery.where("age", isLessThanOrEqualTo: user.maxAge);
    oldQuery = newQuery;
    //Get all accounts that were active in the past 30 days.
    //accounts that were not active in that time are considered not using the app
    DateTime inactivityLimit = DateTime.now().subtract(Duration(days: 30));
    newQuery = oldQuery.where("lastUpdate", isGreaterThanOrEqualTo: Timestamp.fromDate(inactivityLimit));
    newQuery = oldQuery.orderBy("age");
    oldQuery = newQuery;
    //The grading screen only displays 3 options at a time, so limiting it to 3 means that the
    //app only gets a tiny amount of data which speeds it up and the user cannot see the difference
    newQuery = oldQuery.limit(3);

    return newQuery;
  }
  
  Future<DocumentSnapshot> getUserDescription(String id) async
  {
    DocumentSnapshot result;
    QuerySnapshot foundData = await databaseReference.collection("users").document(id)
        .collection("basicInfo").getDocuments();

    result = foundData.documents[0];

    return result;
  }

  Future<List<String>> getMatchedUsers() async
  {
    var foundData = await DBProvider.db.getUser();

    QuerySnapshot matchedUser = await databaseReference.collection("users").document(foundData.onlineLocation)
    .collection("matches").getDocuments();

    List<String> result = [];

    matchedUser.documents.forEach((element) {
      result.add(element.data["accountId"].toString());
    });

    return result;
  }

}