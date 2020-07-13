import 'package:flutter/material.dart';

//Color primary = Color(0xffafeeee);

//Color primaryDark = Color(0xff7ebbbc);

//Color primaryLight = Color(0xffe2ffff);

Color primary = Color(0xffff91a4);

Color primaryDark = Color(0xffc96175);

Color primaryLight = Color(0xffffc3d5);

Color secondary = Color(0xffff0000);

Color secondaryLight = Color(0xffff5a36);

Color secondaryDark = Color(0xffc20000);

Color backgroundColor = Color(0xafffffff);

RoundedRectangleBorder buttonBorderStyle = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(18.0),
    side: BorderSide(color: primaryDark)
    );

BoxDecoration containerDecoration() {
    return BoxDecoration(
        border: Border.all(
            width: 3.0,
            color: primaryDark,
        ),
        borderRadius: BorderRadius.all(
            Radius.circular(30.0)
        ),
    );
}