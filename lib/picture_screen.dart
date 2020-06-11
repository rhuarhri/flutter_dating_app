import 'dart:io';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:image_picker/image_picker.dart';
import './description_screen.dart';
import './color_scheme.dart';
import './common_widgets.dart';

import 'database_management_code/online_database.dart';


class PictureScreen extends StatelessWidget
{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: pictureAppBar(context),
      body: PictureScreenBody(),
    );
  }

  Widget pictureAppBar(BuildContext context)
  {
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
        Icon(MdiIcons.imageSizeSelectActual),
          fit: FlexFit.tight,
          flex: 1,
        ),
      ],),
      title: Text("Profile picture"),
      centerTitle: true,
    );
  }



}

class PictureScreenBody extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    return _PictureScreenBody();
  }

}

class _PictureScreenBody extends State<PictureScreenBody>
{
  @override
  Widget build(BuildContext context) {
    return pictureBody(context);
  }

  Widget pictureBody(BuildContext context)
  {
    return
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: <Widget>[
          Flexible(child:
          Container(child: showImage(),//Text("image"),
            //color: Colors.green,
          ),
            fit: FlexFit.tight,
            flex: 7,
          ),

          Flexible(child:
          Container(child:
          helpButtons("Press get image and pick a image from your gallery",
                       "Make sure that you are in the centre of the image",
                        context),
            //color: Colors.yellow,
          ),
            fit: FlexFit.tight,
            flex: 1,
          ),

          Flexible(child:
          Container(child:
          Row(children: <Widget>[
            RaisedButton(child: Text("get Image"), shape: buttonBorderStyle, color: primary,
              onPressed: (){pickImageFromGallery(ImageSource.gallery);},),
            RaisedButton(child: Text("Done"), shape: buttonBorderStyle, color: primary,
              onPressed: (){toNewScreen(context);},),
          ],
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ),
            //color: Colors.blue,
          ),
            fit: FlexFit.tight,
            flex: 2,
          ),
        ],);

  }



  void toNewScreen(context) async
  {

    if (imageFile != null)
      {
        OnlineDatabaseManager uploadImage = OnlineDatabaseManager();
        uploadImage.addImage(await imageFile);

        Navigator.push(context, MaterialPageRoute(builder: (context) => DescriptionScreen()));
      }
    else
      {
          popup("Image upload", "Unable to load image pleas try again", context, (){});
      }

    //Navigator.push(context, MaterialPageRoute(builder: (context) => DescriptionScreen()));
  }

  Future<File> imageFile;
  void pickImageFromGallery(ImageSource source)
  {
    setState(() {
      imageFile = ImagePicker.pickImage(source: source);
    });

  }


  Widget showImage()
  {
    return FutureBuilder<File>(
      future: imageFile,
      builder: (BuildContext context, AsyncSnapshot snapshot)
      {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data != null)
          {
            return Image.file(snapshot.data, height: 300, width: 300);
          }
        else
          {
            return Text("unable to get image please try again");
          }
      },
    );
  }

}