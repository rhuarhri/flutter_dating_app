import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import './picture_screen.dart';
import './color_scheme.dart';

class AccountScreen extends StatelessWidget
{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AccountScreen().accountAppBar(context),
      body: AccountScreen().accountBody(context),
    );
  }

  Widget accountAppBar(BuildContext context)
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
        Icon(MdiIcons.account),
          fit: FlexFit.tight,
          flex: 1,
        ),
      ],),
      title: Text("Create Account"),
      centerTitle: true,
    );
  }

  Widget accountBody(BuildContext context)
  {
    return
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Flexible(child:
          Container(
              color: Colors.yellow,
              child:
              Column(children: <Widget>[

                Row(children: <Widget>[
                  Spacer(flex:1),
                  Text("name",),
                  Flexible(child:
                  Container(child:
                  TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "add your name"
                      )
                  ),
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(bottom: BorderSide(color: primaryDark))
                    ),
                    margin: EdgeInsets.all(16.0),
                  ),
                    fit: FlexFit.loose,
                    flex: 2,
                  ),
                  Spacer(flex: 1,),
                ],),


                Row(children: <Widget>[
                  Spacer(flex:3),
                  Text("age"),
                  Flexible(child:
                  Container(child:
                  TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "add your age"
                      )
                  ),
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(bottom: BorderSide(color: primaryDark))
                    ),
                    margin: EdgeInsets.all(16.0),
                  ),
                    fit: FlexFit.loose,
                    flex: 2,
                  ),
                  Spacer(flex: 3)

                ],),


                Row(children: [
                  Spacer(flex: 2,),
                  Text("gender"),
                  Flexible(child:
                  Container(child:
                  dropDown(),
                    margin: EdgeInsets.all(16.0),
                  ),
                    fit: FlexFit.loose,
                    flex: 3,
                  ),
                  Spacer(flex: 1,),
                  Text("interest"),
                  Flexible(child:
                  Container(child:
                  dropDown(),
                    margin: EdgeInsets.all(16.0),),
                    fit: FlexFit.loose,
                    flex: 3,
                  ),
                  Spacer(flex: 1,),
                ],),
              ],)
          ),
            fit: FlexFit.loose,
            flex: 1,
          ),

          Flexible(child:
          Container(
            color: Colors.green,
            child: Row(children: <Widget>[
              Spacer(flex:1),
              RaisedButton(child: Text("Done"), shape: buttonBorderStyle, color: primary,
                onPressed: (){toNewScreen(context);},),
              Spacer(flex: 1,),
            ],),
          ),
            fit: FlexFit.loose,
            flex: 1,
          )

        ],);

  }

  Widget dropDown()
  {
    String startValue = "Male";

    return DropdownButton<String>(
      value: startValue,
      icon: Icon(MdiIcons.arrowDownDropCircle),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: primaryDark,
      ),
      onChanged: (String chosen){},
      items: <String>["Male", "Female"].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  void toNewScreen(context)
  {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PictureScreen()));
  }

}