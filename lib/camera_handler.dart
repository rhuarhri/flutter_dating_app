import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutterdatingapp/image_from_video.dart';

class CameraHandler
{
  CameraController _controller;
  List<CameraDescription> _cameras;
  bool isBackCamera = true;
  String videoPath = "";

  Future<String> _getFilePath() async
  {
    String name = "dating_app_video";
    String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    final Directory extDir = await getExternalStorageDirectory();
    final String dirPath = '${extDir.path}';
    String filePath = '$dirPath/$name.mp4';

    return filePath;
  }

  Future<void> setup() async
  {
    _cameras = await availableCameras();
    isBackCamera = true;
    _controller = CameraController(_cameras[0], ResolutionPreset.medium, enableAudio: true,);
    await _controller.initialize();

    videoPath = await _getFilePath();
  }

  Widget cameraPreview(bool setupCompleted)
  {
    if (setupCompleted == false && _controller == null)
      {
        return Container(child: CircularProgressIndicator());
      }
    else {
      return
        Container(child: CameraPreview(_controller),);
    }
  }

  Future<void> swapCamera() async
  {
    if (isBackCamera == true)
    {
      await _swap(_cameras[1]);
      isBackCamera = false;
    }
    else
    {
      await _swap(_cameras[0]);
      isBackCamera = true;
    }
  }

  Future<void> _swap(CameraDescription cameraDescription) async
  {
    if (_controller != null) {
      await _controller.dispose();
    }
    _controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: true,
      //enableAudio: enableAudio,
    );

    // If the controller is updated then update the UI.
    _controller.addListener(() {
      if (_controller.value.hasError) {
        print(_controller.value.errorDescription);
      }
    });

    try {
      await _controller.initialize();
    } on CameraException catch (e) {
      print(e.description);
    }

  }

  bool isRecording()
  {
    if (_controller.value.isRecordingVideo == false)
      {
        return false;
      }
    else
      {
        return true;
      }
  }

  Future<void> start() async
  {
    if (await File(videoPath).exists() == true)
      {
        File(videoPath).delete();
      }

    if (_controller.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }

    try {
      await _controller.startVideoRecording(videoPath);
    } on CameraException catch (e) {
      print(e);
      return null;
    }
  }

  Future<String> stop() async
  {
    if (!_controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await _controller.stopVideoRecording();
    } on CameraException catch (e) {
      print(e);
      return null;
    }

    print("video file path is " + videoPath);

    String imagePath = await ImageFromVideo().getImage(videoPath);

    print("image file path is " + imagePath);

    return imagePath;

  }

  void dispose()
  {
    _controller?.dispose();
  }
}