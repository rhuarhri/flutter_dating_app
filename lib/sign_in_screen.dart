import 'package:flutter/material.dart';
import 'package:flutterdatingapp/authentication_manager.dart';
import 'package:flutterdatingapp/common_widgets.dart';
import 'package:flutterdatingapp/screen_timer.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'account_screen_code/account_screen.dart';
import './color_scheme.dart';
import './grading_screen.dart';

class SignInScreen extends StatelessWidget{

  bool isSignIn = false;
  bool isSetupRequired = true;
  bool checkingLogin = true;
  AuthManager signUpManager = AuthManager();

  ScreenTimer screenTimer = ScreenTimer();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    signUpManager.getIsSetupRequired().then((value) =>
        {
          isSetupRequired = value,
        }
    );

    signUpManager.isSignIn().then((value) =>
    {
      isSignIn = value,
      checkingLogin = false,
    }
    );

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

    return
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(child:
          Container(
            //color: Colors.green,
            child: Column(children: <Widget>[
              Padding(child: Image.asset("assets/dating_app_icon.png", height: 200, width: 200,),
              padding: EdgeInsets.all(16.0),
              ),
              //Icon(MdiIcons.android, size: 200),
              Text(appName, textScaleFactor: 2.0,),
            ],
            ),
          )
          ),

        ],
      );
  }


  void toAccountScreen(BuildContext context)
  {

    Navigator.push(context, MaterialPageRoute(builder: (context) => AccountAddScreen()));
  }

  void toGradingScreen(BuildContext context)
  {


    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GradingScreen()));
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

    if (isSetupRequired == false && isSignIn == true)
      {
        icon = MdiIcons.arrowRight;
      }
    else
      {
        icon = MdiIcons.login;
      }

    return FloatingActionButton(
      child:
    Icon(icon, color: Colors.white, size: 36,), onPressed: () async
      {

        var status = await Permission.camera.status;

        if (status.isUndetermined)
        {
          Permission.storage.request();
        }

        if(checkingLogin == false) {
          if (isSetupRequired == true || isSignIn == false) {
            _signInActionsDisplay(context);
        }
        else {
         toGradingScreen(context);
        }

      }
        else {
          popup("Checking",
              "Currently checking if you have already setup an account. This should only take a few seconds.",
              context, () {}
          );
        }


      },
      backgroundColor: secondary,);
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
                flex: 3,
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
                      signUpManager.signInWithGoogle(context);
                    },),
                  fit: FlexFit.tight,
                  flex: 3,
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
                  ),
                    shape: buttonBorderStyle,
                    color: primary,
                    onPressed: () {
                    signUpManager.signInWithFacebook(context);
                  }
                  ,),
                  fit: FlexFit.tight,
                  flex: 3,
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
                    onPressed: () {

                      emailSignInPopup(context);

                    },),
                  fit: FlexFit.tight,
                  flex: 3,
                ),
                Spacer(flex: 1,)
              ], mainAxisAlignment: MainAxisAlignment.center,),

            ],
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
          ),)
    );
  }

  void emailSignInPopup(BuildContext context)
  {
    showDialog(context: context, builder: (context){

      TextEditingController emailController = TextEditingController();
      TextEditingController passwordController = TextEditingController();

      return AlertDialog(
        title: Text("sign in with email"),
        content: Container(
          height: 100,
          child: Column(
            children: [
              Flexible(child:
              TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "email"
                  )
              ),
                fit: FlexFit.tight,
                flex: 1,
              ),

              Flexible(child:
              TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "password"
                  )
              ),
                fit: FlexFit.tight,
                flex: 1,
              ),
            ],),),
        actions: [
          FlatButton( child: Text("Sign in"), onPressed: () {
            signUpManager.signInWithEmail(emailController.text, passwordController.text).then((value) =>
                {
                  if (value != "")
                    {
                        errorPopup("Unable to sign up make sure email and password are correct.", context),
                    }
                  else
                    {
                      if (isSetupRequired == true)
                        {
                          toAccountScreen(context),
                        }
                      else
                        {
                          toGradingScreen(context),
                        }
                    }
                }

            );

          }, )
        ],
        shape: buttonBorderStyle,
      );
    }
    );

    }


}


