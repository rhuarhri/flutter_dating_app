import 'package:flutter/material.dart';
import 'package:flutterdatingapp/speech_to_text.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import '../color_scheme.dart';
import '../common_widgets.dart';
import '../screen_timer.dart';

class DescriptionScreenWidgets
{
  Widget descriptionAppBar(BuildContext context) {
    return appBar("Profile description", Icon(MdiIcons.cardText), context);
  }

}

class DescriptionBody extends StatefulWidget {

  Function onCompleteAction;
  BuildContext screenContext;
  DescriptionBody(this.onCompleteAction, this.screenContext);

  @override
  State<StatefulWidget> createState() {
    return _DescriptionBody(onCompleteAction, screenContext);
  }
}

TextEditingController descriptionController = TextEditingController();
int wordLimit = 1000; //characters
//This 1000 character limit is based on 1 unit of work defined by google cloud
//units of work is how google cloud measures price.

int characterAmount = 0;



class _DescriptionBody extends State<DescriptionBody>
{
  ScreenTimer screenTimer = ScreenTimer();

  @override
  void initState() {
    screenTimer.start("description screen");
    super.initState();
  }

  @override
  void dispose() {
    screenTimer.stop();
    super.dispose();
  }

  Function onCompleteAction;
  BuildContext screenContext;
  _DescriptionBody(this.onCompleteAction, this.screenContext);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DescriptionScreenWidgets().descriptionAppBar(context),
      floatingActionButton: _actionBTN(),

      body:Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,

      children: <Widget>  [
        Flexible(child:
        Container(child: TextField(
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "add a description of yourself"
          ),
          maxLines: null,
          controller: descriptionController,
          onChanged: (String text){
            setState(() {
              characterAmount = descriptionController.text.length;
            });
          },
        ),
          //color: Colors.green,
        ),
          fit: FlexFit.tight,
          flex: 7,
        ),

        Flexible(
          child: Container(child: Text(characterAmount.toString() + "/" + wordLimit.toString()),),
          fit: FlexFit.tight,
          flex: 1,
        ),

        Flexible(child:
        Container(child:
        helpButtons("A description can help someone understand what you are like.",
            "Beware of spelling mistakes.",
            context),
          //color: Colors.yellow,
        ),
          fit: FlexFit.tight,
          flex: 1,
        ),

        loadingDisplay(),

        //progressBar(),
        //CircularProgressIndicator(),
      ],)
      ,);
  }

  bool isLoading = false;
  Widget loadingDisplay()
  {
    if (isLoading == true)
    {
      return
        Flexible(child: LinearProgressIndicator(), fit: FlexFit.loose, flex: 2,);

    }
    else
    {
      return DoneBTN();

    }
  }

  Widget DoneBTN()
  {
    return
      Flexible(child:
      Container(child:
      Row(children: <Widget>[

        RaisedButton(child: Text("Done"),
          shape: buttonBorderStyle,
          color: primary,
          onPressed: (){

            setState(() {
              isLoading = true;
              _isRecording = false;
            });

            _speechRecognizer.stop();

          onCompleteAction.call();

          },)
      ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),

        //color: Colors.blue,
      ),
        fit: FlexFit.tight,
        flex: 2,
      );
  }

  bool _isRecording = false;

  Widget _actionBTN()
  {
    Widget icon;

    if (_isRecording == true)
      {
        icon = Icon(MdiIcons.microphoneOff);
      }
    else
      {
        icon = Icon(MdiIcons.microphone);
      }

    return FloatingActionButton(backgroundColor: secondary, child: icon, onPressed: (){
      if(_isRecording == true)
        {
          _speechRecognizer.stop();
          print("recording stopped");
          setState(() {
            _isRecording = false;
          });
          //recordingPopup(context);
        }
      else
        {
          _startSpeechRecognition();
        }
    },);
  }

  SpeechRecognizer _speechRecognizer = SpeechRecognizer();
  void _startSpeechRecognition() async
  {
    var status = await Permission.microphone.status;

    if (status.isUndetermined)
    {
      Permission.microphone.request();
      print("requested permission");
    }
    else{
      await _speechRecognizer.setup();

      //if (_speechToText.isAvailable == true)
      //{
        print("recording");
        _speechRecognizer.start(_resultListener);
        setState(() {
          _isRecording = true;
        });
        //recordingPopup(context);
      //}
      //else{
        //print("speech to text is not available");
      //}

    }
  }


  void _resultListener(SpeechRecognitionResult result) {

    setState(() {
      descriptionController.text = "${result.recognizedWords}";
      characterAmount = descriptionController.text.length;
    });

    print("result is " + descriptionController.text);
  }


}