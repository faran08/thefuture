// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thefuture/AdminFiles/StateControllers.dart';
import 'package:thefuture/globals.dart';

class DefinedCourses extends StatelessWidget {
  DefinedCourses({Key? key}) : super(key: key);

  final AdminStateControllers adminStateControllers =
      Get.put(AdminStateControllers());

  @override
  Widget build(BuildContext context) {
    adminStateControllers.getDefinedCourses(context);
    return SafeArea(
        child: Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        title: Text(
          'Defined Courses',
          style: GoogleFonts.poppins(
              color: textColor, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: backGroundColor,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          children: [
            Flexible(
              child: GetBuilder<AdminStateControllers>(builder: (_) {
                // _.getSubjectNames();
                return _.definedCoursesNames;
              }),
            )
          ],
        ),
      ),
    ));
  }
}
