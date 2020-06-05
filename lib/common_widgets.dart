import 'package:flutter/material.dart';
import './color_scheme.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';


Widget helpButtons(String helpContent, String tipContent, BuildContext context)
{
  return
    Row(children: <Widget>[
      IconButton(icon: Icon(MdiIcons.helpCircle),
        color: primaryDark, tooltip: "helpful information",
        onPressed: (){popup("Help", helpContent, context, (){});},),
      IconButton(icon: Icon(MdiIcons.lightbulbOn),
        color: primaryDark, tooltip: "pro tips",
        onPressed: (){popup("Pro tip", tipContent, context, (){});},)
    ],
      mainAxisAlignment: MainAxisAlignment.end,
    );

}

popup(String title, String content, BuildContext context, Function action)
{

  return showDialog(context: context, builder: (context){

    return AlertDialog(
      title: Text(title),
      content: Text(content),
      elevation: 24.0,
      actions: [
        FlatButton( child: Text("More info"), onPressed: () {
          action();
        }, )
      ],
      shape: buttonBorderStyle,
    );

  });

}

Widget appBar(String title, Widget icon, BuildContext context)
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
      icon,
        fit: FlexFit.tight,
        flex: 1,
      ),
    ],),
    title: Text(title),
    centerTitle: true,
  );
}

/*Widget progressBar()
{


  return LinearProgressIndicator();

  *//*
  return Stack(children: [

    Positioned(child: LinearProgressIndicator(),
    top: 70,
    right: 50,
    )

  ],);*//*



}*/
