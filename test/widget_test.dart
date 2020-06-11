// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterdatingapp/description_analyzer.dart';

import 'package:flutterdatingapp/main.dart';
import 'package:flutterdatingapp/search_manager.dart';

void main() {
  //for testing look here https://medium.com/better-programming/flutter-automated-tests-get-started-424aec9430b3


  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    /*
    await tester.pumpWidget(MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);*/
  });

  /*
  Idea it could be interesting if a user is identified by their location. As it can be assumed
  that someone will download the app at home, as home is were the wifi lives.
   */


  //matching system

  /*
  from database


  step 1 use the users age location and gender to first limit the results.
  step 2 use in array as much as possible to get everyone that has the same values as the
  user.
  Step 3 hopefully step 1 and 2 will be one large query ensuring that only the most useful data is used.
  step 4 look at paginate data with query cursors to get data in chunks.
  step 5 At this point the app can look through a chunk of data and pick out only the most
  useful data.
  step 6 At this point the user will see the data and pick from themselves.


   */

  //search functionality testing

  /*How it will work.
  At the start the app will have received a list of accounts which have been filtered
  by age location and gender.

  The search functionality will use the user's hate and liked list and compare it to
  the same list in a chosen account.

  The comparing of the user and account information should produce some score
  and anything under a particular fresh hold is ignored.

  */

  //cases
  //1 straight match
  //2 a person with two or less mustNotHaves must create a match
  //3 a equal number of hates and likes should cancel each other out.
  //4 low amount of matches should cancel each other out


  group("search functionality testing", (){

    test("perfect match test", (){

      List<String> accountLikes = ["1", "2", "3", "4", "5"];
      List<String> accountHates = ["6", "7", "8", "9", "10"];

      List<String> userLikes = ["1", "2", "3", "4", "5"];
      List<String> userMustHaves = ["1", "2", "3"];
      List<String> userHates = ["6", "7", "8", "9", "10"];
      List<String> userMustNotHaves = ["a", "b", "c"];

      Searcher searcher = Searcher();

      int result = searcher.calculateMatchRate(accountLikes, accountHates,
          userLikes, userHates, userMustHaves, userMustNotHaves);

      expect(result, 100);

    });

    test("user Must have different by 1", (){

      List<String> accountLikes = ["1", "2", "3", "4", "5"];
      List<String> accountHates = ["6", "7", "8", "9", "10"];

      List<String> userLikes = ["1", "2", "3", "4", "5"];
      //user must have has value 'a' which cannot be matched
      List<String> userMustHaves = ["1", "2", "a"];
      List<String> userHates = ["6", "7", "8", "9", "10"];
      List<String> userMustNotHaves = ["a", "b", "c"];

      Searcher searcher = Searcher();

      int result = searcher.calculateMatchRate(accountLikes, accountHates,
          userLikes, userHates, userMustHaves, userMustNotHaves);

      expect(result, 83);

    });

    test("user Must have different by 2", (){

      List<String> accountLikes = ["1", "2", "3", "4", "5"];
      List<String> accountHates = ["6", "7", "8", "9", "10"];

      List<String> userLikes = ["1", "2", "3", "4", "5"];
      //user must have has values 'a' and 'b' which cannot be matched
      List<String> userMustHaves = ["1", "a", "b"];
      List<String> userHates = ["6", "7", "8", "9", "10"];
      List<String> userMustNotHaves = ["a", "b", "c"];

      Searcher searcher = Searcher();

      int result = searcher.calculateMatchRate(accountLikes, accountHates,
          userLikes, userHates, userMustHaves, userMustNotHaves);

      expect(result, 67);

    });

    test("user Must have cannot be matched", (){

      List<String> accountLikes = ["1", "2", "3", "4", "5"];
      List<String> accountHates = ["6", "7", "8", "9", "10"];

      List<String> userLikes = ["1", "2", "3", "4", "5"];
      //user must have has no values that can be matched
      List<String> userMustHaves = ["c", "a", "b"];
      List<String> userHates = ["6", "7", "8", "9", "10"];
      List<String> userMustNotHaves = ["a", "b", "c"];

      Searcher searcher = Searcher();

      int result = searcher.calculateMatchRate(accountLikes, accountHates,
          userLikes, userHates, userMustHaves, userMustNotHaves);

      expect(result, 50);

    });

    test("user likes different by 1", (){

      List<String> accountLikes = ["1", "2", "3", "4", "5"];
      List<String> accountHates = ["6", "7", "8", "9", "10"];

      //user likes value 'a' cannot be matched
      List<String> userLikes = ["a", "2", "3", "4", "5"];
      List<String> userMustHaves = ["1", "2", "3"];
      List<String> userHates = ["6", "7", "8", "9", "10"];
      List<String> userMustNotHaves = ["a", "b", "c"];

      Searcher searcher = Searcher();

      int result = searcher.calculateMatchRate(accountLikes, accountHates,
          userLikes, userHates, userMustHaves, userMustNotHaves);

      expect(result, 95);

    });

    test("user likes different by 3", (){

      List<String> accountLikes = ["1", "2", "3", "4", "5"];
      List<String> accountHates = ["6", "7", "8", "9", "10"];

      //user like values 'a', 'b', 'c', cannot be matched
      List<String> userLikes = ["a", "b", "c", "4", "5"];
      List<String> userMustHaves = ["1", "2", "3"];
      List<String> userHates = ["6", "7", "8", "9", "10"];
      List<String> userMustNotHaves = ["a", "b", "c"];

      Searcher searcher = Searcher();

      int result = searcher.calculateMatchRate(accountLikes, accountHates,
          userLikes, userHates, userMustHaves, userMustNotHaves);

      expect(result, 85);

    });

    test("user likes cannot be matched", (){

      List<String> accountLikes = ["1", "2", "3", "4", "5"];
      List<String> accountHates = ["6", "7", "8", "9", "10"];

      //user likes cannot be matched
      List<String> userLikes = ["a", "b", "c", "d", "e"];
      List<String> userMustHaves = ["1", "2", "3"];
      List<String> userHates = ["6", "7", "8", "9", "10"];
      List<String> userMustNotHaves = ["a", "b", "c"];

      Searcher searcher = Searcher();

      int result = searcher.calculateMatchRate(accountLikes, accountHates,
          userLikes, userHates, userMustHaves, userMustNotHaves);

      expect(result, 75);

    });

    test("1 of user must not haves liked by account", (){

      List<String> accountLikes = ["1", "2", "3", "4", "5"];
      List<String> accountHates = ["6", "7", "8", "9", "10"];

      List<String> userLikes = ["1", "2", "3", "4", "5"];
      List<String> userMustHaves = ["1", "2", "3"];
      List<String> userHates = ["6", "7", "8", "9", "10"];
      List<String> userMustNotHaves = ["1", "b", "c"];

      Searcher searcher = Searcher();

      int result = searcher.calculateMatchRate(accountLikes, accountHates,
          userLikes, userHates, userMustHaves, userMustNotHaves);

      expect(result, 83);

    });

    test(" 2 of user must not haves liked by account", (){

      List<String> accountLikes = ["1", "2", "3", "4", "5"];
      List<String> accountHates = ["6", "7", "8", "9", "10"];

      List<String> userLikes = ["1", "2", "3", "4", "5"];
      List<String> userMustHaves = ["1", "2", "3"];
      List<String> userHates = ["6", "7", "8", "9", "10"];
      List<String> userMustNotHaves = ["1", "2", "c"];

      Searcher searcher = Searcher();

      int result = searcher.calculateMatchRate(accountLikes, accountHates,
          userLikes, userHates, userMustHaves, userMustNotHaves);

      expect(result, 67);

    });

    test("all user must not haves liked by account", (){

      List<String> accountLikes = ["1", "2", "3", "4", "5"];
      List<String> accountHates = ["6", "7", "8", "9", "10"];

      List<String> userLikes = ["1", "2", "3", "4", "5"];
      List<String> userMustHaves = ["1", "2", "3"];
      List<String> userHates = ["6", "7", "8", "9", "10"];
      List<String> userMustNotHaves = ["1", "2", "3"];

      Searcher searcher = Searcher();

      int result = searcher.calculateMatchRate(accountLikes, accountHates,
          userLikes, userHates, userMustHaves, userMustNotHaves);

      expect(result, 50);

    });

    test("user hates 1 thing the account likes", (){

      List<String> accountLikes = ["1", "2", "3", "4", "5"];
      List<String> accountHates = ["6", "7", "8", "9", "10"];

      List<String> userLikes = ["1", "2", "3", "4", "5"];
      List<String> userMustHaves = ["1", "2", "3"];
      List<String> userHates = ["1", "7", "8", "9", "10"];
      List<String> userMustNotHaves = ["a", "b", "c"];

      Searcher searcher = Searcher();

      int result = searcher.calculateMatchRate(accountLikes, accountHates,
          userLikes, userHates, userMustHaves, userMustNotHaves);

      expect(result, 95);

    });

    test("user hates 3 things the account likes", (){

      List<String> accountLikes = ["1", "2", "3", "4", "5"];
      List<String> accountHates = ["6", "7", "8", "9", "10"];

      List<String> userLikes = ["1", "2", "3", "4", "5"];
      List<String> userMustHaves = ["1", "2", "3"];
      List<String> userHates = ["1", "2", "3", "9", "10"];
      List<String> userMustNotHaves = ["a", "b", "c"];

      Searcher searcher = Searcher();

      int result = searcher.calculateMatchRate(accountLikes, accountHates,
          userLikes, userHates, userMustHaves, userMustNotHaves);

      expect(result, 85);

    });

    test("user hates what the account likes", (){

      List<String> accountLikes = ["1", "2", "3", "4", "5"];
      List<String> accountHates = ["6", "7", "8", "9", "10"];

      List<String> userLikes = ["1", "2", "3", "4", "5"];
      List<String> userMustHaves = ["1", "2", "3"];
      List<String> userHates = ["1", "2", "3", "4", "5"];
      List<String> userMustNotHaves = ["a", "b", "c"];

      Searcher searcher = Searcher();

      int result = searcher.calculateMatchRate(accountLikes, accountHates,
          userLikes, userHates, userMustHaves, userMustNotHaves);

      expect(result, 75);

    });

    test("random mix of data", (){

      List<String> accountLikes = ["1", "2", "3", "4", "5"];
      List<String> accountHates = ["6", "7", "8", "9", "10"];

      //the user likes three things that the account likes
      List<String> userLikes = ["6", "7", "3", "4", "5"];
      //the user has one must have that account hates
      List<String> userMustHaves = ["6", "2", "3"];
      //The user has two hate that the user likes
      List<String> userHates = ["1", "2", "8", "9", "10"];
      //user has one must not have which the account likes
      List<String> userMustNotHaves = ["1", "b", "c"];

      Searcher searcher = Searcher();

      int result = searcher.calculateMatchRate(accountLikes, accountHates,
          userLikes, userHates, userMustHaves, userMustNotHaves);

      expect(result, 47);

    });


  });


  group("check description style", (){
    test("detect informal text with no punctuation", (){

      //This text has no punctuation
      String text = "Natural Language uses machine learning to reveal the structure and meaning of text You can extract information about people places and events and better understand social media sentiment and customer conversations Natural Language enables you to analyze text and also integrate it with your document storage on Cloud Storage";

      DescriptionAnalyzer analyzer = DescriptionAnalyzer();

      String result = analyzer.analyzeDescriptionStyle(0, 0, 0, text, 400);

      expect(result, "informal");


    });

    test("detect formal text with punctuation", (){

      //This text has a good amount of punctuation
      String text = "Natural Language uses machine learning to reveal the structure and meaning of text. You can extract information about people, places, and events, and better understand social media sentiment and customer conversations. Natural Language enables you to analyze text and also integrate it with your document storage on Cloud Storage.";

      DescriptionAnalyzer analyzer = DescriptionAnalyzer();

      String result = analyzer.analyzeDescriptionStyle(0, 0, 6, text, 400);

      expect(result, "formal");

    });

    test("detect informal text with not enough punctuation", (){

      //This text is missing punctuation to the point that mistakes are noticeable
      String text = "Natural Language uses machine learning to reveal the structure and meaning of text You can extract information about people places and events and better understand social media sentiment and customer conversations. Natural Language enables you to analyze text and also integrate it with your document storage on Cloud Storage.";

      DescriptionAnalyzer analyzer = DescriptionAnalyzer();

      String result = analyzer.analyzeDescriptionStyle(0, 0, 2, text, 400);

      expect(result, "informal");


    });

    test("detect informal text with abbreviations", (){

      //This text has a good amount of punctuation
      String text = "Natural Language (NLP) uses machine learning to reveal the structure and meaning of text. You can extract information about people, places, and events, and better understand social media sentiment and customer conversations. Natural Language enables you to analyze text and also integrate it with your document storage on Cloud Storage.";

      DescriptionAnalyzer analyzer = DescriptionAnalyzer();

      int abbreviations = 1;

      String result = analyzer.analyzeDescriptionStyle(0, abbreviations, 6, text, 400);

      expect(result, "informal");

    });

    test("detect informal text with mistakes", (){

      //This text has a good amount of punctuation
      String text = "Natural Language uses machine learning to reveal the structure and meaning of text. You can extract information about people, places, and events, and better understand social media sentiment and customer conversations. Natural Language enables you to analyze text and also integrate it with your document storage on Cloud Storage.";

      DescriptionAnalyzer analyzer = DescriptionAnalyzer();

      int mistakes = 2;

      String result = analyzer.analyzeDescriptionStyle(mistakes, 0, 6, text, 400);

      expect(result, "informal");

    });

    test("detect informal text where description is small", (){

      //This text has a good amount of punctuation
      String text = "Natural Language uses machine learning to reveal the structure and meaning of text. You can extract information about people, places, and events, and better understand social media sentiment and customer conversations. Natural Language enables you to analyze text and also integrate it with your document storage on Cloud Storage.";

      DescriptionAnalyzer analyzer = DescriptionAnalyzer();

      int maxDescriptionSize = 1000;

      String result = analyzer.analyzeDescriptionStyle(0, 0, 6, text, maxDescriptionSize);

      expect(result, "informal");

    });

  });





}
