import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutterdatingapp/database_management_code/online_database.dart';
import 'package:flutterdatingapp/face_detection.dart';
import '../common_widgets.dart';
import '../description_screen_code/description_screen.dart';
import './picture_screen_widgets.dart';


class PictureScreen extends StatelessWidget
{

  @override
  Widget build(BuildContext context) {

    Function onCompleteAction = () async
    {
        File image = await imageFile;

      if (imageFile != null)
      {

        FaceDetection detector = FaceDetection();
        detector.search(image);

        OnlineDatabaseManager uploadImage = OnlineDatabaseManager();
        uploadImage.addImage(await imageFile);

        Navigator.push(context, MaterialPageRoute(builder: (context) => DescriptionScreen()));
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
