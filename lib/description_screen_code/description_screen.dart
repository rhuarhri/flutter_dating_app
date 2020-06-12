import 'package:flutter/material.dart';
import 'package:flutterdatingapp/database_management_code/database.dart';
import 'package:flutterdatingapp/database_management_code/online_database.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../interests_screen.dart';
import '../color_scheme.dart';
import '../common_widgets.dart';
import '../description_analyzer.dart';
import './description_screen_widgets.dart';



class DescriptionScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    Function onCompleteAction = ()
    {

      /*if (characterAmount > wordLimit)
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
                *//*setState(() {
                  isLoading = true;
                });*//*

                DescriptionAnalyzer analyzer = DescriptionAnalyzer();

                String description = descriptionController.text;
                analyzer.analyze(description, context);

                OnlineDatabaseManager onlineManager = OnlineDatabaseManager();
                onlineManager.addUserDescription(description);

                Navigator.push(context, MaterialPageRoute(builder: (context) => InterestsScreen()));
              }
            }*/



      Navigator.push(context, MaterialPageRoute(builder: (context) => InterestsScreen()));
    };

    return Scaffold(
      appBar: DescriptionScreenWidgets().descriptionAppBar(context),
      body: DescriptionBody(onCompleteAction),
    );
  }




}


