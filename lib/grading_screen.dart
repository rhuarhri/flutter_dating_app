import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import './color_scheme.dart';

class TestAccount
{
  TestAccount(this.name, this.description, this.image, this.location, this.age);

  String name = "";
  String description = "";
  int location = 0;
  int age = 0;
  String image = "";
}

class GradingScreen extends StatelessWidget
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
    )
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: gradingAppBar(),
      drawer: gradingMenu(),
      body: gradingScreen(context),
      bottomNavigationBar: footer(),
      /*persistentFooterButtons: [
        imageButton("assets/place_holder_person_1.jpeg", (){}),
        imageButton("assets/place_holder_person_2.jpeg", (){}),
        imageButton("assets/place_holder_person_1.jpeg", (){})
        //RaisedButton(child: Text("btn 1"),),
        //RaisedButton(child: Text("btn 2"),),
        //RaisedButton(child: Text("btn 3"),)
      ],*/

          /*
      OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              return
                GradingScreen().gradingBody(context);
            }
            else {
              return GradingScreen().gradingBodyLandscape(context);
            }
          }
      ),*/
      /*floatingActionButton: FloatingActionButton(child:
      Icon(MdiIcons.refresh, color: Colors.black, size: 36,), onPressed: (){},
      backgroundColor: primary,),*/
    );
  }

  Widget imageButton(String imageLocation, Function action)
  {
    return Flexible(child: RaisedButton(
        child: Image.asset(imageLocation, height: 70.0, width: 90.0, fit: BoxFit.cover,),
      onPressed: action,
      color: primaryDark,
    ),
    fit: FlexFit.loose,
    flex: 1,
    );
  }

  Widget footer()
  {
    return Container(child:Row(children: <Widget>[
      imageButton("assets/place_holder_person_1.jpeg", (){}),
      imageButton("assets/place_holder_person_2.jpeg", (){}),
      imageButton("assets/place_holder_person_3.jpeg", (){})
    ],
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    ), height: 80, color: primaryLight,);
  }

  //new test screen
  Widget gradingScreen(BuildContext context)
  {
    return /*Column(crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[Container(child: Image.asset("assets/place_holder_person_1.jpeg"),
      color: Colors.yellow,)],

    );*/

    //Container(child: Column(children: [
      Dismissible(
      child: CustomScrollView(
        slivers: <Widget>[

          SliverAppBar(
            title: Text('SliverAppBar'),
            actions: [
              IconButton(
                  icon: Icon(
                MdiIcons.chat,
                color: Colors.black,
              ))
            ],

            backgroundColor: primary,
            expandedHeight: MediaQuery.of(context).size.height * .80, //80% screen height

            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset("assets/place_holder_person_1.jpeg",
                  fit: BoxFit.cover),
            ),
          ),
          SliverFixedExtentList(
            itemExtent: MediaQuery.of(context).size.height * .40, //40% screen height
            delegate: SliverChildListDelegate(
              [
                Container(
                  child: Column(children: <Widget>[
                    Text("Name"),
                    Text("age"),
                    Text("location"),
                    Text("Description")
                  ],),
                  color: Colors.white
                ),
              ],
            ),
          ),
        ],
        shrinkWrap: true,
      ),
      key: ValueKey("main"),
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
    /* Container(child: Text("test two"), color: Colors.yellow,)
    ],),
    //height: 500,

    );*/




    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(title: Text("user Name",),
          expandedHeight: 200,
          flexibleSpace: FlexibleSpaceBar(background: Image.asset("assets/place_holder_image_1.jpeg"),),),
        Text("description"),

      ],

    );
  }

  //end of test


  /*Widget gradingAppBar()
  {
    return AppBar(
      title: Text("App name"),
      centerTitle: true,
      actions: [IconButton(icon: Icon(MdiIcons.chat, color: Colors.black,))],
    );
  }*/

  Widget gradingMenu()
  {
    return Drawer(

      child: ListView(
        children: <Widget>[
          drawerHeader(),
          RaisedButton(child:
          Row(children: <Widget>[
            Icon(MdiIcons.chat),
            Text("Chats")
          ],),
            onPressed: (){},
          ),

          RaisedButton(child:
          Row(children: <Widget>[
            Icon(MdiIcons.account),
            Text("Account")
          ],),
            onPressed: (){},
          ),

          RaisedButton(child:
          Row(children: <Widget>[
            Icon(MdiIcons.imageSizeSelectActual),
            Text("image")
          ],),
            onPressed: (){},
          ),

          RaisedButton(child:
          Row(children: <Widget>[
            Icon(MdiIcons.cardText),
            Text("Description")
          ],),
            onPressed: (){},
          ),

        ],
      ),

    );
  }

  Widget drawerHeader()
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("App name",)
      ],
    );
  }

  /*Widget gradingBody(BuildContext context)
  {
    return Column(children: <Widget>[
      gradingItem(context),
      gradingItem(context),
      gradingItem(context),
    ],);
  }*/

  /*Widget gradingItem(BuildContext context)
  {
    return
      Flexible(child:
      Container(child:
      Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Flexible(child:
          Container(child:
          Stack(children: <Widget>[
            Text("image"),
            Positioned(child:
            StarGrading(),
              bottom: 10,
              left: 80,
            ),
            Positioned(child:
            IconButton(icon: Icon(MdiIcons.cardText, color: primaryDark, size: 36),
              onPressed: (){
                _userDescriptionDisplay(context);
              },
            ),

              bottom: 10,
              left: 10,
            ),
        ],),
            //color: Colors.yellow,
        ),
            fit: FlexFit.tight,
            flex: 1,
          ),

        ],),
        //height: 200,
      ),
        fit: FlexFit.tight,
        flex: 1,
      );
  }

  Widget gradingBodyLandscape(BuildContext context)
  {
    return Row(children: <Widget>[
      gradingItemLandscape(context),
      gradingItemLandscape(context),
      gradingItemLandscape(context)
    ],);
  }

  Widget gradingItemLandscape(BuildContext context)
  {
    return
      Flexible(child:
      Container(child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[

          Flexible(child:
          Container(child:
          Stack(children: <Widget>[
            Text("image"),
            Positioned(child: StarGrading(),
            bottom: 50,
            left: 10,),
            Positioned(child:
                IconButton(icon: Icon(MdiIcons.cardText, color: primaryDark, size: 36),
                onPressed: (){
                  _userDescriptionDisplay(context);
                },
                ),
            bottom: 100,
            left: 10,),

          ],),
            //color: Colors.yellow,
          ),
            fit: FlexFit.tight,
            flex: 1,
          ),

        ],),
      ),
          fit: FlexFit.tight,
          flex: 1
      );
  }
*/

  /*void _userDescriptionDisplay(BuildContext context)
  {
    showBottomSheet(context: context, builder: (context){
      return Container(
          height: MediaQuery.of(context).size.height * .60,
          child : Column(
            children: <Widget>[
            IconButton(icon: Icon(MdiIcons.arrowDown), onPressed: (){
              Navigator.of(context).pop();
            },),

            Flexible(child:
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
              Container(child: Text("image"), color: Colors.yellow,),
              Container(child: Column(children: <Widget>[Text("name"), Text("age"), Text("distance")],))
            ]),
              fit: FlexFit.tight,
              flex: 1,
            ),

              Flexible(child:
              Container(child: Text("description"),),
              fit: FlexFit.tight,
              flex: 9,
              ),
          ],));
    });
  }*/


}

gradingPopup(BuildContext context)
{

  return showDialog(context: context, builder: (context){

    return AlertDialog(
      title: Text("Grade account"),
      content: StarGrading(),
      elevation: 24.0,
      actions: [
        FlatButton( child: Text("More info"), onPressed: () {
          //action();
        }, )
      ],
      shape: buttonBorderStyle,
    );

  });

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
