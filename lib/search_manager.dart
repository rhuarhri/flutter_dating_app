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
  /*TODO It may be a good idea for the user to change age range and location manually
  however this could cause a problem as any can to the age or location may create a new query
  with a different set of results. This is a problem as the app will need to store the last
  location it got to in a large query which will become useless in a new query.
   */
  int _maxAge = 0;
  int _minAge = 0;

  //This is the fresh hold that an account must score in order to match
  int _accuracy = 0;


  List<DocumentSnapshot> _searchResult = [];

  //this variable contains all the ids of the accounts that liked the user
  List<String> _likedAccounts = [];

  List<AccountInfo> _filteredResult = [];

  LocationManager locationManager = LocationManager();


  Future<List<AccountInfo>> search() async
  {

    getInitialResult();

    //getUserLikesAndHates();

    UserInfo userInfo = await DBProvider.db.getUser();
    double distance = userInfo.distance;
    String faceShape = userInfo.faceShape;

    Position usersPosition = await locationManager.getCurrentLocation();

    OnlineDatabaseManager onlineManager = OnlineDatabaseManager();
    _searchResult = await onlineManager.getSearchResults();


    List<DescriptionValue> likes = await DBProvider.db.getPositiveDescriptionValue(freshHold: searchLikeFresherHold);
    List<DescriptionValue> mustHaves = await DBProvider.db.getMustHaveDescriptionValue(searchLikeFresherHold);
    List<DescriptionValue> hates = await DBProvider.db.getNegativeDescriptionValue(freshHold: searchHateFreshHold);
    List<DescriptionValue> mustNotHaves = await DBProvider.db.getMustNotHaveDescriptionValue(searchHateFreshHold);

    List<String> blockedUsers = await DBProvider.db.getBlockedUser();
    //blockerUsers are the ids of the accounts the user has see or does no like

    print("data from firebase is " + _searchResult.length.toString());

    for(int i = 0; i < _searchResult.length; i++)
      {
        DocumentSnapshot element = _searchResult[i];

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

            print("match sore is " + matchScore.toString());

            if (matchScore >= _accuracy) {
              //accuracy is determined by the user because if it is too high then the user will get
              //little or no match
              print("it a match");
              await _addToResult(element, usersPosition);
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

  void _addToResult(DocumentSnapshot data, Position usersPosition) async
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

    _filteredResult.add(matchedAccount);
  }

  void getInitialResult() async
  {

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

    //print("like score " + likeScore.toStringAsFixed(3));

    totalScore = totalScore - likeScore;

    //print("total score plus likes " + totalScore.toStringAsFixed(3));

    double mustHaveScore = 0;

    mustHaveScore = 100 - (findMatches(accountLikes, userMustHaves, true));

    //print("must have score " + mustHaveScore.toStringAsFixed(3));

    if (mustHaveScore != 0) {
      mustHaveScore = (mustHaveScore * 2);

      //print("must have score doubled " + mustHaveScore.toStringAsFixed(3));
    }

    totalScore = totalScore - mustHaveScore;

    //print("total score minus must have score" + totalScore.toStringAsFixed(3));

    double hateScore = 0;
    double mustNotHaveScore = 0;

    if (accountLikes.isNotEmpty) {
      hateScore = (findMatches(accountLikes, userHates, false));

      //print("hate score " + hateScore.toStringAsFixed(3));

      mustNotHaveScore = (findMatches(accountLikes, userMustNotHaves, false));

      //print("must not have score " + mustNotHaveScore.toStringAsFixed(3));

      if (mustNotHaveScore > 0) {
        mustNotHaveScore = mustNotHaveScore * 2;

        //print("must not have score doubled " +
            //mustNotHaveScore.toStringAsFixed(3));
      }
    } else {
      hateScore = 100;
      mustNotHaveScore = 100;
    }

    totalScore = totalScore - hateScore;
    //print("total score plus hate score " + totalScore.toStringAsFixed(3));

    totalScore = totalScore - mustNotHaveScore;

    /*print("total score plus must not have score " +
        totalScore.toStringAsFixed(3));

    print("total score " + totalScore.toStringAsFixed(3));*/

    double finalScore = (totalScore / maxScore) * 100;

    if (finalScore < 0) {
      finalScore = 0;
    }

    return finalScore.round();
  }
}