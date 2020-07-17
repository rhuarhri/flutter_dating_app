import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:googleapis_beta/language/v1beta2.dart';
import 'package:googleapis_auth/auth_io.dart';

import 'database_management_code/database.dart';
import 'database_management_code/internal/DataModels.dart';

import './ApiKeys.dart';


String apiKey = NLPkey;
String apiEndPoint = "https://language.googleapis.com/v1/documents:analyzeSentiment?key=" + apiKey;

//String url = "https://api.eu-gb.natural-language-understanding.watson.cloud.ibm.com/instances/0f0ef29f-6155-4166-b215-584488c076ea";

class DescriptionAnalyzer
{

  String descriptionStyle = "";

  String analyzeDescriptionStyle(int mistakes, int abbreviation, int punctuation, String description, int maxDescriptionLength)
  {
    /*people with similar writing styles might be able to understand each other more.
    For example, if two people use abbreviations like lol or omg
    they will know what they mean and will be able to understand each other and get along.*/

    String result = "informal";

    bool hasPunctuation = false;
    bool isSmallDescription = false;

    if (description.length > (maxDescriptionLength / 2))
      {
        //half of the max length then it is a small description
        isSmallDescription = true;
      }
    else
      {
        isSmallDescription = false;
      }

    //no proof but in the average paragraph there is 2 punctuation characters every 150 characters

    double modifier = 150 / description.length;
    double punctuationRate = 2 / modifier;

    /*maths of how punctuationRate is calculated
      2/150
      ?/450
      //450 is the size of the document

      150 / 450 = 0.3333
      //0.3333 is the modifier
      2 / 0.3333 = 6

      the document needs to have 6 characters of punctuation

     */

    if (punctuation >= punctuationRate)
      {
        hasPunctuation = true;
      }
    else
      {
        hasPunctuation = false;
      }

    if (hasPunctuation == true && isSmallDescription == true && mistakes == 0 && abbreviation == 0)
      {
        result = "formal";
      }
    else
      {
        result = "informal";
      }

    /*
    Knowing things like description length or if their are any mistakes might suggest how much effort
    someone is willing to put into the app. For example a large description with no mistakes with
    punctuation means more time spent and more time equals more serious user.
    Know how much effort a user is willing to put in may help with the search, as a serious user
    may not be interested in someone who is only casually using the app.
    There is no real proof that this can show user effort but this is another source of information
    with can be gathered from a description a user must write to sign in.
     */

    return result;
  }


  Future<bool> analyze(String description, BuildContext context) async
  {


    LanguageApi langAPI = LanguageApi(clientViaApiKey(apiKey));


    Locale myLocal = Localizations.localeOf(context);
    String language = myLocal.languageCode;

    print("the users language is " + language);

    Document input = Document();
    input.content = description;
    input.language = language;
    input.type = "PLAIN_TEXT";

    AnalyzeEntitySentimentRequest request = AnalyzeEntitySentimentRequest();

    request.document = input;

    print("Sending document with content of " + input.content);
    
    List<AnalyzeEntitySentimentResponse> data =
    await langAPI.documents.analyzeEntitySentiment(request).asStream().toList();

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
            value.name = element.name.toLowerCase();
            value.sentiment = element.sentiment.score;
            //value.matchable = 1;

            DBProvider.db.userAddDescriptionValue(value);

          });

        });

      }

    int abbreviation = 0;
    int mistakes = 0;
    int punctuation = 0;

    AnalyzeSyntaxRequest syntaxRequest = AnalyzeSyntaxRequest();
    syntaxRequest.document = input;

    AnalyzeSyntaxResponse syntaxData =
        await langAPI.documents.analyzeSyntax(syntaxRequest);

    syntaxData.tokens.forEach((element) {

      if (element.dependencyEdge.label == "ABBREV")
        {
          //ABBREV stands for abbreviation
          abbreviation++;
        }

      if (element.partOfSpeech.tag == "X")
        {
          //X stand for mistake or the natural language processing could not identify it
          mistakes++;
        }
      else if (element.partOfSpeech.tag == "PUNCT")
        {
          //PUNCT stands for punctuation
          punctuation++;
        }



    });

    print("number of abbreviation found is " + abbreviation.toString() + "");
    print("number of mistakes found is " + mistakes.toString() + "");
    print("number of punctuation found is " + punctuation.toString() + "");

    int maxDescriptionLength = 1000;
    descriptionStyle = analyzeDescriptionStyle(mistakes, abbreviation, punctuation, description, maxDescriptionLength);

    DBProvider.db.updateDescriptionStyle(descriptionStyle);


  }

}