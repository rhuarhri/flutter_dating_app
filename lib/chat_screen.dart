import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterdatingapp/database_management_code/database.dart';
import 'package:flutterdatingapp/messages_screen.dart';
import './color_scheme.dart';
import './common_widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'match_manager.dart';

import 'package:firebase_admob/firebase_admob.dart';
import 'database_management_code/database.dart';
import 'package:flutterdatingapp/ad_display_manager.dart';


class ChatScreen extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //appBar: appBar("Chats", Icon(MdiIcons.chat), context),
        body: ChatBody(),
    );
  }

}

class ChatBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChatBody();
  }


}

class _ChatBody extends State<ChatBody> {

  Future<void> _onRewardedAdEvent(RewardedVideoAdEvent event,
      {String rewardType, int rewardAmount}) async {
    switch (event) {
      case RewardedVideoAdEvent.loaded:
        print("loaded");
        break;
      case RewardedVideoAdEvent.failedToLoad:
        print('Failed to load a rewarded ad');
        break;
      case RewardedVideoAdEvent.rewarded:
        print("rewarded");
        await DBProvider.db.updateMessageAmount(rewardAmount);
        messageAmount = await DBProvider.db.getMessageAmount();
        setState(() {

        });
        break;
      default:
      // do nothing
    }
  }

  @override
  Future<void> initState() {
    super.initState();
    AppAds.init();
    AppAds.setVideo(_onRewardedAdEvent);
  }

  @override
  void dispose() {
    print("disposed");
    AppAds.dispose();
    super.dispose();
  }


  Widget getImage(String location) {
    Widget image;

    if (location == "") {
      image = Image.asset("assets/place_holder_person_1.jpeg", fit: BoxFit.cover, height: 60, width: 60,);
    }
    else {
      image =
          CachedNetworkImage(
            imageUrl: location,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(MdiIcons.alertCircle),
            height: 60,
            width: 60,
            fit: BoxFit.cover,
          );
    }

    return Padding(child: image, padding: EdgeInsets.all(12.0),);
  }

  List<MatchInfo> matches = [];
  List<String> acceptedMatches = [];
  int messageAmount = 0;

  bool isSetupRequired = true;

  @override
  Widget build(BuildContext context) {

    if (isSetupRequired == true)
      {
        setup();
        isSetupRequired = false;
      }

    return
      CustomScrollView(slivers: <Widget>[
      SliverAppBar(
        expandedHeight: MediaQuery.of(context).size.height * .30,
        //30% screen height,
        backgroundColor: primaryLight,
        flexibleSpace: chatAmountDisplay(context),
      ),
      SliverList(
          delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          if (acceptedMatches.contains(matches[index].accountId))
            {
              return listItem(matches[index], index, false);
            }
          else
            {
              return listItem(matches[index], index, true);
            }
        },
        childCount: matches.length,
      )),
    ]);
  }

  Widget chatAmountDisplay(BuildContext context)
  {
    String helpInformation = "This is the number of messages you can send. "
        + "You can add more messages by pressing the plus button.";

    return
    Container(color: primaryLight,
      child:
      Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(flex: 1,),
          Flexible(child:
          Container(child:
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text(messageAmount.toString(), textScaleFactor: 2.5,),
              infoButton(helpInformation, context)],)
            ,),
            fit: FlexFit.tight, flex: 2,),
          //Spacer(flex: 1,),
          Flexible(child:
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(padding: EdgeInsets.all(16.0),
                child: Text("Chats", textScaleFactor: 2.0,),),
                Padding(padding: EdgeInsets.all(16.0),
                child: IconButton(icon: Icon(MdiIcons.plus,), iconSize: 40.0, color: secondary, onPressed: (){
                  AppAds.showAd(this);
                },),
                ),
              ],
            ),
            fit: FlexFit.tight, flex: 4,)
        ],)
      ,);
  }

  Widget listItem(MatchInfo match, int itemIndex, bool isDisabled)
  {
    Color iconColor = isDisabled == true ? Colors.white : secondary;
    Color textColor = isDisabled == true ? Colors.white : Colors.black;

    Function itemPressed = ()
    {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MessagesScreen(user: match,)));
    };

    return
      Dismissible(
        key: UniqueKey(),
        child:
            FlatButton(disabledColor: primaryLight, child:
        Container(
          child:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[

              Flexible(child:
              getImage(match.image),
                fit: FlexFit.loose,
                flex: 1,
              ),

              Flexible(child:
              Text(match.name, style: TextStyle(color: textColor),),
                fit: FlexFit.tight,
                flex: 1,
              ),

              Flexible(child:
              Container(child: Row(children: [
                Text(match.rate.toString(), style: TextStyle(color: textColor),),
                Icon(MdiIcons.star, color: iconColor,)
              ],),),),

              Flexible(child:
              IconButton(icon: Icon(MdiIcons.delete, color: iconColor,), onPressed: (){
                MatchManager matchManager = MatchManager();
                matchManager.reject(match.accountId);
                setup();
              },),
                fit: FlexFit.loose,
                flex: 1,
              )

            ],),),
              onPressed: isDisabled == true? null : itemPressed,
            ),

        background: Container(child:
        Row(mainAxisAlignment: MainAxisAlignment.end,
          children: [
            //When some presses and drags an item to dismiss it
            //Icon(MdiIcons.chat),// if they drag to the left then the chats will be displayed
            Icon(MdiIcons.delete, color: secondary,)],// if they drag to the right then the chat will be deleted

        ),
          color: primary,),

        onDismissed: (direction)
        {
            MatchManager matchManager = MatchManager();
            matchManager.reject(match.accountId);
            setup();

        },
      );
  }

  void setup() async
  {
    MatchManager matchManager = MatchManager();

    matches = await matchManager.getMatches();

    acceptedMatches = await matchManager.getAllAcceptedMatches();

    await DBProvider.db.setupMessages();

    messageAmount = await DBProvider.db.getMessageAmount();

    setState(() {

    });

  }


}
