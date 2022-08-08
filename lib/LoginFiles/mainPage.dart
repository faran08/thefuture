// ignore_for_file: prefer_const_constructors

import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thefuture/AdminFiles/AdminMainPage.dart';
import 'package:thefuture/LoginFiles/StateControllers/StudentNameController.dart';
import 'package:thefuture/StudentFiles/MainPage.dart';
import 'package:thefuture/TeacherFiles/HomePage.dart';
import 'package:thefuture/globals.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class MainPage extends StatelessWidget {
  MainPage({Key? key}) : super(key: key);

  StudentNameController studentNameController = Get.put(
    StudentNameController(),
  );
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  PageController pageController = PageController();
  TextEditingController userName = TextEditingController();
  TextEditingController passWord = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // studentNameController.setRegisterButton();
    var fToast = FToast();
    fToast.init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backGroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: backGroundColor,
        elevation: 0,
      ),
      body: PageView(
        allowImplicitScrolling: false,
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: AutoSizeText(
                        'THE FUTURE',
                        textAlign: TextAlign.center,
                        minFontSize: 30,
                        style: GoogleFonts.poppins(
                            color: textColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                    child: AutoSizeText(
                      'Welcome,\nPlease Select To Proceed',
                      textAlign: TextAlign.center,
                      minFontSize: 20,
                      style: GoogleFonts.poppins(color: textColor),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: buttonColor,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            shadowColor: backGroundColor,
                            padding: EdgeInsets.all(30)),
                        onPressed: () {
                          studentNameController.changeName('Teacher');
                          studentNameController.changePersonIcon('Teacher');
                          studentNameController.setRegisterButton();
                          pageController.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: transitionCurves);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.person,
                              color: textColor,
                              size: 25,
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                              child: AutoSizeText(
                                'Teacher',
                                minFontSize: 20,
                                style: GoogleFonts.poppins(
                                    color: textColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        )),
                  ),
                  TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: buttonColor,
                          padding: EdgeInsets.all(30),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          shadowColor: backGroundColor),
                      onPressed: () {
                        studentNameController.changeName('Student');
                        studentNameController.changePersonIcon('Student');
                        studentNameController.setRegisterButton();
                        pageController.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: transitionCurves);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.school_rounded,
                            color: textColor,
                            size: 25,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child: AutoSizeText(
                              'Student',
                              minFontSize: 20,
                              style: GoogleFonts.poppins(
                                  color: textColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      )),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: buttonColor,
                        elevation: 2,
                        shadowColor: backGroundColor),
                    onPressed: () {
                      Get.find<StudentNameController>().changeName('Admin');
                      Get.find<StudentNameController>()
                          .changePersonIcon('Admin');
                      Get.find<StudentNameController>()
                          .hideRegisterButton(true);
                      pageController.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: transitionCurves);
                    },
                    child: AutoSizeText(
                      'Sign In As Admin',
                      style: GoogleFonts.poppins(color: textColor),
                    )),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: buttonColor,
                        ),
                        padding: EdgeInsets.all(20),
                        child: GetBuilder<StudentNameController>(builder: (_) {
                          return _.userIcon;
                        }),
                      ),
                    ),
                  ),
                  GetBuilder<StudentNameController>(builder: (_) {
                    return AutoSizeText(
                      _.studentName,
                      minFontSize: 25,
                      maxLines: 1,
                      style: GoogleFonts.poppins(
                          color: textColor, fontWeight: FontWeight.bold),
                    );
                  }),
                  Form(
                      child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                        child: AutoSizeText(
                          'Username',
                          maxLines: 1,
                          minFontSize: 20,
                          style: GoogleFonts.poppins(
                              color: textColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: TextFormField(
                          controller: userName,
                          maxLength: 20,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: buttonColor,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: AutoSizeText(
                          'Password',
                          maxLines: 1,
                          minFontSize: 20,
                          style: GoogleFonts.poppins(
                              color: textColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: TextFormField(
                          controller: passWord,
                          obscureText: true,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: buttonColor,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                    ],
                  )),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: buttonColor,
                            padding: EdgeInsets.all(10),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            shadowColor: backGroundColor),
                        onPressed: () {
                          EasyLoading.show(
                            maskType: EasyLoadingMaskType.clear,
                            status: 'Loading',
                          );
                          users
                              .where('actor',
                                  isEqualTo: studentNameController.studentName)
                              .where('userName', isEqualTo: userName.text)
                              .where('passWord', isEqualTo: passWord.text)
                              .get()
                              .then((value) {
                            if (value.docs.isNotEmpty) {
                              EasyLoading.dismiss();
                              fToast.showToast(
                                  child: getToast(
                                      JelloIn(
                                          child: Icon(FontAwesomeIcons.check)),
                                      '${Get.find<StudentNameController>().studentName} Login in Successful'));
                              switch (studentNameController.studentName) {
                                case 'Admin':
                                  globalUserName = (value.docs.first.data()
                                          as Map)['userName']
                                      .toString();
                                  Get.off(AdminMainPage(
                                    adminDocument: value.docs.first.id,
                                  ));

                                  break;
                                case 'Teacher':
                                  globalUserName = (value.docs.first.data()
                                          as Map)['userName']
                                      .toString();
                                  Get.off(TeacherHomePage(
                                      documentID: value.docs.first.id));
                                  break;
                                case 'Student':
                                  globalUserName = (value.docs.first.data()
                                          as Map)['userName']
                                      .toString();
                                  Get.off(StudentMainPage(
                                      documentID: value.docs.first.id));
                                  break;

                                default:
                              }
                            } else {
                              EasyLoading.dismiss();
                              fToast.showToast(
                                  child: getToast(
                                      JelloIn(
                                          child: Icon(FontAwesomeIcons
                                              .circleExclamation)),
                                      '${Get.find<StudentNameController>().studentName} Login Error'));
                            }
                          }).onError((error, stackTrace) {
                            Fluttertoast.showToast(
                                msg: 'Error: ' + error.toString(),
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.grey,
                                textColor: Colors.black,
                                fontSize: 16.0);
                            print(error.toString());
                            EasyLoading.dismiss();
                            fToast.init(context);
                            fToast.showToast(
                                child: getToast(
                                    JelloIn(
                                        child: Icon(FontAwesomeIcons
                                            .circleExclamation)),
                                    '${Get.find<StudentNameController>().studentName} Login Error'));
                          });
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                              child: AutoSizeText(
                                'Log In',
                                minFontSize: 20,
                                style: GoogleFonts.poppins(
                                    color: textColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        )),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: Column(
                  children: [
                    GetBuilder<StudentNameController>(builder: (_) {
                      return _.registerButton;
                    }),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: buttonColor,
                              padding: EdgeInsets.all(10),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              shadowColor: backGroundColor),
                          onPressed: () {
                            userName.text = '';
                            passWord.text = '';
                            studentNameController.hideRegisterButton(false);
                            pageController.previousPage(
                                duration: Duration(milliseconds: 500),
                                curve: transitionCurves);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.arrow_back,
                                color: textColor,
                                size: 25,
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                                child: AutoSizeText(
                                  'Back',
                                  minFontSize: 20,
                                  style: GoogleFonts.poppins(
                                      color: textColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          )),
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
