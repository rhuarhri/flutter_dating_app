import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class GradingScreen extends StatelessWidget
{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: gradingAppBar(),
      drawer: gradingMenu(),
      body: OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              return
                GradingScreen().gradingBody();
            }
            else {
              return GradingScreen().gradingBodyLandscape();
            }
          }
      ),

    );
  }

  Widget gradingAppBar()
  {
    return AppBar(
      title: Text("App name"),
      centerTitle: true,
    );
  }

  Widget gradingMenu()
  {
    return Drawer(
      child: ListView(
        children: <Widget>[
          drawerHeader(),
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

  Widget gradingBody()
  {
    return Column(children: <Widget>[
      gradingItem(),
      gradingItem(),
      gradingItem(),
    ],);
  }

  Widget gradingItem()
  {
    return
      Flexible(child:
      Container(child:
      Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Flexible(child:
          Container(child: Text("image"),
            color: Colors.yellow,),
            fit: FlexFit.tight,
            flex: 2,
          ),

          Flexible(child:
          Container(child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(child:
              Container(child: Text("grading"),color: Colors.blue,),
                fit: FlexFit.tight,
                flex: 1,
              ),
              Flexible(child:
              Container(child: Text("button"),color: Colors.green,),
                fit: FlexFit.tight,
                flex: 1,),
            ],),),
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

  Widget gradingBodyLandscape()
  {
    return Row(children: <Widget>[
      gradingItemLandscape(),
      gradingItemLandscape(),
      gradingItemLandscape()
    ],);
  }

  Widget gradingItemLandscape()
  {
    return
      Flexible(child:
      Container(child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[

          Flexible(child:
          Container(child: Text("image"),
            color: Colors.yellow,),
            fit: FlexFit.tight,
            flex: 2,
          ),

          Flexible(child:
          Container(child: Text("grading"),color: Colors.blue,),
            fit: FlexFit.tight,
            flex: 1,
          ),

          Flexible(child:
          Container(child: Text("button"),color: Colors.green,),
            fit: FlexFit.tight,
            flex: 1,),

        ],),
      ),
          fit: FlexFit.tight,
          flex: 1
      );
  }


}