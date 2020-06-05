import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import './interests_screen.dart';
import './color_scheme.dart';
import './common_widgets.dart';
import './description_analyzer.dart';



class DescriptionScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: descriptionAppBar(context),
      body: DescriptionBody(),
    );
  }

  Widget descriptionAppBar(BuildContext context) {
    return appBar("Profile description", Icon(MdiIcons.cardText), context);

    /*
    return AppBar(
      leading:
      Row (children: <Widget>[
        Flexible(child:
        IconButton(icon: Icon(MdiIcons.arrowLeft), tooltip: "go back",
          onPressed: (){Navigator.pop(context);},),
          fit: FlexFit.tight,
          flex: 1,
        ),
        Flexible(child:
        Icon(MdiIcons.cardText),
          fit: FlexFit.tight,
          flex: 1,
        ),
      ],),
      title: Text("Profile description"),
      centerTitle: true,
    );*/
  }
}

  class DescriptionBody extends StatefulWidget {
    @override
    State<StatefulWidget> createState() {
      return _DescriptionBody();
    }
  }

  class _DescriptionBody extends State<DescriptionBody>
  {
    TextEditingController descriptionController = TextEditingController();
    int wordLimit = 1000; //characters
    //This 1000 character limit is based on 1 unit of work defined by google cloud
    //units of work is how google cloud measures price.

    int characterAmount = 0;

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


              /*
              DescriptionAnalyzer analyzer = DescriptionAnalyzer();

              String test = "I enjoy flutter but hate Net";
              analyzer.analyze(test, context);*/


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
                toNewScreen(context);
              }
            }

               */
            toNewScreen(context);

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

  void toNewScreen(context)
  {
    Navigator.push(context, MaterialPageRoute(builder: (context) => InterestsScreen()));
  }

  }
