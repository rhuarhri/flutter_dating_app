import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterdatingapp/camera_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutterdatingapp/common_widgets.dart';

import './color_scheme.dart';
import 'database_management_code/online_database.dart';
import 'face_detection.dart';
import 'interests_screen_code/interests_screen.dart';


class VideoRecorderScreen extends StatelessWidget
{
  String description = "";

  VideoRecorderScreen({Key key, @required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VideoRecorderBody(description);
  }

}

class VideoRecorderBody extends StatefulWidget
{
  String description = "";
  VideoRecorderBody(this.description);

  @override
  State<StatefulWidget> createState() {
    return _VideoRecorderBody(description);
  }

}

class _VideoRecorderBody extends State<VideoRecorderBody>
{
  String description = "";

  _VideoRecorderBody(this.description);

  CameraHandler camera = CameraHandler();

  String imagePath = "";

  AppTimer cameraTimer = AppTimer();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    camera.dispose();
    super.dispose();
  }

  bool isSetup = false;
  Future<void> setup(BuildContext context) async {

    await camera.setup();

    startPopup(context);
    setState(() {
      isSetup = true;
    });
  }

  @override
  Widget build(BuildContext context) {

    autoStopVideo();

    return Scaffold(
      body: screenBody(context),
      bottomNavigationBar: footer(context),
    );
  }

  Widget screenBody(BuildContext context)
  {
    if (isSetup == false) {
      setup(context);
    }

    return
    CustomScrollView(
      slivers: <Widget>[

        SliverAppBar(

          backgroundColor: primary,
          expandedHeight: MediaQuery
              .of(context)
              .size
              .height * .85,
          //85% screen height

          flexibleSpace: FlexibleSpaceBar(
            background: camera.cameraPreview(isSetup),
          ),
        ),
        SliverFixedExtentList(
          itemExtent: MediaQuery
              .of(context)
              .size
              .height * .40, //40% screen height
          delegate: SliverChildListDelegate(
            [
              Container(
                  child: Column(children: <Widget>[
                    Text("Transcript"),
                    Text(description),
                  ],),
                  color: Colors.white
              ),
            ],
          ),
        ),
      ],
      shrinkWrap: true,
    );


  }

  Widget footer(BuildContext context)
  {
    return Container(child: Column(children: [
    Row(children: [
      IconButton(icon: Icon(MdiIcons.rotate3DVariant, color: Colors.black, size: 36), onPressed: () async {
        await camera.swapCamera();
        setState(() {

        });
      },),

      recordButton(context),

      helpButtons("If you don't know what to say your description is displayed at the bottom of the screen. Swipe up to see it.",
          "Keep yourself in the center of the screen.", context),

    ],
      mainAxisAlignment: MainAxisAlignment.spaceAround,
    ),

      cameraTimer.display(),
    ],),
      color: primaryLight,
      height: 60,
    );
  }

  Widget recordButton(BuildContext context)
  {
    Widget buttonIcon;

    if (isSetup == true) {
      if (camera.isRecording() == false) {
        buttonIcon = Icon(MdiIcons.recordRec, color: secondary, size: 36);
        print("ready to record icon");
      }
      else {
        buttonIcon = Icon(MdiIcons.stopCircleOutline, color: secondary, size: 36);
        print("recording icon");
      }
    }
    else
      {
        buttonIcon = Icon(MdiIcons.alert, color: secondary, size: 36);
      }

    return IconButton(icon: buttonIcon,
      onPressed: () async {
      if (isSetup == true) {
        if (camera.isRecording() == false) {
          await camera.start();

          Function test = (){setState(() {});};
          cameraTimer.start(test);
        }
        else {
          cameraTimer.stop();
          camera.stop().then((value) {
            imagePath = value;
            showImagePreview(context);
          });
        }
      }
      setState(() {

      });
    },);
  }

  startPopup(BuildContext context)
  {
    String title = "Do you want to record a video?";
    String content = "Recording a video is entirely optional. " +
        "If you record a video may improve your chances, as people can clearly see " +
    "what you are like.";

    Function getImage = () async {
      File imageFile;

      imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

      imagePath = imageFile.path;

      saveImage(imagePath);

      toNextScreen();
    };

    return showDialog(context: context, barrierDismissible: false,
        builder: (context) {
      return AlertDialog(
          title: Text(title),
          content: Text(content),
          elevation: 24.0,
          actions: [
            FlatButton(child: Text("No"), onPressed: getImage,),
            FlatButton(child: Text("yes"), onPressed: (){Navigator.pop(context);},)
            ],

      );
    });
  }

  showImagePreview(BuildContext context)
  {
    String title = "Do you like this image?";

    File imageFile = File(imagePath);

    Widget content = Image.file(imageFile, height: 200, width: 200,);

    Function acceptImage = (){
      saveImage(imagePath);
      saveVideo(camera.videoPath);
      toNextScreen();
    };

    Function getImage = () async {
      File imageFile;

      imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

      imagePath = imageFile.path;

      saveImage(imagePath);
      saveVideo(camera.videoPath);
      toNextScreen();
    };

    return showDialog(context: context, barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
          title: Text(title),
        content: content,
        actions: [
          FlatButton(child: Text("No"), onPressed: getImage,),
          FlatButton(child: Text("Yes"), onPressed: acceptImage,),
        ],
      );
    });


  }

  void autoStopVideo()
  {
    if (cameraTimer.progress >= 1)
      {
        camera.stop().then((value) {
          imagePath = value;
          showImagePreview(context);
        });

        setState(() {

        });
      }
  }

  void saveVideo(String videoPath)
  {
    File videoFile = File(videoPath);

    OnlineDatabaseManager uploadVideo = OnlineDatabaseManager();
    uploadVideo.addVideo(videoFile);
  }

  void saveImage(String imagePath) async
  {
    File imageFile = File(imagePath);

    FaceDetection detector = FaceDetection();
    detector.search(imageFile);

    OnlineDatabaseManager uploadImage = OnlineDatabaseManager();
    uploadImage.addImage(imageFile);
  }

  void toNextScreen()
  {
    Navigator.push(context, MaterialPageRoute(builder: (context) =>
        InterestScreen()));
  }


}