import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../color_scheme.dart';
import '../common_widgets.dart';

class DescriptionScreenWidgets
{
  Widget descriptionAppBar(BuildContext context) {
    return appBar("Profile description", Icon(MdiIcons.cardText), context);
  }

}

class DescriptionBody extends StatefulWidget {

  Function onCompleteAction;
  DescriptionBody(this.onCompleteAction);

  @override
  State<StatefulWidget> createState() {
    return _DescriptionBody(onCompleteAction);
  }
}

TextEditingController descriptionController = TextEditingController();
int wordLimit = 1000; //characters
//This 1000 character limit is based on 1 unit of work defined by google cloud
//units of work is how google cloud measures price.

int characterAmount = 0;



class _DescriptionBody extends State<DescriptionBody>
{
  Function onCompleteAction;
  _DescriptionBody(this.onCompleteAction);


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,

      children: <Widget>  [
        Flexible(child:
        Container(child: TextField(
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "add a description of yourself"
          ),
          maxLines: null,
          controller: descriptionController,
          onChanged: (String text){
            setState(() {
              characterAmount = descriptionController.text.length;
            });
          },
        ),
          //color: Colors.green,
        ),
          fit: FlexFit.tight,
          flex: 7,
        ),

        Flexible(
          child: Container(child: Text(characterAmount.toString() + "/" + wordLimit.toString()),),
          fit: FlexFit.tight,
          flex: 1,
        ),

        Flexible(child:
        Container(child:
        helpButtons("A description can help someone understand what you are like.",
            "Beware of spelling mistakes.",
            context),
          //color: Colors.yellow,
        ),
          fit: FlexFit.tight,
          flex: 1,
        ),

        loadingDisplay(),

        //progressBar(),
        //CircularProgressIndicator(),
      ],);
  }

  bool isLoading = false;
  Widget loadingDisplay()
  {
    if (isLoading == true)
    {
      return
        Flexible(child: LinearProgressIndicator(), fit: FlexFit.loose, flex: 2,);
      //progressBar();

    }
    else
    {
      return DoneBTN();

    }
  }

  Widget DoneBTN()
  {
    return
      Flexible(child:
      Container(child:
      Row(children: <Widget>[

        RaisedButton(child: Text("Done"),
          shape: buttonBorderStyle,
          color: primary,
          onPressed: (){

            setState(() {
              isLoading = true;
            });

          onCompleteAction.call();


          },)
      ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),

        //color: Colors.blue,
      ),
        fit: FlexFit.tight,
        flex: 2,
      );
  }

}