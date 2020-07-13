
import 'package:flutter/cupertino.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeech
{
  FlutterTts _tts = FlutterTts();

  void readText(String text, BuildContext context) async
  {
    Locale myLocal = Localizations.localeOf(context);
    String language = myLocal.languageCode;

    await _tts.setLanguage(language);
    await _tts.setVolume(1.0);
    await _tts.speak(text);

  }

  void stopReading()
  {
    _tts.stop();
  }
}