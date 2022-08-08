// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thefuture/globals.dart';

import 'HomePageController.dart';

class JoinedCourses extends StatelessWidget {
  JoinedCourses({Key? key}) : super(key: key);
  final TeacherHomePageController teacherHomePageController =
      Get.put(TeacherHomePageController());

  @override
  Widget build(BuildContext context) {
    teacherHomePageController.getJoinedCourses();
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text(
          'Joined Courses',
          style: GoogleFonts.poppins(
              color: textColor, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: backGroundColor,
      ),
      backgroundColor: backGroundColor,
      body: GetBuilder<TeacherHomePageController>(builder: (_) {
        return Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: teacherHomePageController.joinedCoursesNames,
        );
      }),
    ));
  }
}
