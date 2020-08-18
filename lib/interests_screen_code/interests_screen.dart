
import 'package:flutter/material.dart';
import 'package:flutterdatingapp/database_management_code/internal/DataModels.dart';
import 'package:flutterdatingapp/database_management_code/database.dart';
import 'package:flutterdatingapp/database_management_code/online_database.dart';
import 'package:flutterdatingapp/screen_timer.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../color_scheme.dart';
import '../common_widgets.dart';
import '../grading_screen.dart';
//import '../screen_recorder.dart';

class InterestsScreen extends StatelessWidget
{

  @override
  Widget build(BuildContext context) {
    return InterestScreen();
  }

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
  ScreenTimer screenTimer = ScreenTimer();

  @override
  void initState() {
    screenTimer.start("interest screen");
    super.initState();
  }

  @override
  void dispose() {
    screenTimer.stop();
    super.dispose();
  }

  TextEditingController likedController = TextEditingController();
  List<DescriptionValue> liked = [];

  TextEditingController hatedController = TextEditingController();
  List<DescriptionValue> hated = [];

  void updateLikedList()
  {
    DBProvider.db.getPositiveDescriptionValue().then((value) => {
      refreshLikedList(value),

      value.forEach((element) {
        print("description value is " + element.name);
      })
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
      refreshHatedList(value),

      value.forEach((element) {
        print("description value is " + element.name);
      })
    });
  }

  void refreshHatedList(List<DescriptionValue> newList)
  {
    setState(() {
      hated = newList;
    });
  }

  void refreshLists()
  {
    setState(() {

    });
  }

  bool receivedFromDatabase = false;

  @override
  Widget build(BuildContext context) {

    if (liked.isEmpty == true && hated.isEmpty == true)
      {
        updateLikedList();
        updateHatedList();
        receivedFromDatabase = true;
      }
    else
      {
        print("already updated");
      }

    return
    Scaffold(
      appBar: appBar("Interest", Icon(MdiIcons.heart), context),
      body:
    Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[

        Container(child:
        listHeader(Icon(MdiIcons.thumbUp), "like", (){

          DescriptionValue newValue = DescriptionValue();
          newValue.name = likedController.text;
          newValue.sentiment = 0.4; //positive sentiment value means it is liked

          setState(() {
            liked.add(newValue);
          });

          addItem(newValue);

        }, likedController),
        color: primary,

        ),

        Flexible(child:
        ListView.builder(
            itemCount: liked.length,
            itemBuilder: (BuildContext context, int Index)
            {
              if (liked[Index].sentiment >= 0.5)
                {
                  return listItem(liked[Index].name, "liked", Index, true, false);
                }
              else
                {
                  return listItem(liked[Index].name, "liked", Index, false, true);
                }

            }
        ),
          fit: FlexFit.tight,
          flex: 6,
        ),

        Flexible(child:
            Container(child:
            listHeader(Icon(MdiIcons.thumbDown), "hate", (){
              DescriptionValue newValue = DescriptionValue();
              newValue.name = hatedController.text;
              newValue.sentiment = -0.4; //negative sentiment value means it is hated

              setState(() {
                hated.add(newValue);
              });

              addItem(newValue);

            }, hatedController),

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
                if (hated[Index].sentiment <= -0.5)
                  {
                    return listItem(hated[Index].name, "hated", Index, true, false);
                  }
                else
                  {
                    return listItem(hated[Index].name, "hated", Index, false, true);
                  }

             }
          ),
          fit: FlexFit.tight,
          flex: 6,
        ),

        loadingDisplay(),

      ],),
    );

  }

  bool isLoading = false;
  Widget loadingDisplay()
  {
    if (isLoading == true)
    {
      return
        Flexible(child: LinearProgressIndicator(), fit: FlexFit.loose, flex: 2,);

    }
    else
    {
      return RaisedButton(child: Text("Done"), shape: buttonBorderStyle, color: primary, onPressed: (){

        setState(() {
          isLoading = true;
        });

       toNewScreen(context);


      },);

    }
  }

  void toNewScreen(BuildContext context) async
  {
    screenTimer.stop();
    await OnlineDatabaseManager().addLikesAndHates();
    Navigator.push(context, MaterialPageRoute(builder: (context) => GradingScreen()));
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
                  IconButton(icon: Icon(MdiIcons.plusCircle, color: secondaryDark,), onPressed: action),
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

  Widget listItem(String name, String type, int itemIndex, bool isMust, bool isOther)
  {
    List<bool> isSelected = [isOther, isMust];
    return
    Dismissible(
      key: ValueKey(name + itemIndex.toString()),
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
              flex: 1,
            ),

            Spacer(flex: 1,),

            Flexible(child:
            ToggleButtons(
              borderColor: primaryDark,
              borderWidth: 3,
              children: [Text("ok without"), Text("must have")], isSelected: isSelected,
            onPressed: (int index){
              setState(() {
                double newSentimentValue = 0.4;

                isSelected[index] = !isSelected[index];

                if (index == 0)
                  {
                    //other item selected
                    newSentimentValue = 0.4;

                  }
                else{
                  //must have item selected
                  newSentimentValue = 0.6;
                }

                setState(() {
                  if(type == "liked")
                  {
                    liked[itemIndex].sentiment = (newSentimentValue);
                    print("like sentiment value is " + newSentimentValue.toString() + " for item names " + liked[itemIndex].name);
                    DBProvider.db.updateDescriptionValueSentiment(liked[itemIndex].name, (newSentimentValue));
                  }
                  else
                  {
                    hated[itemIndex].sentiment = (newSentimentValue - (newSentimentValue * 2));
                    print("hated sentiment value is " + (newSentimentValue - (newSentimentValue * 2)).toString() + " for item names " + hated[itemIndex].name);
                    DBProvider.db.updateDescriptionValueSentiment(hated[itemIndex].name,
                        (newSentimentValue - (newSentimentValue * 2)));
                  }
                });

              });
            },
            ),
            fit: FlexFit.tight,
              flex: 3,
            ),

            Flexible(child:
            IconButton(icon: Icon(MdiIcons.delete), color: secondary, onPressed: (){
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
              deletePopup(context, liked[itemIndex], "liked");
              deleteItem(liked[itemIndex].name);
              liked.removeAt(itemIndex);
            });
          }
        else
          {
            setState(() {
              deletePopup(context, hated[itemIndex], "hated");
              deleteItem(hated[itemIndex].name);
              hated.removeAt(itemIndex);
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

              addItem(item);
            })));
  }

  void addItem(DescriptionValue newItem) async
  {
    newItem.name = newItem.name.toLowerCase();
    await DBProvider.db.userAddDescriptionValue(newItem);
    refreshLists();
  }

  void updateItem(DescriptionValue newItem) async
  {
    newItem.name = newItem.name.toLowerCase();
    await DBProvider.db.updateDescriptionValue(newItem);
  }

  void deleteItem(String name) async
  {
    String findName = name.toLowerCase();
    await DBProvider.db.deleteDescriptionValue(findName);
    refreshLists();
  }

}