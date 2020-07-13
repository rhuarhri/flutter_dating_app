import 'package:flutter/material.dart';
import 'package:flutterdatingapp/database_management_code/online_database.dart';
import '../common_widgets.dart';
import './picture_screen_widgets.dart';
import 'dart:io';


class PictureUpdateScreen extends StatelessWidget
{



  @override
  Widget build(BuildContext context) {

    Function onCompleteAction = () async
    {
      File image = await imageFile;

      if (image != null)
      {
        OnlineDatabaseManager uploadImage = OnlineDatabaseManager();
        uploadImage.updateImage(image);

        Navigator.pop(context);
      }
    else
      {
          popup("Image upload", "Unable to load image pleas try again", context, null);
      }
    };

    return Scaffold(
      appBar: PictureScreenWidgets().pictureAppBar(context),
      body: PictureScreenBody(onCompleteAction),
    );
  }


}
