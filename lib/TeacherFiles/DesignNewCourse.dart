// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, sized_box_for_whitespace

import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:select_card/select_card.dart';
import 'package:tab_container/tab_container.dart';
import 'package:thefuture/TeacherFiles/HomePageController.dart';
import 'package:thefuture/globals.dart';

import '../AdminFiles/StateControllers.dart';

class DesignNewCourse extends StatelessWidget {
  DesignNewCourse({Key? key}) : super(key: key);

  PageController pageController = PageController();
  final TeacherHomePageController teacherHomePageController =
      Get.put(TeacherHomePageController());

  CollectionReference designedCourses =
      FirebaseFirestore.instance.collection('designedCourses');
  TabContainerController containerController =
      TabContainerController(length: 2);

  String typeOfCourse = 'ruleBased';
  late var fToast;
  bool recommenderON = true;
  final TextEditingController _difficultyLevel = TextEditingController();
  Widget getBackButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: TextButton(
          style: TextButton.styleFrom(
              backgroundColor: buttonColor,
              padding: EdgeInsets.all(10),
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              shadowColor: backGroundColor),
          onPressed: () {
            pageController.previousPage(
                duration: Duration(milliseconds: 500), curve: transitionCurves);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.arrow_back,
                color: textColor,
                size: 15,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                child: AutoSizeText(
                  'Back',
                  maxLines: 1,
                  minFontSize: 15,
                  style: GoogleFonts.poppins(
                      color: textColor, fontWeight: FontWeight.bold),
                ),
              )
            ],
          )),
    );
  }

  Widget getSaveButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: TextButton(
          style: TextButton.styleFrom(
              backgroundColor: buttonColor,
              padding: EdgeInsets.all(10),
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              shadowColor: backGroundColor),
          onPressed: () {
            EasyLoading.show();
            designedCourses
                .where('fatherID',
                    isEqualTo: teacherHomePageController
                        .selectedCourseData['courseID'])
                .where('userID', isEqualTo: globalUserName)
                .get()
                .then((value) {
              if (value.docs.isEmpty) {
                designedCourses.add({
                  'courseType': typeOfCourse,
                  'difficultyLevel': _difficultyLevel.text,
                  'fatherID':
                      teacherHomePageController.selectedCourseData['courseID'],
                  'userID': globalUserName,
                  'finalExamDate': teacherHomePageController
                      .selectedCourseData['finalExamDate'],
                  'startDate':
                      teacherHomePageController.selectedCourseData['startDate'],
                  'courseName':
                      teacherHomePageController.selectedCourseData['courseName']
                }).then((value) {
                  fToast.showToast(
                      child: getToast(
                          JelloIn(child: Icon(FontAwesomeIcons.check)),
                          'Course Joined!'));
                  EasyLoading.dismiss();
                  Get.back();
                }).onError((error, stackTrace) {
                  Fluttertoast.showToast(
                      msg: 'Error: $error',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.grey,
                      textColor: Colors.black,
                      fontSize: 16.0);
                });
              } else {
                EasyLoading.dismiss();
                pageController.previousPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.bounceOut);
                fToast.showToast(
                    child: getToast(JelloIn(child: Icon(Icons.error)),
                        'You have already joined this course.'));
              }
            });
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.save_rounded,
                color: textColor,
                size: 15,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                child: AutoSizeText(
                  'Save',
                  maxLines: 1,
                  minFontSize: 15,
                  style: GoogleFonts.poppins(
                      color: textColor, fontWeight: FontWeight.bold),
                ),
              )
            ],
          )),
    );
  }

  Widget getSecondPage() {
    return Column(
      children: [
        Flexible(child: GetBuilder<TeacherHomePageController>(builder: (_) {
          return _.definedCoursesNames;
        }))
      ],
    );
  }

  Widget getFirstPage(BuildContext context) {
    fToast = FToast();
    fToast.init(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            getBackButton(),
            GetBuilder<TeacherHomePageController>(builder: (_) {
              return teacherHomePageController.selectedCourseData.isNotEmpty
                  ? getSaveButton()
                  : Container();
            })
          ],
        ),
        Divider(
          color: Colors.black.withOpacity(0.8),
        ),
        AutoSizeText(
          'Select Learning Method',
          style: GoogleFonts.poppins(
              color: textColor, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: TabContainer(
                color: Colors.white,
                controller: containerController,
                onEnd: (() {
                  print(containerController.index);
                  switch (containerController.index) {
                    case 0:
                      typeOfCourse = 'ruleBased';
                      break;
                    case 1:
                      typeOfCourse = 'profileBased';
                      break;
                    default:
                  }
                }),
                isStringTabs: false,
                tabs: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    width: 150,
                    height: 100,
                    child: Column(
                      children: [
                        AutoSizeText('Recommender',
                            maxLines: 1,
                            style: GoogleFonts.poppins(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18))
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    width: 150,
                    height: 100,
                    child: Column(
                      children: [
                        AutoSizeText('Personalized',
                            maxLines: 1,
                            style: GoogleFonts.poppins(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18))
                      ],
                    ),
                  )
                ],
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: AutoSizeText(
                      'Rule Based Adaptive E-Learning:\n\nCourse Performance Based Syllabi Correction',
                      minFontSize: 20,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          color: textColor, fontWeight: FontWeight.w400),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: AutoSizeText(
                        'Personalized Content Recommender:\n\nStudent Profile Based Syllabi Correction',
                        minFontSize: 20,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            color: textColor, fontWeight: FontWeight.w400),
                      ),
                    ),
                  )
                ]),
          ),
        ),
        Divider(
          color: Colors.black.withOpacity(0.8),
        ),
        AutoSizeText(
          'Course Difficulty Level',
          style: GoogleFonts.poppins(
              color: textColor, fontWeight: FontWeight.bold),
        ),
        SelectGroupCard(context, titles: const [
          'Hard',
          'Semi Hard',
          'Normal',
          'Average',
          'Low Average',
          'Below Average'
        ], onTap: (title) {
          debugPrint(title);
          _difficultyLevel.text = title;
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    teacherHomePageController.getDefinedCourses(pageController);
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: AutoSizeText(
          'Available Courses',
          maxLines: 1,
          style: GoogleFonts.poppins(
              color: textColor, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: backGroundColor,
      ),
      backgroundColor: backGroundColor,
      body: PageView(
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [getSecondPage(), getFirstPage(context)],
      ),
    ));
  }
}
