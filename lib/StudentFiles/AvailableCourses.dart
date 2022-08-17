import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thefuture/StudentFiles/StudentController.dart';
import 'package:thefuture/globals.dart';

class AvailableCoursesStudent extends StatelessWidget {
  AvailableCoursesStudent({Key? key}) : super(key: key);
  StudentController studentController = Get.put(StudentController());

  @override
  Widget build(BuildContext context) {
    studentController.getDefinedCourses(context);
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              leading: Container(),
              title: Text(
                'Available Courses',
                style: GoogleFonts.poppins(
                    color: textColor,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              elevation: 0,
              backgroundColor: backGroundColor,
            ),
            backgroundColor: backGroundColor,
            body: Column(
              children: [
                Flexible(child: GetBuilder<StudentController>(builder: (_) {
                  return _.definedCoursesNames;
                }))
              ],
            )));
  }
}
