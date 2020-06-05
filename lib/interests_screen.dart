
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterdatingapp/DataModels.dart';
import 'package:flutterdatingapp/database.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import './color_scheme.dart';
import './common_widgets.dart';
import './grading_screen.dart';

import './description_analyzer.dart';

class InterestsScreen extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("interests", Icon(MdiIcons.heart), context),
      body: InterestScreen(),
    );
  }

 /* Widget interestsScreen(context)
  {
    return
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(child:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
              Icon(MdiIcons.thumbUp),
              Text("Likes"),
              IconButton(icon: Icon(MdiIcons.plusCircle, color: primaryDark,), onPressed: (){

              },)
            ],),
              fit: FlexFit.tight,
              flex: 1,
            ),

            Flexible(child:
           ListHandler(true),
              fit: FlexFit.tight,
              flex: 7,
            ),

            Flexible(child:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
              Icon(MdiIcons.thumbDown),
              Text("Hates"),
              IconButton(icon: Icon(MdiIcons.plusCircle, color: primaryDark,), onPressed: (){

              },)
            ],),
              fit: FlexFit.tight,
              flex: 1,
            ),

            Flexible(child:
                ListHandler(false),
              fit: FlexFit.tight,
              flex: 7,
            ),

            RaisedButton(child: Text("Done"), shape: buttonBorderStyle, color: primary, onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => GradingScreen()));

              //DescriptionAnalyzer test = DescriptionAnalyzer();
              //test.analyze();

            },)

        ],);
  }*/





}

class InterestScreen extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    return _InterestScreen();
  }

}

class _InterestScreen extends State<InterestScreen>
{

  TextEditingController likedController = TextEditingController();
  List<DescriptionValue> liked = [];

  TextEditingController hatedController = TextEditingController();
  List<DescriptionValue> hated = [];

  void updateLikedList()
  {
    DBProvider.db.getPositiveDescriptionValue().then((value) => {
      refreshLikedList(value)
    });
  }

  void refreshLikedList(List<DescriptionValue> newList)
  {
    setState(() {
      liked = newList;
    });
  }

  void updateHatedList()
  {
    DBProvider.db.getNegativeDescriptionValue().then((value) => {
      refreshHatedList(value)
    });
  }

  void refreshHatedList(List<DescriptionValue> newList)
  {
    setState(() {
      hated = newList;
    });
  }

  bool receivedFromDatabase = false;

  @override
  Widget build(BuildContext context) {

    if (receivedFromDatabase == false)
      {
        updateLikedList();
        updateHatedList();
        receivedFromDatabase = true;
      }

    return
    Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[

        Container(child:
        listHeader(Icon(MdiIcons.thumbUp), "like", (){
          DescriptionValue newValue = DescriptionValue();
          newValue.name = likedController.text;
          newValue.sentiment = 0.5; //positive sentiment value means it is liked

          setState(() {
            liked.add(newValue);
          });

        }, likedController),
        color: primary,

        ),

        /*Flexible(child:
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(MdiIcons.thumbUp),
            Text("Likes"),
            IconButton(icon: Icon(MdiIcons.plusCircle, color: primaryDark,), onPressed: (){

            },)
          ],),
          fit: FlexFit.tight,
          flex: 1,
        ),*/

        Flexible(child:
        ListView.builder(
            itemCount: liked.length,
            itemBuilder: (BuildContext context, int Index)
            {
              return listItem(liked[Index].name, "liked", Index);
            }
        ),
          fit: FlexFit.tight,
          flex: 7,
        ),

        Flexible(child:
            Container(child:
            listHeader(Icon(MdiIcons.thumbDown), "hate", (){
              DescriptionValue newValue = DescriptionValue();
              newValue.name = hatedController.text;
              newValue.sentiment = -0.5; //negative sentiment value means it is hated

              setState(() {
                hated.add(newValue);
              });


            }, hatedController),



            /*TextField(decoration: InputDecoration(
                //border: InputBorder(borderSide:  BorderSide(color: primaryDark, width: 2)),

                //Border(right: BorderSide(color: primaryDark, width: 2)),
                hintText: "add hate",
            )),
              color: Colors.white,

            ),
            fit: FlexFit.tight,
            flex: 3,
            ),

            Flexible(child:
            IconButton(icon: Icon(MdiIcons.plusCircle, color: primaryDark,), onPressed: (){

            },),
              fit: FlexFit.loose,
              flex: 1,
            ),*/
          //],),
            color: primary,
            ),
          fit: FlexFit.tight,
          flex: 1,
        ),

        Flexible(child:
        ListView.builder(
            itemCount: hated.length,
            itemBuilder: (BuildContext context, int Index)
              {
                return listItem(hated[Index].name, "hated", Index);
             }
          ),
          fit: FlexFit.tight,
          flex: 7,
        ),

        RaisedButton(child: Text("Done"), shape: buttonBorderStyle, color: primary, onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => GradingScreen()));

          //DescriptionAnalyzer test = DescriptionAnalyzer();
          //test.analyze();

        },)

      ],);
  }

  Widget listHeader(Widget icon, String name, Function action, TextEditingController controller)
  {
    return
    Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(child:
            icon,
            fit: FlexFit.loose,
            flex: 2,
          ),

          Flexible(child:
            Text(name),
            fit: FlexFit.loose,
            flex: 2,
          ),

          Flexible(child:
            Container(child:
              Row(children: <Widget>[

                Flexible(child:
                  Container(child:
                    TextField(decoration: InputDecoration(
                      hintText: "add " + name,
                    ),
                    controller: controller,
                    ),
                  color: Colors.white,
                  ),
                fit: FlexFit.tight,
                flex: 3,
                ),

                Flexible(child:
                  IconButton(icon: Icon(MdiIcons.plusCircle, color: primaryDark,), onPressed: action),
                  fit: FlexFit.loose,
                  flex: 1,
                )

          ],),
        ),
      fit: FlexFit.loose,
      flex: 4,
    ),
    ]);
  }

  Widget listItem(String name, String type, int index)
  {
    return
    Dismissible(
      key: ValueKey(name + index.toString()),
      child:
      Container(
        child:
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Spacer(flex: 1,),

            Flexible(child:
            Text(name),
              fit: FlexFit.tight,
              flex: 4,
            ),

            Flexible(child:
            IconButton(icon: Icon(MdiIcons.delete), color: primaryDark, onPressed: (){
              //deleteItem(name);
            },),
              fit: FlexFit.loose,
              flex: 1,
            )
          ],),),

      background: Container(child:
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //When some presses and drags an item to dismiss it
          Icon(MdiIcons.delete),// this icon will appear on the left
          Icon(MdiIcons.delete)],// this icon will appear on the right
        //So the user knows what effect the action will cause
      ),
        color: primary,),

      onDismissed: (direction)
      {
        if (type == "liked")
          {
            setState(() {
              deletePopup(context, hated[index], "liked");
              liked.removeAt(index);
            });
          }
        else
          {
            setState(() {
              deletePopup(context, hated[index], "hated");
              hated.removeAt(index);
            });
          }



      },
    );
  }

  void deletePopup(BuildContext context, DescriptionValue item, String type)
  {
    Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Item deleted"),
        action: SnackBarAction(
            label: "UNDO",
            onPressed: () {
              //To undo deletion

              if (type == "liked") {
                setState(() {
                  liked.add(item);
                });
              }
              else
                {
                  setState(() {
                    hated.add(item);
                  });

                }
            })));
  }

  void deleteItem(String name)
  {
    DBProvider.db.deleteDescriptionValue(name);
  }

}

/*

class listHandler extends StatefulWidget
{
  bool isPositive;

  ListHandler(this.isPositive);

  @override
  State<StatefulWidget> createState() {
    return _ListHandler(isPositive);
  }

}

class _ListHandler extends State<ListHandler>
{

  //List<DescriptionValue> items = [];

  List<DescriptionValue> liked = [];
  List<DescriptionValue> hated = [];

  bool isPositive;

  _ListHandler(this.isPositive);



  @override
  Widget build(BuildContext context) {

    updateList();

      if(isPositive == true)
        {
         return
        }
      else
        {
          return
        }






    return ListView(children: <Widget>[

    ],);
  }



}*/
