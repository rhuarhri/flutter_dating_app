import 'package:flutter/material.dart';
import '../description_screen_code/description_screen.dart';
import './picture_screen_widgets.dart';
import 'dart:io';


class PictureUpdateScreen extends StatelessWidget
{



  @override
  Widget build(BuildContext context) {

    Function onCompleteAction = () async
    {
      Future<File> image = imageFile;

      /*if (imageFile != null)
      {
        OnlineDatabaseManager uploadImage = OnlineDatabaseManager();
        uploadImage.addImage(await imageFile);

        Navigator.push(context, MaterialPageRoute(builder: (context) => DescriptionScreen()));
      }
    else
      {
          popup("Image upload", "Unable to load image pleas try again", context, (){});
      }*/

      //TODO update user image

      Navigator.pop(context);
    };

    return Scaffold(
      appBar: PictureScreenWidgets().pictureAppBar(context),
      body: PictureScreenBody(onCompleteAction),
    );
  }


}
