//import 'package:flutter_ibm_watson/flutter_ibm_watson.dart';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:googleapis_beta/adexchangebuyer2/v2beta1.dart';
import 'package:googleapis_beta/appengine/v1beta.dart';
import 'package:googleapis_beta/language/v1beta2.dart';
import 'package:googleapis_auth/auth_io.dart';

import './database.dart';
import './DataModels.dart';

import './interests_screen.dart';

/*
Test description
I am a currently studying mobile app development. A part from that I go caving at the weekends.
I enjoy caving as I see place few people ever see as well as the challenge of caving.
I regularly go running mainly to keep fit. I don't like children as they can be annoying at times.
I also get annoyed at plot holes in TV programs.

 */


String apiKey = "AIzaSyCovF7m4nAh-7HdtOBqhCc9YfXuLu34kpU";
String apiEndPoint = "https://language.googleapis.com/v1/documents:analyzeSentiment?key=" + apiKey;

//String url = "https://api.eu-gb.natural-language-understanding.watson.cloud.ibm.com/instances/0f0ef29f-6155-4166-b215-584488c076ea";

class DescriptionAnalyzer
{



  analyze(String description, BuildContext context) async
  {


    LanguageApi test = LanguageApi(clientViaApiKey(apiKey));


    Locale myLocal = Localizations.localeOf(context);
    String language = myLocal.languageCode;

    print("the users language is " + language);

    String content = "I enjoy flutter";

    Document input = Document();
    input.content = description;
    input.language = language;
    input.type = "PLAIN_TEXT";

    AnalyzeEntitySentimentRequest request = AnalyzeEntitySentimentRequest();
    //request.document.content = content;
    //request.document.language = "EN";
    //request.document.type = "PLAIN_TEXT";

    request.document = input;

    String name = "";
    double likes = 0.0;
    String result = "The entity is ";

    print("Sending document with content of " + input.content);

    
    List<AnalyzeEntitySentimentResponse> data =
    await test.documents.analyzeEntitySentiment(request).asStream().toList();

    if(
    data.isEmpty == true
    )
      {
        print("No result received");
      }
    else
      {
        print("result found");
        data.forEach((element) {
          element.entities.forEach((element) { 
            print("The entity is " + element.name + " and it liked this much " + element.sentiment.score.toStringAsFixed(3));

            DescriptionValue value = DescriptionValue();
            value.name = element.name;
            value.sentiment = element.sentiment.score;

            DBProvider.db.addDescriptionValue(value);

          });

        });

        Navigator.push(context, MaterialPageRoute(builder: (context) => InterestsScreen()));
        
      }

    /*
    then((value) => {

      if (
      value.entities.isEmpty)
        {
          print("No result received"),
        }
      else
        {

          value.entities.map((e) =>
          {

            print(e.name),
            name = e.name,
            likes = e.sentiment.score,
            result = "" + name + " and the like value is " +
                likes.toStringAsFixed(3) + "",

          })
        }
    }).whenComplete(() => {
      print("name is " + name),
      print(result),
      print("completed"),
    });*/



  }

}