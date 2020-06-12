import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../color_scheme.dart';
import '../common_widgets.dart';

class AccountScreenWidgets {

  final userNameController = TextEditingController();
  final userAgeController = TextEditingController();

  String gender = "Male";
  String lookingFor = "Male";

  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: accountAppBar(context),
      body: accountBody((){print("not this");}, context),
    );
  }*/

  Widget accountAppBar(BuildContext context) {
    return appBar("Create Account", Icon(MdiIcons.account), context);
  }


  Widget accountBody(Function onCompleteAction, BuildContext context) {
    return
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Flexible(child:
          Container(
            //color: Colors.yellow,
              child:
              Column(children: <Widget>[

                Row(children: <Widget>[
                  Spacer(flex: 1),
                  Text("name",),
                  Flexible(child:
                  Container(child:
                  TextField(
                      controller: userNameController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "add your name"
                      )
                  ),
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(bottom: BorderSide(color: primaryDark))
                    ),
                    margin: EdgeInsets.all(16.0),
                  ),
                    fit: FlexFit.loose,
                    flex: 2,
                  ),
                  Spacer(flex: 1,),
                ],),


                Row(children: <Widget>[
                  Spacer(flex: 3),
                  Text("age"),
                  Flexible(child:
                  Container(child:
                  TextField(
                      controller: userAgeController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "add your age"
                      )
                  ),
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(bottom: BorderSide(color: primaryDark))
                    ),
                    margin: EdgeInsets.all(16.0),
                  ),
                    fit: FlexFit.loose,
                    flex: 2,
                  ),
                  Spacer(flex: 3)

                ],),


                Row(children: [
                  Spacer(flex: 2,),
                  Text("gender"),
                  Flexible(child:
                  Container(child:
                  DropdownStatefulWidget((String value) {
                    gender = value;
                  }),
                    margin: EdgeInsets.all(16.0),
                  ),
                    fit: FlexFit.loose,
                    flex: 3,
                  ),
                  Spacer(flex: 1,),
                  Text("looking for"),
                  Flexible(child:
                  Container(child:
                  DropdownStatefulWidget((String value) {
                    lookingFor = value;
                  }),
                    margin: EdgeInsets.all(16.0),),
                    fit: FlexFit.loose,
                    flex: 3,
                  ),
                  Spacer(flex: 1,),
                ],),
              ],)
          ),
            fit: FlexFit.tight,
            flex: 5,
          ),

          Flexible(child:
          Container(
            //color: Colors.green,
            child: Row(children: <Widget>[
              Spacer(flex: 1),
              RaisedButton(
                child: Text("Done"), shape: buttonBorderStyle, color: primary,
                onPressed: () {
                  //toNewScreen(context);
                  onCompleteAction.call();
                },),
              Spacer(flex: 1,),
            ],),
          ),
            fit: FlexFit.tight,
            flex: 1,
          )

        ],);
  }





}

class DropdownStatefulWidget extends StatefulWidget {
  final Function returnData;

  DropdownStatefulWidget(this.returnData);

  @override
  State<StatefulWidget> createState() {
    return _DropdownStatefulWidget(returnData);
  }
}

class _DropdownStatefulWidget extends State<DropdownStatefulWidget> {
  String currentValue = "Male";

  final Function returnData;

  _DropdownStatefulWidget(this.returnData);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: currentValue,
      icon: Icon(
        MdiIcons.arrowDownDropCircle,
        color: primaryDark,
      ),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: primaryDark,
      ),
      onChanged: (String chosen) {
        setState(() {
          currentValue = chosen;
        });

        returnData.call(chosen);
      },
      items: <String>["Male", "Female"]
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
