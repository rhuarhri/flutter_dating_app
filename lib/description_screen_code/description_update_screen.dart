import 'package:flutter/material.dart';
import 'package:flutterdatingapp/database_management_code/online_database.dart';
import '../common_widgets.dart';
import './description_screen_widgets.dart';

class DescriptionUpdateScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    Function onCompleteAction = ()
    {

      if (characterAmount > wordLimit)
            {
              popup("Error", "Description too long.", context, (){});
            }
            else
            {
              if (characterAmount == 0)
              {
                popup("Error", "You must add a description.", context, (){});
              }
              else
              {

                String description = descriptionController.text;
                toNextScreen(context, description);
              }
            }

      Navigator.pop(context);
    };

    return DescriptionBody(onCompleteAction, context);

  }

  void toNextScreen(BuildContext context, String description) async
  {

    OnlineDatabaseManager onlineManager = OnlineDatabaseManager();
    bool isDone = await onlineManager.addUserDescription(description);
    //isDone makes the app await

    Navigator.pop(context);
  }

}