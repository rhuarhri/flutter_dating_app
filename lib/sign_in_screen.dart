import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import './account_screen.dart';
import './color_scheme.dart';
import './sign_in_handler.dart';
import './grading_screen.dart';

class SignInScreen extends StatelessWidget{

  bool isSignIn = true;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: signInAppBar(), body: signInBody(context),
      floatingActionButton: actionBTN(context),);
  }


  Widget signInAppBar() {
    return AppBar(
      leading: Icon(MdiIcons.login),
      title: Text("Sign In"),
      centerTitle: true,
    );
  }

  Widget signInBody(BuildContext context) {


    if(isSignIn == false) {
      //_signInActionsDisplay(context);
    }

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


          /*Expanded(child:
          Container(
            //color: Colors.blue,
            child:
            Column(
              children: <Widget>[

                IntrinsicWidth( //This ensures that all widgets are the same size as the largest widget
                  child: Column(
                    children: <Widget>[

                      RaisedButton(child: Text("Terms and conditions", textScaleFactor: 1.2,), onPressed: (){
                          showTerms(context);
                      },
                        shape: buttonBorderStyle,
                        color: primary,
                      ),

                      RaisedButton(child:
                      Row(children: <Widget>[
                        Icon(MdiIcons.google, size: 40,),
                        Text("Sign in with Google", textScaleFactor: 1.2,)
                      ],
                        //mainAxisAlignment: MainAxisAlignment.start,
                      ),
                        shape: buttonBorderStyle,
                        color: primary,
                        onPressed: () {
                        signInWithGoogle();
                        },),


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
          ),*/
        ],
      );
  }


  void toNewScreen(context)
  {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AccountScreen()));
  }

  void showTerms(BuildContext context)
  {
      showAboutDialog(context: context,
      applicationVersion: "0.0",
        applicationLegalese: "This version of the app is in a testing phase. During this testing phase "
        + "you will be provided with dummy information and anything you do on the app will be recorded. " +
            "If feel you are unable or not willing to participate then you can withdraw by contacting " +
            "Rhuarhri Cordon. If you withdraw or the test comes to an end all your personal information will "+
            "be removed. All these tests help make a better app in the future. Thank you for your participation.",
      );
  }

  Widget actionBTN(BuildContext context)
  {

    IconData icon;
    //Function action = (){};

    if (isSignIn == true)
      {
        icon = MdiIcons.arrowRight;
        /*action = (context) {

        };*/

      }
    else
      {
        icon = MdiIcons.login;
        //action = (){};
        /*action = (context) {
          //_signInActionsDisplay(context);
        };*/
      }

    return FloatingActionButton(child:
    Icon(icon, color: Colors.black, size: 36,), onPressed: ()
      {
        if(isSignIn == false)
          {
            _signInActionsDisplay(context);
          }
        else {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => GradingScreen()));
        }
      },
      backgroundColor: primary,);
  }

  void _signInActionsDisplay(BuildContext context)
  {
    scaffoldKey.currentState.showBottomSheet((context) =>

        Container(
          height: MediaQuery.of(context).size.height * .60,

          child : Column(
            children: <Widget>[

              Row(children: <Widget>[
                Spacer(flex: 1,),
                Flexible(child:
                RaisedButton(child: Text("Terms and conditions", textScaleFactor: 1.2,), onPressed: (){
                  showTerms(context);
                },
                  shape: buttonBorderStyle,
                  color: primary,
                ),
                fit: FlexFit.tight,
                flex: 2,
                ),
                Spacer(flex: 1,)
              ],
              mainAxisAlignment: MainAxisAlignment.center,
              ),

              Row(children: <Widget>[
                Spacer(flex: 1),
                Flexible(child:
                  RaisedButton(child:
                  Row(children: <Widget>[
                    Icon(MdiIcons.google, size: 40,),
                    Text("Sign in with Google", textScaleFactor: 1.2,)
                  ],
                  //mainAxisAlignment: MainAxisAlignment.start,
                  ),
                    shape: buttonBorderStyle,
                    color: primary,
                    onPressed: () {
                      signInWithGoogle();
                    },),
                  fit: FlexFit.tight,
                  flex: 2,
                ),
                Spacer(flex: 1,)
              ],
              mainAxisAlignment: MainAxisAlignment.center,
              ),

              Row(children: <Widget>[
                Spacer(flex: 1),
                Flexible(child:
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
                  fit: FlexFit.tight,
                  flex: 2,
                ),
                Spacer(flex: 1,)
              ], mainAxisAlignment: MainAxisAlignment.center,),

              Row(children: [
                Spacer(flex: 1),
                Flexible(child:
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
                  fit: FlexFit.tight,
                  flex: 2,
                ),
                Spacer(flex: 1,)
              ], mainAxisAlignment: MainAxisAlignment.center,),

              /*IntrinsicWidth(//This ensures that all widgets are the same size as the largest widget
                child: Column(
                  children: <Widget>[










              )*/
            ],
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
          ),)
    );
    //});
  }

}


