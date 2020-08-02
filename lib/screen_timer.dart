

import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterdatingapp/database_management_code/database.dart';
import 'package:flutterdatingapp/database_management_code/internal/DataModels.dart';

class ScreenTimer
{

  Timer _screenTimer;
  int _currentTime;
  String _screenName;
  int _recordingId;


  void start(String screenName) async
  {
    _screenName = screenName;

    String userId = await _setup();

      _currentTime = 0;
      print("timer setup complete");

          _screenTimer = Timer.periodic(Duration(seconds: 1), (timer)
      {
      _currentTime++;
      print("timer is " + _currentTime.toString());
      _saveTime(userId);

      });

  }

  void stop()
  {
    _screenTimer.cancel();
  }

  Future<String> _setup() async
  {
    _recordingId = Random().nextInt(100);

    String userId = await _getUserId();

    await Firestore.instance.collection("Testers").add({
      "screen":_screenName,
      "id":userId,
      "time":0,
      "timerId":_recordingId,
    });

    return userId;
  }

  Future<String> _getUserId() async
  {
    UserInfo user = await DBProvider.db.getUser();

    return user.onlineLocation;
  }

  void _saveTime(String id) async
  {
    final database = Firestore.instance;

    QuerySnapshot snapshot = await database.collection("Testers")
        .where("id", isEqualTo: id).where("screen", isEqualTo: _screenName).where("timerId", isEqualTo: _recordingId)
        .getDocuments();

    DocumentSnapshot document = snapshot.documents[0];
    //int oldTime = document.data["time"];
    int newTime = _currentTime;

    String documentId = document.documentID;

    database.collection("Testers").document(documentId).updateData(
        {"time": newTime}
    );

  }

}