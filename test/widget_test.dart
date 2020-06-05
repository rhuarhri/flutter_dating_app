// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutterdatingapp/main.dart';

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



}
