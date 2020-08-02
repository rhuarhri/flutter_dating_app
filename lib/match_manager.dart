
import 'package:flutterdatingapp/database_management_code/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'database_management_code/internal/DataModels.dart';

class MatchInfo
{
  String accountId;
  String name;
  String image;
  String description;
  int rate;
}

class MatchManager
{
  int _maxMatchedAmount = 20;

  Future<List<MatchInfo>> getMatches() async
  {
    List<MatchInfo> result = [];
    List<Matched> currentMatched = await DBProvider.db.getMatched();

    for (int i = 0; i < 10 && i < currentMatched.length; i++)
      {
        MatchInfo info = MatchInfo();
        info.accountId = currentMatched[i].accountId;
        info.name = currentMatched[i].name;
        info.rate = currentMatched[i].rating;
        info.image = currentMatched[i].imageLocation;
        info.description = currentMatched[i].description;
        result.add(info);
      }

    return result;
  }

  void addMatch(String name, String image, String description, String accountId, int grade) async
  {

    DBProvider.db.addMatched(accountId, grade, name, image, description);
    _addMatchedOnline(accountId);

    List<Matched> currentMatched = await DBProvider.db.getMatched();

    if(currentMatched.length > _maxMatchedAmount)
    {
      String deleteAccount = "";

      for(int i = currentMatched.length; i > 0; i--)
        {
          if (currentMatched[i].isTalkingTo == 0)
            {
              //The account the user dislikes the most and are not talking to
              deleteAccount = currentMatched[i].accountId;
              break;
            }

        }

      DBProvider.db.deleteMatched(deleteAccount);
      _deleteMatchOnline(deleteAccount);
    }

    if (grade > 3)//i.e. only the highest scores
      {
       //addDescriptionValue(accountId);
      }

  }

  void _addMatchedOnline(String accountId) async
  {
    UserInfo user = await DBProvider.db.getUser();
    String userId = user.onlineLocation;

    Firestore.instance.collection("users").document(accountId).collection("matches").add(
      {
        "accountId":userId,
      }
    );

    //This is used else where in the app to see if the user is using the app.
    Firestore.instance.collection("users").document(userId).updateData({
      "lastUpdate": Timestamp.now(),
    });

    //Since the user has already matched the user should not see this account again so it is blocked
    DBProvider.db.addBlockedUser(accountId);

  }

  void setIsTalkingTo(String accountId, bool isTalkingTo)
  {
    DBProvider.db.updateIsTalkingTo(accountId, isTalkingTo);
  }

  void reject(String accountId)
  {
    DBProvider.db.deleteMatched(accountId);
    _deleteMatchOnline(accountId);
  }

  void _deleteMatchOnline(String accountId) async
  {
    UserInfo user = await DBProvider.db.getUser();
    String userId = user.onlineLocation;

      QuerySnapshot result = await Firestore.instance.collection("users").document(accountId).collection("matches")
          .where("accountId", isEqualTo: userId).getDocuments();

      result.documents.forEach((element) {
        Firestore.instance.collection("users").document(accountId).collection("matches").document(element.documentID).delete();
      });


      DBProvider.db.deleteBlocked(accountId);

  }

  Future<List<Matched>> getAllMatches() async
  {

    List<Matched> matches = await DBProvider.db.getMatched();



    return matches;
  }

  Future<List<String>> getAllAcceptedMatches() async
  {
    /*
    Every time someone matches with someone else the person they match with is informed of this through
    the online database. The ids of all the people that have matched with the user are gathered here.
    This is used to find out if a user can talk to another user as both should have matched with each other.
     */

    UserInfo user = await DBProvider.db.getUser();
    String userId = user.onlineLocation;

    QuerySnapshot foundData = await Firestore.instance.collection("users").document(userId).collection("matches")
        .getDocuments();

    List<String> onlineMatches = [];
    foundData.documents.forEach((element) {
      onlineMatches.add(element.data["accountId"].toString());
    });

    return onlineMatches;
  }

  void addDescriptionValue(String accountId) async
  {
   DocumentSnapshot accountData = await Firestore.instance.collection("users").document(accountId).get();

   List<String> accountLikes = accountData.data["likes"];
   List<String> accountHates = accountData.data["hates"];

   accountLikes.forEach((element) {DBProvider.db.appAddDescription(element, true);});
   accountHates.forEach((element) {DBProvider.db.appAddDescription(element, false);});
  }
}