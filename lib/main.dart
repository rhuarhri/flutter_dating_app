import 'package:flutter/material.dart';
import './sign_in_screen.dart';
import './color_scheme.dart';


void main() {
  runApp(BaseScreen());
}

class BaseScreen extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      title: "app name",
      theme: ThemeData(
        primaryColor: primary,
      ),
        home: SignInScreen()

        );
  }

}
