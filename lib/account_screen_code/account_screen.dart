import 'package:flutter/material.dart';
import '../picture_screen_code/picture_screen.dart';
import 'account_screen_widgets.dart';


class AccountAddScreen extends StatelessWidget
{

  @override
  Widget build(BuildContext context) {

    Function onCompleteAction = ()
    {
      /*OnlineDatabaseManager manager = OnlineDatabaseManager();

    if (userNameController.text != "" && userAgeController.text != "")
    {

      String name = userNameController.text;
      int age = int.parse(userAgeController.text);

      String error = manager.add(name, age, gender, lookingFor);

      if (error == "")
      {
        //success
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PictureScreen()));
      }
      else
      {
        popup("Error", error, context, (){});
      }

    }
    else
    {
      popup("Error", "You must enter a value for name and age", context, (){});
    }*/

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PictureScreen()));
    };

    return Scaffold(
      appBar: AccountScreenWidgets().accountAppBar(context),
      body: AccountScreenWidgets().accountBody(onCompleteAction, context),
    );
  }




}

