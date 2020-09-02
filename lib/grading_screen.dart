import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterdatingapp/account_screen_code/account_update_screen.dart';
import 'package:flutterdatingapp/database_management_code/database.dart';
import 'package:flutterdatingapp/description_screen_code/description_update_screen.dart';
import 'package:flutterdatingapp/picture_screen_code/picture_update_screen.dart';
import 'package:flutterdatingapp/screen_timer.dart';
import 'package:flutterdatingapp/search_manager.dart';
import 'package:flutterdatingapp/setting_screen.dart';
import 'package:flutterdatingapp/text_reader.dart';
import 'package:flutterdatingapp/user_search_bar.dart';
import 'package:flutterdatingapp/video_player.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import './color_scheme.dart';
import './common_widgets.dart';
import './chat_screen.dart';
import 'match_manager.dart';
import 'account_info.dart';

//TODO add a star grading widget under the image just above the description
//This will allow the user to grade the account as they are looking at it.

int _maxGrade = 4;
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
        mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(_maxGrade, (index) {
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
  ScreenTimer screenTimer = ScreenTimer();

  SearchBar searchBar = SearchBar();


  /*
  @override
  void initState() {
    super.initState();
  }*/

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
            "There are no more accounts available at the moment. " +
                "Go to the chat screen by pressing the speak bubble at the top right corner.",
            "https://firebasestorage.googleapis.com/v0/b/grading-dating-app.appspot.com/o/error-image.png?alt=media&token=3ab22d8d-334f-420a-80dc-4dd13ad362be",
            "",
            0, 0, 0);
      }
    else
      {
        return accounts[index];
      }

  }

  Widget getImage(String location)
  {
    if (isLoading == true)
      {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    else {
        return
          CachedNetworkImage(
            imageUrl: location,
            placeholder: (context, url) =>
                Center(
                  child: CircularProgressIndicator(),
                ),
            errorWidget: (context, url, error) => Icon(MdiIcons.alertCircle),
          );
      }
  }

  Widget getImageAvatar(String location)
  {
    if (isLoading == true)
    {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    else
    {
      return
        CachedNetworkImage(
          imageUrl: location,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(MdiIcons.alertCircle),
        );

    }
  }

  void showSwipeInstruction(BuildContext context)
  {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text("Swipe right of like, left for hate",), backgroundColor: secondaryDark,)
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool isSetupRequired = true;

  @override
  Widget build(BuildContext context) {

    if (isSetupRequired == true)
      {
        isLoading = true;
        setup(context);
        isSetupRequired = false;
      }

    return Scaffold(
      key: _scaffoldKey,
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

  /*
  Widget _matchScoreDisplay()
  {
    return Container(child: Text(getAccount(displayedOption).matchScore.toString()),);
  }*/

  VideoPlayer videoPlayer = VideoPlayer();
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
                background: displayMedia(),
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
                        swapMedia(),
                        //_matchScoreDisplay(),
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
            Icon(MdiIcons.thumbDown, size: 80,),
            Icon(MdiIcons.thumbUp, size: 80,)

          ],),
          color: primary,),
        onDismissed: (direction) {
          if (getAccount(displayedOption).accountId != "") {

            if (direction == DismissDirection.startToEnd)
              {
                _currentGrade = 0;
              }
            else
              {
                _currentGrade = _maxGrade;
              }

            gradingPopup(context);
          }
        },
      );
  }

  bool isPictureDisplayed = true;
  Widget swapMedia()
  {
    if (isPictureDisplayed == true)
      {
        return IconButton(icon: Icon(MdiIcons.video, color: secondary, size: 36,), onPressed: (){
          if (getAccount(displayedOption).videoLocation != "")
            {
              isPictureDisplayed = false;
              setState(() {

              });
            }
        },);
      }
    else
      {
        return IconButton(icon: Icon(MdiIcons.image, color: secondary, size: 36,), onPressed: (){
          videoPlayer.stop();
          isPictureDisplayed = true;
          setState(() {

          });
        },);
      }
  }

  Widget displayMedia()
  {
    if (isPictureDisplayed == true)
      {
        return getImage(getAccount(displayedOption).imageLocation);
      }
    else
      {
        if (isVideoAvailable == false)
          {
            setupVideo();
            return videoPlayer.videoLoading();
          }
        else
          {
            return videoPlayer.videoDisplay();
          }

      }

  }

  bool isVideoAvailable = false;
  Future<void> setupVideo()
  async {
    String videoURL = getAccount(displayedOption).videoLocation;

    await videoPlayer.setup(videoURL);

    setState(() {
      isVideoAvailable = true;
    });
  }

  @override
  void dispose() {
    videoPlayer.dispose();
    screenTimer.stop();
    super.dispose();
  }

  Widget gradingMenu() {
    return Drawer(

      child: ListView(
        children: <Widget>[
          drawerHeader(),
          searchBar.getWidget((){
            searchBar.findAccounts().then((value) => (){
              setState(() {

              });
            });
          }),
          searchBar.searchResultsDisplay(
              (){
                searchBar.getUser().then((value){
                  accounts.insert(displayedOption, value);
                  setState(() {

                  });
                });
              }
          ),
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
        Text(appName, style: TextStyle(fontWeight: FontWeight.bold),)
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

            String lastId = getAccount(optionOneLoc).accountId;

            setState(() {
              accounts.removeAt(displayedOption);
            });

            if(accounts.length < 3)
            {
              print("get more accounts");

              DBProvider.db.addHistory(lastId);
              setup(context);
            }

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

  bool isLoading = true;
  void setup(BuildContext context) async
  {
    Searcher searchManager = Searcher();

    List<AccountInfo> foundAccounts = await searchManager.getOnlineAccounts();
    print("search result length is " + foundAccounts.length.toString());

    accounts.clear();
    accounts.addAll(foundAccounts);

    setState(() {
      isLoading = false;
      showSwipeInstruction(context);
      screenTimer.start("grading screen");
    });
  }

}