import 'dart:async';

import 'package:flutter/material.dart';
import './color_scheme.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';


Widget helpButtons(String helpContent, String tipContent, BuildContext context)
{
  return
    Row(children: <Widget>[
      infoButton(helpContent, context),
      tipButton(tipContent, context),
    ],
      mainAxisAlignment: MainAxisAlignment.end,
    );

}

Widget infoButton(String helpContent, BuildContext context)
{
  return IconButton(icon: Icon(MdiIcons.helpCircle),
      color: secondary, tooltip: "helpful information",
      onPressed: (){popup("Help", helpContent, context, (){});});
}

Widget tipButton(String tipContent, BuildContext context)
{
  return IconButton(icon: Icon(MdiIcons.lightbulbOn),
    color: secondary, tooltip: "pro tips",
    onPressed: (){popup("Pro tip", tipContent, context, (){});},);
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
          if (action == null)
            {
              Navigator.pop(context);
            }
          else
            {
              action.call();
            }

        }, )
      ],
      shape: buttonBorderStyle,
    );

  });

}

errorPopup(String error, BuildContext context)
{
  return showDialog(context: context, builder: (context){

    return AlertDialog(
      title: Text("ERROR"),
      content: Text(error),
      elevation: 24.0,
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

class AppTimer
{
  int _timeLimit = 60;
  int _currentTime = 0;
  double progress = 0.0;

  Widget display()
  {
    return LinearProgressIndicator(value: progress, valueColor: AlwaysStoppedAnimation<Color>(secondary),
      backgroundColor: secondaryLight,);

  }

  void _setup()
  {
    progress = 0;
    _currentTime = 0;
  }

  Timer _appTimer;
  void start(Function setState())
  {
    _setup();

    _appTimer = Timer.periodic(Duration(seconds: 1), (timer){
      if(progress < 1)
      {
        _currentTime++;
        progress = (_currentTime / _timeLimit);
        print("progress is " + progress.toStringAsFixed(3));
        setState.call();
      }
      else
      {
        //times up
        timer.cancel();
      }
    });

  }

  void stop()
  {
    _appTimer.cancel();
  }
}
