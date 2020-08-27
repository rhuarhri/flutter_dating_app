import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterdatingapp/database_management_code/internal/DataModels.dart';

import '../database.dart';

class OnlineDescriptionValueManager
{
  /*
  This manages the user's likes and hates that are stored online.
   */

  final databaseReference = Firestore.instance;

  Future<bool> addDescriptionValues(double dealBreakerFreshHold) async
  {
    print("deal breaker fresh hold is " + dealBreakerFreshHold.toString());
    List<DescriptionValue> hates = await DBProvider.db.getNegativeDescriptionValue(freshHold: (dealBreakerFreshHold - (dealBreakerFreshHold * 2)));

    List<String> hatedItems = [];

    if (hates.isEmpty == false)
    {
      hates.forEach((element) {
        //if (element.matchable == 1) {
        hatedItems.add(element.name);
        //}
      });
    }

    List<DescriptionValue> mustNotHaves = await DBProvider.db.getMustNotHaveDescriptionValue((dealBreakerFreshHold - (dealBreakerFreshHold * 2)));

    List<String> mustNotHaveItems = [];

    if (mustNotHaves.isEmpty == false)
    {
      mustNotHaves.forEach((element) {
        mustNotHaveItems.add(element.name);
      });
    }

    List<DescriptionValue> likes = await DBProvider.db.getPositiveDescriptionValue(freshHold: dealBreakerFreshHold);

    List<String> likedItems = [];

    List<DescriptionValue> mustHaves = await DBProvider.db.getMustHaveDescriptionValue(dealBreakerFreshHold);

    List<String> mustHaveItems = [];

    if (likes.isEmpty == false) {
      likes.forEach((element) {
        likedItems.add(element.name);
      });
    }

    if (mustHaves.isEmpty == false) {
      mustHaves.forEach((element) {
        mustHaveItems.add(element.name);
      });
    }

    UserInfo user = await DBProvider.db.getUser();
    String userId = user.onlineLocation;

    databaseReference.collection("users").document(userId).updateData(
        {
          "likes":likedItems,
          "hates":hatedItems,
          "mustHaves":mustHaveItems,
          "mustNotHaves":mustNotHaveItems,
          "lastUpdate": Timestamp.now(),
        }
    );

    bool isDone = true;
    return isDone;

  }

  void addOneDescriptionValue(String name, double dealBreakerFreshHold) async
  {
    DescriptionValue newValue = await DBProvider.db.getOneDescriptionValue(name);

    UserInfo user = await DBProvider.db.getUser();
    String userId = user.onlineLocation;

    if (newValue.sentiment > (dealBreakerFreshHold - (dealBreakerFreshHold * 2)) &&
        newValue.sentiment < 0)
    {
      //if a hate value
      DocumentSnapshot document = await databaseReference.collection("users").document(userId).get();

      List<String> allHates = document.data["hates"];
      allHates.add(newValue.name);

      databaseReference.collection("users").document(userId).updateData(
          {"hates":allHates, "lastUpdate": Timestamp.now(),});
    }
    else if (newValue.sentiment < (dealBreakerFreshHold - (dealBreakerFreshHold * 2)))
    {
      //if a must not have value
      DocumentSnapshot document = await databaseReference.collection("users").document(userId).get();

      List<String> allMustNotHaves = document.data["mustNotHaves"];
      allMustNotHaves.add(newValue.name);
      databaseReference.collection("users").document(userId).updateData(
          {"mustNotHaves":allMustNotHaves, "lastUpdate": Timestamp.now(),});
    }
    else if (newValue.sentiment < dealBreakerFreshHold && newValue.sentiment > 0)
    {
      //if is a like value
      DocumentSnapshot document = await databaseReference.collection("users").document(userId).get();

      List<String> allLikes = document.data["likes"];
      allLikes.add(newValue.name);
      databaseReference.collection("users").document(userId).updateData(
          {"likes":allLikes, "lastUpdate": Timestamp.now(),});
    }
    else if (newValue.sentiment > dealBreakerFreshHold)
    {
      //if is a must have value
      DocumentSnapshot document = await databaseReference.collection("users").document(userId).get();

      List<String> allMustHaves = document.data["mustHaves"];
      allMustHaves.add(newValue.name);
      databaseReference.collection("users").document(userId).updateData(
          {"mustHaves":allMustHaves, "lastUpdate": Timestamp.now(),});
    }
  }

  void addUserInterest(String name, bool isLiked)
  {
    int liked = 0;
    int hated = 0;

    if (isLiked == true)
    {
      liked++;
    }
    else
    {
      hated++;
    }

    databaseReference.collection("interests").add({
      "name":name,
      "likes":liked,
      "hates":hated,
    });
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