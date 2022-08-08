// ignore_for_file: prefer_const_constructors

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thefuture/LoginFiles/RegistrationPageTeacher.dart';
import 'package:thefuture/StudentFiles/StudentRegistration.dart';
import 'package:thefuture/globals.dart';

class StudentNameController extends GetxController {
  // StudentNameController({required this.userIcon });

  String studentName = '';

  Icon userIcon = Icon(
    Icons.person_rounded,
    color: textColor,
    size: 50,
  );

  Widget registerButton = TextButton(onPressed: () {}, child: Container());

  void setRegisterButton() {
    registerButton = TextButton(
        style: TextButton.styleFrom(
            backgroundColor: buttonColor,
            padding: EdgeInsets.all(10),
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            shadowColor: backGroundColor),
        onPressed: () {
          switch (studentName) {
            case 'Teacher':
              Get.to(TeacherRegistration());
              break;
            case 'Student':
              Get.to(StudentRegistration());
              break;
            default:
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
              child: AutoSizeText(
                'Register',
                minFontSize: 20,
                style: GoogleFonts.poppins(
                    color: textColor, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ));
    update();
  }

  void hideRegisterButton(bool input) {
    if (input) {
      registerButton = Container();
      update();
    } else {
      registerButton = TextButton(
          style: TextButton.styleFrom(
              backgroundColor: buttonColor,
              padding: EdgeInsets.all(10),
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              shadowColor: backGroundColor),
          onPressed: () {
            switch (studentName) {
              case 'Teacher':
                Get.to(TeacherRegistration());
                break;
              default:
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                child: AutoSizeText(
                  'Register',
                  minFontSize: 20,
                  style: GoogleFonts.poppins(
                      color: textColor, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ));
      update();
    }
  }

  void changeName(String inputName) {
    studentName = inputName;
    update();
  }

  void changePersonIcon(String type) {
    switch (type) {
      case 'Teacher':
        userIcon = Icon(
          Icons.person_rounded,
          color: textColor,
          size: 50,
        );
        break;
      case 'Student':
        userIcon = Icon(
          Icons.school_rounded,
          color: textColor,
          size: 50,
        );
        break;
      case 'Admin':
        userIcon = Icon(
          FontAwesomeIcons.userTie,
          color: textColor,
          size: 50,
        );
        break;
      default:
    }
    update();
  }
}
