import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterdatingapp/common_widgets.dart';
import 'package:flutterdatingapp/database_management_code/database.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthManager
{

  bool _isSetupRequired = true;
  Future<bool> getIsSetupRequired() async
  {
    bool isEmpty = await DBProvider.db.isDatabaseEmpty();
    return isEmpty;
  }

  void _setIsSetupRequired(AuthResult result)
  {
    _isSetupRequired = result.additionalUserInfo.isNewUser;
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  void signInWithGoogle(BuildContext context) async
  {

    signInErrorAlert(context);
  }

  void signInWithFacebook(BuildContext context)
  {
    signInErrorAlert(context);
  }

  Future<String> signInWithEmail(String email, String password) async
  {
    bool isEmpty = await DBProvider.db.isDatabaseEmpty();

    try{
      AuthResult result;
      if (isEmpty == true)
        {
          result = await auth.createUserWithEmailAndPassword(email: email, password: password);
          print("create user");
        }
      else
        {
          result = await auth.signInWithEmailAndPassword(email: email, password: password);
          print("sign in user");
        }

      _setIsSetupRequired(result);
      FirebaseUser user = result.user;
      return "";
    }
    catch(e)
    {
      return e.toString();
    }

  }

  Future<bool> isSignIn() async
  {
    FirebaseUser user = await auth.currentUser();
    if (user != null)
      {
        return true;
      }
    else
      {
        return false;
      }
  }

  void signOut()
  {
    auth.signOut();
  }

  bool isExistingUser()
  {
    return false;
  }

  void deleteAccount() async
  {
    FirebaseUser user = await auth.currentUser();
    String userId = user.uid;
    user.delete();
  }

  void signInErrorAlert(BuildContext context)
  {
    popup("Error", "This is not currently available use so sign in with email. ", context, null);
  }

}