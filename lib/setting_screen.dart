import 'package:flutterdatingapp/database_management_code/online_database.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import './color_scheme.dart';
import './common_widgets.dart';
import 'package:flutter/material.dart';
import 'authentication_manager.dart';
import 'database_management_code/database.dart';
import 'database_management_code/internal/DataModels.dart';

class SettingScreen extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("settings", Icon(MdiIcons.cog), context),
      body: SettingBody(),
    );
  }

}

class SettingBody extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    return _SettingBody();
  }
  
}

class _SettingBody extends State<SettingBody>
{

  double distance = 0;
  RangeValues ageRange = RangeValues(19, 25);
  double accuracy = 0;

  void setUp() async
  {
    UserInfo userInfo;

    userInfo = await DBProvider.db.getUser();

    distance = userInfo.distance;
    print("distance is " + distance.toString());

    double minAge = 0.0 + userInfo.minAge;
    print("min age " + minAge.toString());
    double maxAge = 0.0 + userInfo.maxAge;
    print("max age " + maxAge.toString());
    ageRange = RangeValues(minAge, maxAge);

    accuracy = 0.0 + userInfo.accuracy;


    setState(() {

    });
  }

  void checkData() async
  {
    UserInfo userInfo;

    userInfo = await DBProvider.db.getUser();

    distance = userInfo.distance;
    print("distance is " + distance.toString());

    double minAge = 0.0 + userInfo.minAge;
    print("min age " + minAge.toString());
    double maxAge = 0.0 + userInfo.maxAge;
    print("max age " + maxAge.toString());
  }

  bool isSetup = false;

  @override
  Widget build(BuildContext context) {

    if (isSetup == false) {
      setUp();
      isSetup = true;
    }

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Spacer(flex: 1,),

        Flexible(child: Text("Distance", textScaleFactor: 2.0,),
        fit: FlexFit.loose,
          flex: 1,
        ),

        Flexible(child:
          Slider(
            activeColor: secondary,
            inactiveColor: primaryLight,
            value: distance,
            onChanged: (newValue)
            {
              setState(() {
                distance = newValue;
              });

              DBProvider.db.updateDistance(distance);

              checkData();
            },
            divisions: 100,
            min: 0,
            max: 100,
            label: "${distance.round()}",
          ),
        fit: FlexFit.loose,
          flex: 1,
        ),

        Flexible(child:Text("Age Range", textScaleFactor: 2.0,),
        fit: FlexFit.loose,
          flex: 1,
        ),

        Flexible(child: RangeSlider(
          activeColor: secondary,
          inactiveColor: primaryLight,
          values: ageRange,
          onChanged: (newValue)
          {
            setState(() {
              ageRange = newValue;
            });
            DBProvider.db.updateAgeRange(ageRange.start.round(), ageRange.end.round());

            checkData();
          },
          divisions: (80 - 18),
          min: 18,
          max: 80,
          labels: RangeLabels("${ageRange.start.round()}", "${ageRange.end.round()}"),
        ),
        fit: FlexFit.loose,
          flex: 1,
        ),

          Flexible(child: Text("Accuracy", textScaleFactor: 2.0,),
            fit: FlexFit.loose,
            flex: 1,
          ),

          Flexible(child: Text("How much like you they should be."),
            fit: FlexFit.loose,
            flex: 1,
          ),

          Flexible(child:
          Slider(
            activeColor: secondary,
            inactiveColor: primaryLight,
            value: accuracy,
            onChanged: (newValue)
            {
              setState(() {
                accuracy = newValue;
              });

              DBProvider.db.updateAccuracy(accuracy.round());

              checkData();
            },
            divisions: 100,
            min: 0,
            max: 100,
            label: "${accuracy.round()}",
          ),
            fit: FlexFit.loose,
            flex: 1,
          ),

        Spacer(flex: 2,),

        Flexible(child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          FlatButton(child: Text("Log out"), onPressed: (){
            AuthManager auth = AuthManager();
            auth.signOut();
          },
            color: primary,
          ),
        ],),
        fit: FlexFit.loose,
          flex: 1,
        ),

        Flexible(child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FlatButton(child: Text("Delete account"), onPressed: (){
              popup("Delete", "Are you sure you want to delete your account?", context,
                      () {
                        //TODO delete account code
                        OnlineDatabaseManager onlineManager = OnlineDatabaseManager();
                        onlineManager.deleteOnlineInformation();
                        //DBProvider.db.deleteAll();
                        AuthManager authManger = AuthManager();
                        authManger.deleteAccount();

                      });
            },
              color: primary,
            ),
          ],),
            fit: FlexFit.loose,
            flex: 1,)
      ],),
    );
  }
  
}