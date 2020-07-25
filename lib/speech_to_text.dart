import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_recognition_error.dart';

class SpeechRecognizer
{
  final SpeechToText _speech = SpeechToText();
  String _currentLocaleId = "";

  String recognizedWords = "";

  Future<void> setup() async
  {
    var status = await Permission.microphone.status;

    if (status.isUndetermined)
    {
      Permission.microphone.request();
      print("requested permission");
    }
    else {
      bool hasSpeech = await _speech.initialize(
          onError: _errorListener, onStatus: _statusListener);
      if (hasSpeech) {
        //_localeNames = await speech.locales();

        var systemLocale = await _speech.systemLocale();
        _currentLocaleId = systemLocale.localeId;
      }
    }

  }

  void _errorListener(SpeechRecognitionError error) {
    // print("Received error status: $error, listening: ${speech.isListening}");
    print("speech to text ${error.errorMsg} - ${error.permanent}");
  }

  void _statusListener(String status) {

  }

  void _resultListener(SpeechRecognitionResult result) {

    recognizedWords = "${result.recognizedWords}";

    print("result is " + recognizedWords);
  }

  void start(Function resultListener)
  {
    _speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: 60),
        localeId: _currentLocaleId,
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        partialResults: true,
        onDevice: true,
        listenMode: ListenMode.confirmation);
  }

  void soundLevelListener(double level) {
    //print("sound level is " + level.toStringAsFixed(3));
  }

  void stop()
  {
    _speech.stop();
  }

  String getResult()
  {
    return recognizedWords;
  }
}