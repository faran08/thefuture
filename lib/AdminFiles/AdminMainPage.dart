// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thefuture/AdminFiles/AddNewCourse.dart';
import 'package:thefuture/AdminFiles/AddNewSubject.dart';
import 'package:thefuture/AdminFiles/DefinedCourses.dart';
import 'package:thefuture/AdminFiles/StateControllers.dart';
import 'package:thefuture/LoginFiles/mainPage.dart';
import 'package:thefuture/globals.dart';

class AdminMainPage extends StatelessWidget {
  String adminDocument = '';
  AdminMainPage({Key? key, required this.adminDocument}) : super(key: key);
  AdminStateControllers adminStateControllers =
      Get.put(AdminStateControllers());

  @override
  Widget build(BuildContext context) {
    // Get.find<AdminStateControllers>().updateAdminName(adminDocument);
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        actions: [
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
              FontAwesomeIcons.userTie,
              color: textColor,
            ),
          ),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              AutoSizeText(
                'You can manage following',
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
                    onPressed: () {},
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Icon(
                            Icons.person,
                            color: textColor,
                            size: 30,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: AutoSizeText(
                            'Registered Teachers',
                            minFontSize: 20,
                            style: GoogleFonts.poppins(
                                color: textColor, fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    )),
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
                    onPressed: () {},
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Icon(
                            FontAwesomeIcons.graduationCap,
                            color: textColor,
                            size: 25,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: AutoSizeText(
                            'Registered Students',
                            minFontSize: 20,
                            style: GoogleFonts.poppins(
                                color: textColor, fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    )),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: buttonColor,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        shadowColor: backGroundColor,
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 20)),
                    onPressed: () {
                      Get.to(DefinedCourses());
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Icon(
                            FontAwesomeIcons.school,
                            color: textColor,
                            size: 25,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: AutoSizeText(
                            'Defined Courses',
                            minFontSize: 20,
                            style: GoogleFonts.poppins(
                                color: textColor, fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    )),
              ),
              Divider(
                color: textColor,
                height: 1,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: AutoSizeText(
                  'You can add following',
                  maxLines: 1,
                  style: GoogleFonts.poppins(
                      color: textColor, fontWeight: FontWeight.normal),
                ),
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
                      Get.to(AddNewCourse());
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Icon(
                            FontAwesomeIcons.plus,
                            color: textColor,
                            size: 30,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: AutoSizeText(
                            'Define New Course',
                            minFontSize: 20,
                            style: GoogleFonts.poppins(
                                color: textColor, fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    )),
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
                      Get.to(AddNewSubject());
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Icon(
                            FontAwesomeIcons.book,
                            color: textColor,
                            size: 30,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: AutoSizeText(
                            'Add Subjects',
                            minFontSize: 20,
                            style: GoogleFonts.poppins(
                                color: textColor, fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    )),
              )
            ],
          ),
        ),
      )),
    );
  }
}
