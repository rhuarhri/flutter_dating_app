import 'package:cloud_firestore/cloud_firestore.dart';

import 'database_management_code/online_database.dart';
import 'database_management_code/database.dart';
import 'database_management_code/internal/DataModels.dart';

double searchLikeFresherHold = 0.5;
double searchHateFreshHold = -0.5;

class Searcher
{
  /*TODO It may be a good idea for the user to change age range and location manually
  however this could cause a problem as any can to the age or location may create a new query
  with a different set of results. This is a problem as the app will need to store the last
  location it got to in a large query which will become useless in a new query.
   */
  int maxAge = 0;
  int minAge = 0;

  //What percentage of likes and hates the user have in common
  int accuracy = 0;


  List<DocumentSnapshot> searchResult = [];
  //List<String> hates = [];
  //List<String> likes = [];
  List<String> hates = [];
  List<String> mustNotHaves = [];
  List<String> likes = [];
  List<String> mustHaves = [];

  void search() async
  {
    getInitialResult();

    getUserLikesAndHates();


    searchResult.forEach((element) {
      List<String> accountHates = element.data["hates"];
      List<String> accountLikes = element.data["likes"];

      int numberOfHateMatches = findMatches(accountHates, hates);

      int numberOfLikeMatches = findMatches(accountLikes, likes);
      
      int numberOfMustNotHaveMatches = findMatches(accountLikes, mustNotHaves);

      int numberOfMustHaveMatches = findMatches(accountLikes, mustHaves);

      int numberOfAccountLikesThatUserHates = findMatches(accountLikes, hates);

      //how much the account likes the user

    });

  }

  void getInitialResult() async
  {
    OnlineDatabaseManager onlineManager = OnlineDatabaseManager();
    searchResult = await onlineManager.getSearchResults();
  }

  void getUserLikesAndHates() async
  {

    List<DescriptionValue> foundLikes = await DBProvider.db.getPositiveDescriptionValue();
    foundLikes.forEach((element) {
      likes.add(element.name);
    });

    List<DescriptionValue> foundMustHaves =
    await DBProvider.db.getMustHaveDescriptionValue(searchLikeFresherHold);
    foundMustHaves.forEach((element) {
      mustHaves.add(element.name);
    });

    List<DescriptionValue> foundHates = await DBProvider.db.getNegativeDescriptionValue();
    foundHates.forEach((element) {
      hates.add(element.name);
    });

    List<DescriptionValue> foundNotHaves =
    await DBProvider.db.getMustNotHaveDescriptionValue(searchHateFreshHold);
    foundNotHaves.forEach((element) {
      mustNotHaves.add(element.name);
    });

  }

  int findMatches(List<String> input, List<String> checkAgainst)
  {
    int matches = 0;

    input.forEach((element) {
      String found = element;
      checkAgainst.forEach((element) {
        if (element == found)
          {
            matches++;
          }
      });
    });

    return matches;
  }

  int calculateMatchRate(
    List<String> accountLikes, List<String> accountHates,
    List<String> userLikes, List<String> userHates, List<String> userMustHaves, List<String> userMustNotHaves
      )
  {

    //TODO not currently using the accounts hates list

    int maxScore = 400;

    int matches = 0;

    double totalScore = 400;

    matches = findMatches(accountLikes, userLikes);

    double likeScore = 100 - ((matches / userLikes.length) * 100);

    print("like score " + likeScore.toStringAsFixed(3));

    totalScore = totalScore - likeScore;

    print("total score plus likes " + totalScore.toStringAsFixed(3));

    matches = findMatches(accountLikes, userMustHaves);

    double mustHaveScore = 100 - ((matches / userMustHaves.length) * 100);

    print("must have score " + mustHaveScore.toStringAsFixed(3));

    if (matches != userMustHaves.length)
      {
        mustHaveScore = (mustHaveScore * 2);

        print("must have score doubled " + mustHaveScore.toStringAsFixed(3));
      }

    totalScore = totalScore - mustHaveScore;

    print("total score minus must have score" + totalScore.toStringAsFixed(3));

    matches = findMatches(accountLikes, userHates);

    double hateScore = ((matches / userHates.length) * 100);

    print("hate score " + hateScore.toStringAsFixed(3));

    totalScore = totalScore - hateScore;

    print("total score plus hate score " + totalScore.toStringAsFixed(3));

    matches = findMatches(accountLikes, userMustNotHaves);

    double mustNotHaveScore = ((matches / userMustNotHaves.length) * 100);

    print("must not have score " + mustNotHaveScore.toStringAsFixed(3));

    if (matches > 0)
      {
        mustNotHaveScore = mustNotHaveScore * 2;

        print("must not have score doubled " + mustNotHaveScore.toStringAsFixed(3));
      }

    totalScore = totalScore - mustNotHaveScore;

    print("total score plus must not have score " + totalScore.toStringAsFixed(3));

    print("total score " + totalScore.toStringAsFixed(3));

    double finalScore = (totalScore / maxScore) * 100;

    return finalScore.round();
  }



}

class basicInfo
{

}