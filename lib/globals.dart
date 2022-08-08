// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

library thefuture.globals;

import 'package:flutter/material.dart';

Color backGroundColor = Colors.grey.shade200;
Color textColor = Colors.black;
Color buttonColor = Colors.white;
Color shadowColor = Colors.black.withOpacity(0.2);
Cubic transitionCurves = Curves.easeOutExpo;
String globalUserName = '';
Color iconButtonColor = Color(0xAA183153);

Widget getToast(Widget Icon, String Message) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      color: Colors.greenAccent,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon,
        Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: Text(Message),
        )
      ],
    ),
  );
}
