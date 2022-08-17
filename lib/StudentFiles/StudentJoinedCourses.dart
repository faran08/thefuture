// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thefuture/StudentFiles/StudentController.dart';
import 'package:thefuture/globals.dart';

class StudentJoinedCourses extends StatelessWidget {
  StudentJoinedCourses({Key? key}) : super(key: key);
  final StudentController studentController = Get.put(StudentController());

  @override
  Widget build(BuildContext context) {
    studentController.getJoinedCourses();
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
      body: GetBuilder<StudentController>(builder: (_) {
        return Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: studentController.joinedCoursesNames,
        );
      }),
    ));
  }
}
