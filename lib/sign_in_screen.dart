import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import './account_screen.dart';
import './color_scheme.dart';

class SignInScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: signInAppBar(), body: signInBody(context),);
  }


  Widget signInAppBar() {
    return AppBar(
      leading: Icon(MdiIcons.login),
      title: Text("Sign In"),
      centerTitle: true,
    );
  }

  Widget signInBody(BuildContext context) {
    return
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(child:
          Container(
            //color: Colors.green,
            child: Column(children: <Widget>[
              Icon(MdiIcons.android, size: 200),
              Text("App title", textScaleFactor: 2.0,),
            ],
            ),
          )
          ),
          Expanded(child:
          Container(
            //color: Colors.blue,
            child:
            Column(
              children: <Widget>[
                Text("By signing up you agree to the terms and conditions"),
                IntrinsicWidth( //This ensures that all widgets are the same size as the largest widget
                  child: Column(
                    children: <Widget>[
                      RaisedButton(child:
                      Row(children: <Widget>[
                        Icon(MdiIcons.google, size: 40,),
                        Text("Sign in with Google", textScaleFactor: 1.2,)
                      ],
                        //mainAxisAlignment: MainAxisAlignment.start,
                      ),
                        shape: buttonBorderStyle,
                        color: primary,
                        onPressed: () {},),
                      RaisedButton(child:
                      Row(children: <Widget>[
                        Icon(MdiIcons.facebook, size: 40,),
                        Text("Sign in with Facebook", textScaleFactor: 1.2,)
                      ],
                        //mainAxisAlignment: MainAxisAlignment.start,
                      ),
                        shape: buttonBorderStyle,
                        color: primary,
                        onPressed: () {},),
                      RaisedButton(child:
                      Row(children: <Widget>[
                        Icon(MdiIcons.email, size: 40,),
                        Text("Sign in with email", textScaleFactor: 1.2,)
                      ],
                        //mainAxisAlignment: MainAxisAlignment.start,
                      ),
                        shape: buttonBorderStyle,
                        color: primary,
                        onPressed: () {toNewScreen(context);},),
                    ],
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.end,
            ),
          )
          ),
        ],
      );
  }


  void toNewScreen(context)
  {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AccountScreen()));
  }


}


