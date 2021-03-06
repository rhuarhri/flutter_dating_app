import 'package:flutter/material.dart';
import 'package:flutterdatingapp/database_management_code/online_database.dart';
import 'account_screen_widgets.dart';
import '../common_widgets.dart';

class AccountUpdateScreen extends StatelessWidget
{

  @override
  Widget build(BuildContext context) {
    Function onCompleteAction = () {
      OnlineDatabaseManager manager = OnlineDatabaseManager();

    if (userNameController.text != "" && userAgeController.text != "")
    {

      String name = userNameController.text;
      int age = int.parse(userAgeController.text);

      String error = manager.update(name, age, gender, lookingFor);

      if (error == "")
      {
        //success
        Navigator.pop(context);
      }
      else
      {
        popup("Error", error, context, (){});
      }

    }
    else
    {
      popup("Error", "You must enter a value for name and age", context, (){});
    }

    };

    return Scaffold(
      appBar: AccountScreenWidgets().accountAppBar(context),
      body: AccountScreenWidgets().accountBody(onCompleteAction, context),
    );
  }

}