import 'dart:io';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../color_scheme.dart';
import '../common_widgets.dart';

class PictureScreenWidgets
{

  Widget pictureAppBar(BuildContext context)
  {
    return appBar("Profile picture", Icon(MdiIcons.imageSizeSelectActual), context);
  }
}

Future<File> imageFile;
class PictureScreenBody extends StatefulWidget
{
  Function onCompleteAction;
  PictureScreenBody(this.onCompleteAction);

  @override
  State<StatefulWidget> createState() {
    return _PictureScreenBody(onCompleteAction);
  }

}

class _PictureScreenBody extends State<PictureScreenBody> {
  Function onCompleteAction;

  _PictureScreenBody(this.onCompleteAction);

  @override
  Widget build(BuildContext context) {
    return pictureBody(context);
  }

  Widget pictureBody(BuildContext context) {
    return
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: <Widget>[
          Flexible(child:
          Container(child: showImage(),
          ),
            fit: FlexFit.tight,
            flex: 7,
          ),

          Flexible(child:
          Container(child:
          helpButtons("Press get image and pick a image from your gallery",
              "Make sure that you are in the centre of the image",
              context),
          ),
            fit: FlexFit.tight,
            flex: 1,
          ),

          Flexible(child:
          Container(child:
          Row(children: <Widget>[
            RaisedButton(
              child: Text("get Image"),
              shape: buttonBorderStyle,
              color: primary,
              onPressed: () {
                pickImageFromGallery(ImageSource.gallery);
              },),
            RaisedButton(child: Text("Done"),
              shape: buttonBorderStyle,
              color: primary,
              onPressed: () {
                onCompleteAction.call();
              },),
          ],
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ),
          ),
            fit: FlexFit.tight,
            flex: 2,
          ),
        ],);
  }

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

