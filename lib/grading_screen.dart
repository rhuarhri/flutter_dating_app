import 'package:flutter/material.dart';
import 'package:flutterdatingapp/description_analyzer.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import './color_scheme.dart';
import './common_widgets.dart';
import 'database_management_code/database.dart';
import 'database_management_code/internal/DataModels.dart';

class TestAccount
{
  TestAccount(this.name, this.description, this.image, this.location, this.age);

  String name = "";
  String description = "";
  int location = 0;
  int age = 0;
  String image = "";
}

//TODO add a star grading widget under the image just above the description
//This will allow the user to grade the account as they are looking at it.

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

  int value = 0;

  @override
  Widget build(BuildContext context) {
    return
      Container(child:
      Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return
            IconButton(icon: Icon(
              index < value ? MdiIcons.star : MdiIcons.starOutline,
              color: primaryDark,
            ),
              onPressed: (){
              int location = index +1;
              //location of star pressed

              if (location == value)
                {
                  setState(() {
                    value = location - 1;
                    //if full make it empty i.e. decrease value
                  });
                }
              else
                {
                  setState(() {
                    value = location;
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

  List<TestAccount> accounts = [
    TestAccount("Fred Johnson",
        "I go hiking",
        "assets/place_holder_person_1.jpeg",
        26,
        32
    ),
    TestAccount("Hannah Harrison",
        "I go swimming",
        "assets/place_holder_person_2.jpeg",
        40,
        29
    ),
    TestAccount("Beth Smith",
        "I go running",
        "assets/place_holder_person_3.jpeg",
        11,
        25
    ),
    TestAccount("Fred Johnson",
        "I go hiking",
        "assets/place_holder_person_1.jpeg",
        26,
        32
    ),
    TestAccount("Hannah Harrison",
        "I go swimming",
        "assets/place_holder_person_2.jpeg",
        40,
        29
    ),
    TestAccount("Beth Smith",
        "I go running",
        "assets/place_holder_person_3.jpeg",
        11,
        25
    )
  ];

  //The user will only have access to three options
  int optionOneLoc = 0;
  int optionTwoLoc = 1;
  int optionThreeLoc = 2;

  int displayedOption = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: gradingMenu(),
      body: gradingBody(context),
      bottomNavigationBar: footer(),
    );
  }

  Widget gradingBody(BuildContext context) {
    return
      Dismissible(
        child: CustomScrollView(
          slivers: <Widget>[

            SliverAppBar(
              title: Text(accounts[displayedOption].name),
              actions: [
                IconButton(
                    icon: Icon(
                      MdiIcons.chat,
                      color: Colors.black,
                    ))
              ],

              backgroundColor: primary,
              expandedHeight: MediaQuery
                  .of(context)
                  .size
                  .height * .80,
              //80% screen height

              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset(accounts[displayedOption].image,
                    fit: BoxFit.contain),
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
                        Text(accounts[displayedOption].name),//Name
                        Text(accounts[displayedOption].age.toString()),//age
                        Text(accounts[displayedOption].location.toString()),//location
                        Text(accounts[displayedOption].description)//description
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
          gradingPopup(context);
        },
      );
  }

  Widget gradingMenu() {
    return Drawer(

      child: ListView(
        children: <Widget>[
          drawerHeader(),
          RaisedButton(child:
          Row(children: <Widget>[
            Icon(MdiIcons.chat),
            Text("Chats")
          ],),
            onPressed: () {},
          ),

          RaisedButton(child:
          Row(children: <Widget>[
            Icon(MdiIcons.account),
            Text("Account")
          ],),
            onPressed: () {},
          ),

          RaisedButton(child:
          Row(children: <Widget>[
            Icon(MdiIcons.imageSizeSelectActual),
            Text("image")
          ],),
            onPressed: () {},
          ),

          RaisedButton(child:
          Row(children: <Widget>[
            Icon(MdiIcons.cardText),
            Text("Description")
          ],),
            onPressed: () {},
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
            //TODO save grading value here
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
      child: Image.asset(
        imageLocation, height: 70.0, width: 90.0, fit: BoxFit.cover,),
      onPressed: action,
      color: primaryDark,
    ),
      fit: FlexFit.loose,
      flex: 1,
    );
  }

  Widget footer() {
    return Container(child: Row(children: <Widget>[
      imageButton(accounts[optionOneLoc].image, () {
        DescriptionAnalyzer analyzer = DescriptionAnalyzer();
        analyzer.analyze("omg you look so cool fam.", context);

      }),
      imageButton(accounts[optionTwoLoc].image, () {
        //databaseTest();
      }),
      imageButton(accounts[optionThreeLoc].image, () {})
    ],
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    ), height: 80, color: primaryLight,);
  }

  void databaseTest() async
  {
    List<DescriptionValue> result = await DBProvider.db.getNegativeDescriptionValue();

    if (result.isEmpty == true)
      {
        print("no hates found");
      }
    else
      {
        result.forEach((element) {
          print("hate is " + element.name);
        });
      }
  }

}