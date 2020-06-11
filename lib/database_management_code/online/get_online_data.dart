import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutterdatingapp/database_management_code/internal/DataModels.dart';

import '../database.dart';

class GetOnlineManager
{
  final databaseReference = Firestore.instance;

  Future<List<DocumentSnapshot>> getSearchResults() async
  {
    bool isHistoryEmpty = await DBProvider.db.isHistoryEmpty();

    Query query = await _getOnlineDatabaseQuery();

    if(isHistoryEmpty == false)
    {

      DocumentSnapshot document = await _documentFromID();

      query.startAtDocument(document);

    }

    List<DocumentSnapshot> searchResults = [];

    query.getDocuments().then((value) => {

      searchResults = value.documents,

    });

    return searchResults;

  }

  Future<DocumentSnapshot> _documentFromID() async
  {

    String idOfLastViewedUser = "";

    await DBProvider.db.getHistory().then((value) => {
      idOfLastViewedUser = value.lastID,
    });

    return databaseReference.collection("users").document(idOfLastViewedUser).get();

  }

  double searchFreshHold = 0.5;
  Future<Query> _getOnlineDatabaseQuery() async
  {
    var foundData = await DBProvider.db.getUser();

    UserInfo user = foundData;
    _getAgeRange(user.age);
    _getLocationRange(user.latitude, user.longitude);

    List<DescriptionValue> userLikedItem = await DBProvider.db
        .getMustHaveDescriptionValue(searchFreshHold);

    List<String> searchForLiked = [];

    //firestore's array contains query can only accept up to 10 items
    //as result the u=number of the user's likes is limited here.
    for (int i = 0; i < 10 || i < userLikedItem.length; i++) {
      searchForLiked.add(userLikedItem[i].name);
    }

    var query = databaseReference.collection("users").
    where("age", isGreaterThanOrEqualTo: _MinAge).
    where("age", isLessThanOrEqualTo: _MaxAge).
    where("lat", isGreaterThanOrEqualTo: _minLat).
    where("lat", isLessThanOrEqualTo: _maxLat).
    where("long", isGreaterThanOrEqualTo: _minLong).
    where("long", isLessThanOrEqualTo: _maxLong).
    where("gender", isEqualTo: user.lookingFor)

        .where("interests", arrayContainsAny: searchForLiked)

        .orderBy("age")

        .limit(50);

    return query;
  }

  int _MaxAge = 0;
  int _MinAge = 0;
  void _getAgeRange(int age)
  {
    //TODO Find a better way to calculate age range

    _MaxAge = age + 5;
    _MinAge = age - 5;
    if (_MinAge < 18)
    {
      _MinAge = 18;
    }
  }

  int _minLat = 0;
  int _maxLat = 0;
  int _minLong = 0;
  int _maxLong = 0;
  //The location is a double but these aren't as there is no benefit from them
  //being accurate i.e. accurate but not 0.01 level accurate.
  void _getLocationRange(double userLat, double userLong) async
  {
    //TODO research how far people will go for love as 120 miles might be too far

    /*
    user some not see anyone who is greater than 1.5 degrees greater than the lat and long on their
    location. As 1.5 degree difference is 194 km or 120 miles.*/

    double difference = 1.5;

    //Position userPosition = await LocationManager().getCurrentLocation();

    double lat = userLat;
    double long = userLong;

    _minLat = (lat - difference).round();
    _maxLat = (lat + difference).round();
    _minLong = (long - difference).round();
    _maxLong = (long + difference).round();

  }

}