import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import './grading_screen.dart';
import './color_scheme.dart';

class DescriptionScreen extends StatelessWidget
{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: descriptionAppBar(context),
      body: descriptionBody(context),
    );
  }

  Widget descriptionAppBar(BuildContext context)
  {
    return AppBar(
      leading:
      Row (children: <Widget>[
        Flexible(child:
        IconButton(icon: Icon(MdiIcons.arrowLeft), tooltip: "go back",
          onPressed: (){Navigator.pop(context);},),
          fit: FlexFit.tight,
          flex: 1,
        ),
        Flexible(child:
        Icon(MdiIcons.cardText),
          fit: FlexFit.tight,
          flex: 1,
        ),
      ],),
      title: Text("Profile description"),
      centerTitle: true,
    );
  }

  Widget descriptionBody(BuildContext context)
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,

      children: <Widget>[
        Flexible(child:
        Container(child: TextField(
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "add a description of yourself"
          ),
          maxLines: null,
        ),
          color: Colors.green,
        ),
          fit: FlexFit.tight,
          flex: 7,
        ),

        Flexible(child:
        Container(child:
        helpButtons(),
          color: Colors.yellow,
        ),
          fit: FlexFit.tight,
          flex: 1,
        ),

        Flexible(child:
        Container(child:
        Row(children: <Widget>[
          RaisedButton(child: Text("Done"),
            shape: buttonBorderStyle,
            color: primary,
            onPressed: (){toNewScreen(context);},)
        ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
          color: Colors.blue,
        ),
          fit: FlexFit.tight,
          flex: 2,
        ),
      ],);

  }

  Widget helpButtons()
  {
    return
      Row(children: <Widget>[
        IconButton(icon: Icon(MdiIcons.helpCircle), tooltip: "helpful information", onPressed: (){},),
        IconButton(icon: Icon(MdiIcons.lightbulbOn), tooltip: "pro tips", onPressed: (){},)
      ],
        mainAxisAlignment: MainAxisAlignment.end,
      );

  }

  void toNewScreen(context)
  {
    Navigator.push(context, MaterialPageRoute(builder: (context) => GradingScreen()));
  }

}