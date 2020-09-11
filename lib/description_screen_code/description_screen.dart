import 'package:flutter/material.dart';
import 'package:flutterdatingapp/database_management_code/online_database.dart';
import 'package:flutterdatingapp/record_video.dart';
import '../description_analyzer.dart';
import '../interests_screen_code/interests_screen.dart';
import '../common_widgets.dart';
import './description_screen_widgets.dart';



class DescriptionScreen extends StatelessWidget {


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
                DescriptionAnalyzer().analyze(description, context);
                toNextScreen(context, description);

              }
            }

    };

    return DescriptionBody(onCompleteAction, context);
  }

  void toNextScreen(BuildContext context, String description) async
  {

    OnlineDatabaseManager onlineManager = OnlineDatabaseManager();
    bool isDone = await onlineManager.addUserDescription(description);
    //isDone makes the app await

    Navigator.push(context, MaterialPageRoute(builder: (context) =>
        VideoRecorderScreen(description: description,)));

  }

}





