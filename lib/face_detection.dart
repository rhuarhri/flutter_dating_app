
import 'dart:io';
import 'dart:math';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutterdatingapp/database_management_code/database.dart';
import 'package:flutterdatingapp/database_management_code/online_database.dart';

/*
This has a problem with consistency answer change every picture even though the
pictures are of the same person.
 */

class FaceDetection
{
  void search(File imageFile) async
  {
    print("starting face detection");

    final image = FirebaseVisionImage.fromFile(imageFile);
    final detect = FirebaseVision.instance.faceDetector(
      FaceDetectorOptions(
      mode: FaceDetectorMode.accurate,
        enableLandmarks: true,
        enableContours: true,
      )
    );

    List<Face> result = await detect.processImage(image);

    print("Done detecting");
    print("result length is " + result.length.toString());

    if (result.isEmpty)
      {
        _addFaceShape("square");
      }
    else
      {

        FaceContour contour = result[0].getContour(FaceContourType.face);
        FaceContour rightEyeContour = result[0].getContour(FaceContourType.rightEye);
        FaceContour leftEyeContour = result[0].getContour(FaceContourType.leftEye);

        if (contour != null && rightEyeContour != null && leftEyeContour != null) {
          double eyeLength = 0.0;
          double rightEyeLength = _getDistance(
              rightEyeContour.positionsList[0].dx,
              rightEyeContour.positionsList[0].dy,
              rightEyeContour.positionsList[8].dx,
              rightEyeContour.positionsList[8].dy);
          double leftEyeLength = _getDistance(
              leftEyeContour.positionsList[0].dx,
              leftEyeContour.positionsList[0].dy,
              leftEyeContour.positionsList[8].dx,
              leftEyeContour.positionsList[8].dy);

          if (rightEyeLength > leftEyeLength) {
            eyeLength = rightEyeLength;
          }
          else {
            eyeLength = leftEyeLength;
          }

          int headWidth = _roundToNearest(eyeLength * 3);

          int jawWidth = _roundToNearest(_getDistance(
              contour.positionsList[13].dx, contour.positionsList[13].dy,
              contour.positionsList[23].dx, contour.positionsList[23].dy));

          print("jaw width is " + jawWidth.toString());

          int forHeadWidth = _roundToNearest(_getDistance(
              contour.positionsList[3].dx, contour.positionsList[3].dy,
              contour.positionsList[33].dx, contour.positionsList[33].dy));

          print("for head width is " + forHeadWidth.toString());

          print("eye distance is " + headWidth.toString());

          if (forHeadWidth >= headWidth && jawWidth >= headWidth) {
            print("square head");
            _addFaceShape("square");
          }

          if (headWidth > forHeadWidth && headWidth > jawWidth) {
            print("round head");
            _addFaceShape("round");
          }

          if (forHeadWidth > headWidth && headWidth >= jawWidth) {
            print("triangle head");
            _addFaceShape("triangle");
          }

          if (forHeadWidth < headWidth && headWidth <= jawWidth) {
            print("bell head");
            _addFaceShape("bell");
          }
        }
        else
          {
            _addFaceShape("square");
          }
      }


  }

  void _addFaceShape(String shape)
  {
    DBProvider.db.updateFaceShape(shape);
    OnlineDatabaseManager onlineManager = OnlineDatabaseManager();
    onlineManager.addFaceShape(shape);
  }

  double _getDistance(double startX, double startY, double endX, double endY)
  {
    double distance = sqrt( pow((startX - endX), 2) + pow((startY - endY), 2));
    return distance;
  }

  int _roundToNearest(double value)
  {
    return (value / 10).floor() * 10;
  }

}