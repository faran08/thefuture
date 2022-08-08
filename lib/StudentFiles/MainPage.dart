// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thefuture/StudentFiles/AvailableCourses.dart';
import 'package:thefuture/StudentFiles/StudentController.dart';
import 'package:thefuture/globals.dart';

import '../LoginFiles/mainPage.dart';

class StudentMainPage extends StatelessWidget {
  String documentID;
  StudentMainPage({Key? key, required this.documentID}) : super(key: key);

  StudentController studentController = Get.put(StudentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Fluttertoast.showToast(
                    msg: 'Future: Show Student profile',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.grey,
                    textColor: Colors.black,
                    fontSize: 16.0);
              },
              icon: Icon(Icons.school_rounded)),
          IconButton(
              onPressed: () {
                globalUserName = '';
                Get.off(MainPage());
              },
              icon: Icon(FontAwesomeIcons.rightFromBracket))
        ],
        title: Text(globalUserName),
        toolbarHeight: MediaQuery.of(context).size.height / 13,
        elevation: 0,
        backgroundColor: backGroundColor,
        leading: Container(
          margin: EdgeInsets.fromLTRB(5, 5, 0, 0),
          decoration: BoxDecoration(
              color: buttonColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(blurRadius: 1, spreadRadius: 1, color: shadowColor)
              ]),
          child: Center(
            child: Icon(
              Icons.person,
              color: textColor,
            ),
          ),
        ),
      ),
      backgroundColor: backGroundColor,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Column(
            children: [
              AutoSizeText(
                'You have following options available',
                maxLines: 1,
                style: GoogleFonts.poppins(
                    color: textColor, fontWeight: FontWeight.normal),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: buttonColor,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        shadowColor: backGroundColor,
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 20)),
                    onPressed: () {
                      Get.to(AvailableCoursesStudent());
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Icon(
                            Icons.calendar_month_rounded,
                            color: textColor,
                            size: 30,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: AutoSizeText(
                            'Available Courses',
                            minFontSize: 20,
                            style: GoogleFonts.poppins(
                                color: textColor, fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    )),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
