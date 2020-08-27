import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterdatingapp/database_management_code/online/manage_description_online.dart';
import 'package:geolocator/geolocator.dart';
import './color_scheme.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterdatingapp/database_management_code/internal/DataModels.dart';

import 'database_management_code/database.dart';
import 'account_info.dart';
import 'database_management_code/online_database.dart';
import 'location_manager.dart';

class SearchResult
{
  String onlineId;
  String name;
  String image;

  SearchResult();
}

class SearchBar {


  final databaseReference = Firestore.instance;
  TextEditingController searchForController = TextEditingController();

  List<SearchResult> foundAccounts = [];

  Widget getWidget(Function onPress)
  {
    return Container(
      //color: primaryLight,
      height: 60,
      child: Row(children: [
        Flexible( child:
        Container(
          //height:50,
          //color: Colors.white,
          child:
          TextField(
            controller: searchForController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "search"
              )
          ),
          height: 50,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: primaryDark))
          ),
          margin: EdgeInsets.all(16.0),
        ),
          fit: FlexFit.tight,
          flex: 4,
        ),

        Flexible(child:
        IconButton(icon: Icon(MdiIcons.magnify), onPressed: () async {
          onPress.call();
        },),
          fit: FlexFit.loose,
          flex: 1,
        )

      ],),
    );
  }

  Future<bool> findAccounts() async
  {

    foundAccounts.clear();
    String name = searchForController.text;
    List<DocumentSnapshot> result = await getSearchResults(name);

    if (result.isNotEmpty)
    {
      result.forEach((element) async {
        SearchResult foundInSearch = SearchResult();
        foundInSearch.onlineId = element.documentID;
        foundInSearch.name = element.data["name"];
        foundInSearch.image = await getImageOfAccount(element.documentID);

        foundAccounts.add(foundInSearch);
        print("found item is " + foundInSearch.name);

        return true;

      });
    }
    else{
      //empty result response
      print("result empty");
      return true;
    }
  }

  Future<List<DocumentSnapshot>> getSearchResults(String name) async
  {
    Query query = await manualSearchQuery(name);
    List<DocumentSnapshot> searchResults = [];

    QuerySnapshot value = await query.getDocuments();
    searchResults = value.documents;

    return searchResults;
  }

  Future<Query> manualSearchQuery(String name)
  async {
    Query newQuery = databaseReference.collection("users");
    Query oldQuery = newQuery;

    UserInfo foundData = await DBProvider.db.getUser();

    //get accounts with gender
    newQuery = oldQuery.where("gender", isEqualTo: foundData.lookingFor.toLowerCase());
    oldQuery = newQuery;
    oldQuery = newQuery.where("lookingFor", isEqualTo: foundData.gender.toLowerCase());
    oldQuery = newQuery;
    
    newQuery = oldQuery.where("name", isEqualTo: name);

    return newQuery;
  }

  Future<String> getImageOfAccount(String accountId) async
  {
    DocumentSnapshot result = await OnlineDescriptionManager().getUserDescription(accountId);

    String imageURL = result.data["image"];

    return imageURL;
  }

  Widget searchResultsDisplay(Function onPress)
  {
    if (foundAccounts.isEmpty)
      {
        return Text("No results found");
      }
    else
      {
        return
          Container(child: ListView.builder(
            itemCount: foundAccounts.length,
            itemBuilder: (context, position) {
              return _listItem(foundAccounts[position], onPress);
            },),
          height: 150,
          );


      }
  }

  String userLocation = "";
  Widget _listItem(SearchResult item, Function onPress)
  {
    return
      FlatButton(child:

      Container(
        height: 50,
        child: Row(children: [
      Flexible(child:_accountImage(item.image), fit: FlexFit.loose, flex: 2,),
      Flexible(child: Text(item.name),)
    ],),),

        onPressed: (){
        userLocation = item.onlineId;
        onPress.call();
        },
      );
  }

  Widget _accountImage(String url)
  {
    return CachedNetworkImage(
      imageUrl: url,
      placeholder: (context, url) =>
          Center(
            child: CircularProgressIndicator(),
          ),
      errorWidget: (context, url, error) => Icon(MdiIcons.alertCircle),
    );
  }

  Future<AccountInfo> getUser() async
  {
    LocationManager locationManager = LocationManager();
    Position usersPosition = await locationManager.getCurrentLocation();

    DocumentSnapshot foundUser = await databaseReference.collection("users").document(userLocation).get();

    double accountLat = foundUser.data["lat"];
    double accountLong = foundUser.data["long"];

    AccountInfo accountInfo = AccountInfo();

    accountInfo.distance = await locationManager.getDistance(usersPosition.latitude, usersPosition.longitude,
        accountLat, accountLong);
    accountInfo.age = foundUser.data["age"];
    accountInfo.accountId = foundUser.documentID;

    DocumentSnapshot userBasicInfo = await OnlineDatabaseManager().getDescription(foundUser.documentID);

    accountInfo.imageLocation = userBasicInfo.data["image"];
    accountInfo.videoLocation = userBasicInfo.data["video"];
    accountInfo.description = userBasicInfo.data["description"];
    accountInfo.name = userBasicInfo.data["name"];



   return accountInfo;

  }

}