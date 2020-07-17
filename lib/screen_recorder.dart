import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screen_recording/flutter_screen_recording.dart';
import 'package:permission_handler/permission_handler.dart';
import './color_scheme.dart';

class Recorder
{
  static String _fileName = "AppScreenRecording " + Random().nextInt(100).toString();
  String _message = "The app will start recording your screen. This is to see how you use the app. "
      + "Knowing this allows me to find problems with the app as if you have a problem I will be able to see it. "
      + "The screen recording will be in the DCIM file of your smartphone. It will be called " + _fileName +
      ". Please send it to me.";

  showStartRecordingAlert(BuildContext context)
  {
    return showDialog(context: context, builder: (context)
    {
      return AlertDialog(
        title: Text("Testing"),
        content: Text(_message),
        elevation: 24.0,
        shape: buttonBorderStyle,
        actions: [
          FlatButton(child: Text("Start Recording"), onPressed: () {
            _requestPermissionsForRecording();
            Navigator.pop(context);
            //start();
          },)
        ],
      );
    });
  }

  void start() async
  {
    var status = await Permission.storage.status;

    if (status.isUndetermined) {
      Permission.storage.request();

    }

    if (status.isGranted)
      {
        print("set up screen recording");
        bool started = await FlutterScreenRecording.startRecordScreen(_fileName);
        if (started == true) {
          print("recording started");
        }
        else {
          print("recording failed to start");
        }
      }
    else
      {
        print("permission denied");
      }


  }

  void _requestPermissionsForRecording() async
  {
    var status = await Permission.storage.status;

    if (status.isUndetermined)
      {
       Permission.storage.request();
      }
  }

  void end() async
  {
    String path = await FlutterScreenRecording.stopRecordScreen;

    print("video saved to " + path + "");
  }
}

