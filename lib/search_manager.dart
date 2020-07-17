import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterdatingapp/location_manager.dart';
import 'package:geolocator/geolocator.dart';

import 'database_management_code/online_database.dart';
import 'database_management_code/database.dart';
import 'database_management_code/internal/DataModels.dart';

double searchLikeFresherHold = 0.5;
double searchHateFreshHold = -0.5;

class AccountInfo
{
  String accountId;
  String name;
  String description;
  String imageLocation;
  int age;
  int distance;

  AccountInfo.createAccountInfo(this.accountId, this.name, this.description, this.imageLocation, this.age, this.distance);

  AccountInfo();

}


class Searcher
{

  //This is the fresh hold that an account must score in order to match
  int _accuracy = 0;

  //this variable contains all the ids of the accounts that liked the user
  List<String> _likedAccounts = [];

  LocationManager locationManager = LocationManager();

  Future<List<AccountInfo>> getOnlineAccounts() async
  {
    List<AccountInfo> foundAccounts = [];

    String lastId = "";
    bool isAfter = false;

    bool isHistoryEmpty = await DBProvider.db.isHistoryEmpty();
    History currentHistory = await DBProvider.db.getHistory();

    if (isHistoryEmpty == false)
      {
        lastId = currentHistory.lastID;
      }
    else
      {
        lastId = "";
      }

    while (foundAccounts.length < 3)
      {
        List<AccountInfo> searchResults = await _search(lastId, isAfter);

        foundAccounts.addAll(searchResults);

        if (searchResults.last.accountId != null)
          {
            lastId = searchResults.last.accountId;
            isAfter = true;//search for everything after the last account
          }
        else
          {
            //if last element is null means the app has reached the end of what is currently available
            break;
          }

      }

      return foundAccounts;
  }

  Future<List<AccountInfo>> _search(String nextId, bool isAfter) async
  {
    print("on start last id is " + nextId);

    List<AccountInfo> _filteredResult = [];


    UserInfo userInfo = await DBProvider.db.getUser();
    double distance = userInfo.distance;
    String faceShape = userInfo.faceShape;

    Position usersPosition = await locationManager.getCurrentLocation();

    List<DocumentSnapshot> _searchResult = [];
    OnlineDatabaseManager onlineManager = OnlineDatabaseManager();
    _searchResult = await onlineManager.getSearchResults(nextId, isAfter);


    List<DescriptionValue> likes = await DBProvider.db.getPositiveDescriptionValue(freshHold: searchLikeFresherHold);
    List<DescriptionValue> mustHaves = await DBProvider.db.getMustHaveDescriptionValue(searchLikeFresherHold);
    List<DescriptionValue> hates = await DBProvider.db.getNegativeDescriptionValue(freshHold: searchHateFreshHold);
    List<DescriptionValue> mustNotHaves = await DBProvider.db.getMustNotHaveDescriptionValue(searchHateFreshHold);

    List<String> blockedUsers = await DBProvider.db.getBlockedUser();
    //blockerUsers are the ids of the accounts the user has see or does no like

    _accuracy = (await DBProvider.db.getUser()).accuracy;


    print("data from firebase is " + _searchResult.length.toString());

    for(int i = 0; i < _searchResult.length; i++)
      {
        DocumentSnapshot element = _searchResult[i];

        print("firebase account id is " + element.documentID);

      double accountLat = element.data["lat"];
      double accountLong = element.data["long"];

      if(locationManager.withInRange(accountLat, accountLong, usersPosition, distance) == true) {

        if (blockedUsers.contains(element.documentID) == false) {

          if (_likedAccounts.contains(element.documentID) == true) {
            //if the current account likes the user then it will be shown to the user without filtering
            //as it will most likely produce similar results
            _addToResult(element, usersPosition);
          }
          else {
            List<String> accountHates = dynamicListToStringList(
                element.data["hates"]);
            List<String> accountLikes = dynamicListToStringList(
                element.data["likes"]);

            int matchScore = calculateMatchRate(accountLikes, accountHates,
                likes, hates, mustHaves, mustNotHaves);

            if (matchScore < 100)
              {
                //people can be attracted to people that look like them so if there is a match
                //the account will get a bonus to the match score
                if (element.data["faceShape"].toString() == faceShape)
                  {
                    matchScore = matchScore + 5;
                  }

                if (matchScore > 100)
                  {
                    matchScore = 100;
                  }
              }

            //print("match sore is " + matchScore.toString());

            print("accuracy is " + _accuracy.toString());

            if (matchScore >= _accuracy) {
              //accuracy is determined by the user because if it is too high then the user will get
              //little or no match
              print("it a match");
              _filteredResult.add(await _addToResult(element, usersPosition));
            }
            else {
              print("not a match");
            }
          }
        }
        else {
          print("account blocked");
        }
      }
      else
        {
          print("not in range");
        }
    }

    return _filteredResult;

  }



  List<String> dynamicListToStringList(List<dynamic> input)
  {
    List<String> result = [];
    if (input != null)
      {
        input.forEach((element) {
          result.add(element.toString());
        });
      }
    return result;
  }

  Future<AccountInfo> _addToResult(DocumentSnapshot data, Position usersPosition) async
  {
    double accountLat = data.data["lat"];
    double accountLong = data.data["long"];

    AccountInfo matchedAccount = AccountInfo();
    matchedAccount.distance = await locationManager.getDistance(usersPosition.latitude, usersPosition.longitude,
        accountLat, accountLong);
    matchedAccount.age = data.data["age"];
    matchedAccount.accountId = data.documentID;

    DocumentSnapshot userBasicInfo = await OnlineDatabaseManager().getDescription(data.documentID);

    matchedAccount.imageLocation = userBasicInfo.data["image"];
    matchedAccount.description = userBasicInfo.data["description"];
    matchedAccount.name = userBasicInfo.data["name"];

    return matchedAccount;
  }

  bool isMatch()
  {
    bool isMatch = false;



    return isMatch;
  }

  double findMatches(List<String> input, List<DescriptionValue> checkAgainst, bool isLiked) {
    if (checkAgainst.length < 0) {
      //check against is empty so no matches can be found
      //this means the user has no preference for anything i.e. if you don't hate anything
      //then you will like what ever the account likes
      if (isLiked == true) {
        return 100;
      } else {
        return 0;
      }
    }

    int matches = 0;
    int checkListLength = checkAgainst.length;

    checkAgainst.forEach((element) {
      String currentValue = element.name;
      bool matchFound = false;

      input.forEach((element) {
        if (element == currentValue) {
          matchFound = true;
        }
      });

      if (matchFound == true) {
        matches++;

        if (element.matchable <= 0) {
          setDescriptionValueMatchableToTrue(element);
        }
      } else {
        if (element.matchable <= 0 && isLiked == true) {
          checkListLength--;
          //this is because the liked score is determined by the length and the total number of matches
          //for example if length is 2 and number of matches is 1 but there is 1 unmatchable value
          //then unmatchable result should be ignored so the length should be reduced
        }
      }
    });

    if (checkListLength == 0) {
      //if all values are unmatchable and no match for them has been found
      if (isLiked == true) {
        return 100;
      } else {
        return 0;
      }
    } else {
      double matchPercentage = (matches / checkListLength) * 100;

      return matchPercentage;
    }
  }

  void setDescriptionValueMatchableToTrue(DescriptionValue value)
  {
    value.matchable = 1; //i.e. true
    print("updated matchable to true");
    //TODO uncomment after testing
    //DBProvider.db.updateDescriptionValue(value);
    //OnlineDatabaseManager().addDescriptionValue(value.name);

  }

  int calculateMatchRate(
    List<String> accountLikes, List<String> accountHates,
    List<DescriptionValue> userLikes, List<DescriptionValue> userHates,
      List<DescriptionValue> userMustHaves, List<DescriptionValue> userMustNotHaves
      ) {
    //TODO not currently using the accounts hates list

    int maxScore = 400;

    double totalScore = 400;

    double likeScore = 0;

    likeScore = 100 - (findMatches(accountLikes, userLikes, true));

    totalScore = totalScore - likeScore;

    double mustHaveScore = 0;

    mustHaveScore = 100 - (findMatches(accountLikes, userMustHaves, true));

    if (mustHaveScore != 0) {
      mustHaveScore = (mustHaveScore * 2);
    }

    totalScore = totalScore - mustHaveScore;

    double hateScore = 0;
    double mustNotHaveScore = 0;

    if (accountLikes.isNotEmpty) {
      hateScore = (findMatches(accountLikes, userHates, false));

      mustNotHaveScore = (findMatches(accountLikes, userMustNotHaves, false));

      if (mustNotHaveScore > 0) {
        mustNotHaveScore = mustNotHaveScore * 2;
      }
    } else {
      hateScore = 100;
      mustNotHaveScore = 100;
    }

    totalScore = totalScore - hateScore;

    totalScore = totalScore - mustNotHaveScore;

    double finalScore = (totalScore / maxScore) * 100;

    if (finalScore < 0) {
      finalScore = 0;
    }

    return finalScore.round();
  }
}