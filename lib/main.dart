import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import './sign_in_screen.dart';
import './description_screen.dart';
import './picture_screen.dart';
import './grading_screen.dart';
import './account_screen.dart';
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
        primaryColor: primary

      ),
        home: SignInScreen()

        );
  }

}
