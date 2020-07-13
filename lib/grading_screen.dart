import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterdatingapp/account_screen_code/account_update_screen.dart';
import 'package:flutterdatingapp/description_screen_code/description_update_screen.dart';
import 'package:flutterdatingapp/picture_screen_code/picture_update_screen.dart';
import 'package:flutterdatingapp/search_manager.dart';
import 'package:flutterdatingapp/setting_screen.dart';
import 'package:flutterdatingapp/text_reader.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import './color_scheme.dart';
import './common_widgets.dart';
import './chat_screen.dart';
import 'match_manager.dart';

//TODO add a star grading widget under the image just above the description
//This will allow the user to grade the account as they are looking at it.

int _currentGrade = 0;

class GradingScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GradingPage();
  }
}

class StarGrading extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    return _StartGrading();
  }

}

class _StartGrading extends State<StarGrading>
{

  @override
  Widget build(BuildContext context) {
    return
      Container(child:
      Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return
            IconButton(icon: Icon(
              index < _currentGrade ? MdiIcons.star : MdiIcons.starOutline,
              color: primaryDark,
            ),
              onPressed: (){
              int location = index +1;
              //location of star pressed

              if (location == _currentGrade)
                {
                  setState(() {
                    _currentGrade = location - 1;
                    //if full make it empty i.e. decrease value
                  });
                }
              else
                {
                  setState(() {
                    _currentGrade = location;
                    //if empty make full i.e. increase value
                  });
                }

            },);
      }),
    ),
      color: backgroundColor,
      );
  }



}


class GradingPage extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    return _GradingPage();
  }

}

class _GradingPage extends State<GradingPage>
{

  List<AccountInfo> accounts = [];

  //The user will only have access to three options
  int optionOneLoc = 0;
  int optionTwoLoc = 1;
  int optionThreeLoc = 2;

  int displayedOption = 0;

  AccountInfo getAccount(int index)
  {
    if (accounts.length <= 0 || accounts.length <= index)
      {
        return AccountInfo.createAccountInfo("", "No account found",
            "There are no more accounts available at the moment.",
            "https://firebasestorage.googleapis.com/v0/b/grading-dating-app.appspot.com/o/error-image.png?alt=media&token=3ab22d8d-334f-420a-80dc-4dd13ad362be",
            0, 0);
      }
    else
      {
        return accounts[index];
      }

  }

  Widget getImage(String location)
  {
    if (location == "")
      {
        return CircularProgressIndicator();
      }
    else
      {
        return
          CachedNetworkImage(
            imageUrl: location,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(MdiIcons.alertCircle),
          );
      }
  }

  Widget getImageAvatar(String location)
  {
    if (location == "")
    {
      return CircularProgressIndicator();
    }
    else
    {
      return
        CachedNetworkImage(
          imageUrl: location,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(MdiIcons.alertCircle),
        );

    }
  }

  bool isSetupRequired = true;

  @override
  Widget build(BuildContext context) {

    if (isSetupRequired == true)
      {
        setup();
        isSetupRequired = false;
      }

    return Scaffold(
      drawer: gradingMenu(),
      body: gradingBody(context),
      bottomNavigationBar: footer(),
      floatingActionButton: actionBTN(context),
    );
  }

  bool audioPlaying = false;
  Widget actionBTN(BuildContext context)
  {
    Widget icon = audioPlaying == false ? Icon(MdiIcons.volumeHigh) : Icon(MdiIcons.volumeOff);

    return FloatingActionButton(backgroundColor: secondary, child: icon, onPressed: (){

      TextToSpeech textToSpeech = TextToSpeech();
      if (audioPlaying == false) {
        textToSpeech.readText(getAccount(displayedOption).description, context);
      }
      else
        {
          textToSpeech.stopReading();
        }

      setState(() {
        audioPlaying = !audioPlaying;
      });

    },);
  }

  Widget gradingBody(BuildContext context) {
    return
      Dismissible(
        child: CustomScrollView(
          slivers: <Widget>[

            SliverAppBar(
              title: Text(getAccount(displayedOption).name),
              actions: [
                IconButton(
                    icon: Icon(
                      MdiIcons.chat,
                      color: secondary,
                    ),
                  onPressed: (){
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => ChatScreen()));
                  },
                ),
              ],

              backgroundColor: primary,
              expandedHeight: MediaQuery
                  .of(context)
                  .size
                  .height * .80,
              //80% screen height

              flexibleSpace: FlexibleSpaceBar(
                background: getImage(getAccount(displayedOption).imageLocation),
              ),
            ),
            SliverFixedExtentList(
              itemExtent: MediaQuery
                  .of(context)
                  .size
                  .height * .40, //40% screen height
              delegate: SliverChildListDelegate(
                [
                  Container(
                      child: Column(children: <Widget>[
                        Text(getAccount(displayedOption).name),//Name
                        Text(getAccount(displayedOption).age.toString()),//age
                        Text(getAccount(displayedOption).distance.toString()),//location
                        Text(getAccount(displayedOption).description)//description
                      ],),
                      color: Colors.white
                  ),
                ],
              ),
            ),
          ],
          shrinkWrap: true,
        ),
        key: UniqueKey(),
        background: Container(child:
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(MdiIcons.starOutline, size: 80,),
            Icon(MdiIcons.star, size: 80,)

          ],),
          color: primary,),
        onDismissed: (direction) {
          if (getAccount(displayedOption).accountId != "") {
            gradingPopup(context);
          }
        },
      );
  }

  Widget gradingMenu() {
    return Drawer(

      child: ListView(
        children: <Widget>[
          drawerHeader(),
          FlatButton(
            color: primary,
            child:
          Row(children: <Widget>[
            Icon(MdiIcons.chat),
            Text("Chats")
          ],),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ChatScreen()));
            },
          ),

          FlatButton(
            color: primary,
            child:
          Row(children: <Widget>[
            Icon(MdiIcons.account),
            Text("Account")
          ],),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AccountUpdateScreen()));
            },
          ),

          FlatButton(
            color: primary,
            child:
          Row(children: <Widget>[
            Icon(MdiIcons.imageSizeSelectActual),
            Text("image")
          ],),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => PictureUpdateScreen()));
            },
          ),

          FlatButton(
            color: primary,
            child:
          Row(children: <Widget>[
            Icon(MdiIcons.cardText),
            Text("Description")
          ],),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => DescriptionUpdateScreen()));
            },
          ),

          FlatButton(
            color: primary,
            child:
          Row(children: <Widget>[
            Icon(MdiIcons.cog),
            Text("Settings")
          ],),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => SettingScreen()));
            },
          ),

        ],
      ),

    );
  }

  Widget drawerHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("App name",)
      ],
    );
  }

  gradingPopup(BuildContext context) {

    String helpContent = "Grade the account you have just seen ";


    return showDialog(context: context, barrierDismissible: false, builder: (context) {
      return AlertDialog(
        title: Text("Grade account"),
        content: StarGrading(),
        elevation: 24.0,
        actions: [

          IconButton(icon: Icon(MdiIcons.helpCircle),
            color: primaryDark, tooltip: "helpful information",
            onPressed: (){popup("Help", helpContent, context, (){});},),

          FlatButton(child: Text("Done"), onPressed: () {

            MatchManager().addMatch(getAccount(displayedOption).name, getAccount(displayedOption).imageLocation,
                getAccount(displayedOption).description, getAccount(displayedOption).accountId, _currentGrade);

            if(accounts.length < 3)
              {
                //TODO get more accounts
              }

            setState(() {
              accounts.removeAt(displayedOption);
            });
            Navigator.pop(context);
          },)
        ],
        shape: buttonBorderStyle,

      );
    });
  }

  Widget imageButton(String imageLocation, Function action) {
    return Flexible(child: RaisedButton(
      child: getImageAvatar(imageLocation),
      onPressed: action,
      color: secondaryDark,
    ),
      fit: FlexFit.loose,
      flex: 1,
    );
  }

  Widget footer() {
    return Container(child: Row(children: <Widget>[
      imageButton(getAccount(optionOneLoc).imageLocation, () {
        displayedOption = optionOneLoc;
        setState(() {

        });
      }),
      imageButton(getAccount(optionTwoLoc).imageLocation, () {
        displayedOption = optionTwoLoc;
        setState(() {

        });

      }),
      imageButton(getAccount(optionThreeLoc).imageLocation, () {
        displayedOption = optionThreeLoc;
        setState(() {

        });
      })
    ],
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    ), height: 80, color: primaryLight,);
  }

  void setup() async
  {
    Searcher searchManager = Searcher();

    List<AccountInfo> foundAccounts = await searchManager.search();
    print("search result length is " + foundAccounts.length.toString());

    accounts.addAll(foundAccounts);

    setState(() {

    });
  }

  void databaseTest() async
  {

    MatchManager matchManager = MatchManager();

    List<MatchInfo> result = await matchManager.getMatches();

    if (result.isEmpty)
      {
        print("no matches found");
      }

    result.forEach((element) {
      print("name is " + element.name);
    });


  }

}