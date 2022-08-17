import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbols.dart';
import 'package:intl/intl.dart';
import 'package:thefuture/MiscFiles/GetDialog.dart';
import 'package:thefuture/StudentFiles/StudentProfile.dart';
import 'package:thefuture/StudentFiles/courseOverview.dart';
import 'package:thefuture/globals.dart';

class StudentController extends GetxController {
  ListView definedCoursesNames = ListView();
  CollectionReference definedCourses =
      FirebaseFirestore.instance.collection('definedCourses');
  CollectionReference designedCourses =
      FirebaseFirestore.instance.collection('designedCourses');
  CollectionReference joinedCourses =
      FirebaseFirestore.instance.collection('joinedCourses');
  ListView joinedCoursesNames = ListView();
    CollectionReference entries =
      FirebaseFirestore.instance.collection('Entries');
  late QuerySnapshot<Object?> courseOverView_DesignCourse;
  bool courseOverView_DesignCourse_initialized = false;
  late DocumentSnapshot<Object?> courseOverView_DefineCourse;
  late var fToast;
  List<String> allSubjectNames = [];
  void getDefinedCourses(BuildContext context) async {
    var definedCoursesListTile = [];
    EasyLoading.show();
    fToast = FToast();
    fToast.init(context);
    definedCourses
        .where('startDate', isGreaterThan: DateTime.now())
        .get()
        .then((value) {
      EasyLoading.dismiss();
      for (var element in value.docs) {
        definedCoursesListTile.add(ListTile(
            onTap: () {
              Get.bottomSheet(
                  BottomSheet(
                      enableDrag: false,
                      clipBehavior: Clip.antiAlias,
                      onClosing: () {},
                      builder: ((BuildContext context) {
                        return Container(
                            decoration: BoxDecoration(color: backGroundColor),
                            height: MediaQuery.of(context).size.height * 0.9,
                            width: MediaQuery.of(context).size.width,
                            child: Scaffold(
                              appBar: AppBar(
                                backgroundColor: backGroundColor,
                                elevation: 0,
                                title: Icon(
                                  Icons.linear_scale_outlined,
                                  color: textColor,
                                ),
                                centerTitle: true,
                                leading: Container(),
                              ),
                              backgroundColor: backGroundColor,
                              body: SingleChildScrollView(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white),
                                            padding: const EdgeInsets.all(5),
                                            child: Icon(
                                              Icons.book_outlined,
                                              color: textColor,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 0, 0),
                                            child: Text(
                                              'Course Details',
                                              style: GoogleFonts.poppins(
                                                  color: textColor
                                                      .withOpacity(0.5),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            40, 10, 0, 10),
                                        child: Text(
                                          (element.data() as Map)['courseName'],
                                          style: GoogleFonts.poppins(
                                              color: textColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white),
                                            padding: const EdgeInsets.all(5),
                                            child: Icon(
                                              Icons.person,
                                              color: textColor,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 0, 0),
                                            child: Text(
                                              'Created By',
                                              style: GoogleFonts.poppins(
                                                  color: textColor
                                                      .withOpacity(0.5),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            40, 0, 0, 10),
                                        child: Text(
                                          (element.data() as Map)['createdBy'],
                                          style: GoogleFonts.poppins(
                                              color: textColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white),
                                            padding: const EdgeInsets.all(5),
                                            child: Icon(
                                              Icons.start_rounded,
                                              color: textColor,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 0, 0),
                                            child: Text(
                                              'Course Start Date',
                                              style: GoogleFonts.poppins(
                                                  color: textColor
                                                      .withOpacity(0.5),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            40, 0, 0, 10),
                                        child: Text(
                                          DateFormat('dd MMM yyyy').format(
                                              DateTime.fromMillisecondsSinceEpoch(
                                                  ((element.data() as Map)[
                                                              'startDate']
                                                          as Timestamp)
                                                      .millisecondsSinceEpoch)),
                                          style: GoogleFonts.poppins(
                                              color: textColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white),
                                            padding: const EdgeInsets.all(5),
                                            child: Icon(
                                              Icons.article_rounded,
                                              color: textColor,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 0, 0),
                                            child: Text(
                                              'First Sessional Date',
                                              style: GoogleFonts.poppins(
                                                  color: textColor
                                                      .withOpacity(0.5),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            40, 0, 0, 10),
                                        child: Text(
                                          DateFormat('dd MMM yyyy').format(
                                              DateTime.fromMillisecondsSinceEpoch(
                                                  ((element.data() as Map)[
                                                              'firstSessionalDate']
                                                          as Timestamp)
                                                      .millisecondsSinceEpoch)),
                                          style: GoogleFonts.poppins(
                                              color: textColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white),
                                            padding: const EdgeInsets.all(5),
                                            child: Icon(
                                              Icons.hourglass_bottom_rounded,
                                              color: textColor,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 0, 0),
                                            child: Text(
                                              'Mid Term Date',
                                              style: GoogleFonts.poppins(
                                                  color: textColor
                                                      .withOpacity(0.5),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            40, 0, 0, 10),
                                        child: Text(
                                          DateFormat('dd MMM yyyy').format(
                                              DateTime.fromMillisecondsSinceEpoch(
                                                  ((element.data() as Map)[
                                                              'midTermDate']
                                                          as Timestamp)
                                                      .millisecondsSinceEpoch)),
                                          style: GoogleFonts.poppins(
                                              color: textColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white),
                                            padding: const EdgeInsets.all(5),
                                            child: Icon(
                                              Icons.article_rounded,
                                              color: textColor,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 0, 0),
                                            child: Text(
                                              'Second Sessional Date',
                                              style: GoogleFonts.poppins(
                                                  color: textColor
                                                      .withOpacity(0.5),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            40, 0, 0, 10),
                                        child: Text(
                                          DateFormat('dd MMM yyyy').format(
                                              DateTime.fromMillisecondsSinceEpoch(
                                                  ((element.data() as Map)[
                                                              'secondSessionalDate']
                                                          as Timestamp)
                                                      .millisecondsSinceEpoch)),
                                          style: GoogleFonts.poppins(
                                              color: textColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white),
                                            padding: const EdgeInsets.all(5),
                                            child: Icon(
                                              Icons.done_all_rounded,
                                              color: textColor,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 0, 0),
                                            child: Text(
                                              'Final Exam',
                                              style: GoogleFonts.poppins(
                                                  color: textColor
                                                      .withOpacity(0.5),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            40, 0, 0, 10),
                                        child: Text(
                                          DateFormat('dd MMM yyyy').format(
                                              DateTime.fromMillisecondsSinceEpoch(
                                                  ((element.data() as Map)[
                                                              'finalExamDate']
                                                          as Timestamp)
                                                      .millisecondsSinceEpoch)),
                                          style: GoogleFonts.poppins(
                                              color: textColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white),
                                            padding: const EdgeInsets.all(5),
                                            child: Icon(
                                              Icons.info,
                                              color: textColor,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 0, 0),
                                            child: Text(
                                              'Instructions',
                                              style: GoogleFonts.poppins(
                                                  color: textColor
                                                      .withOpacity(0.5),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            40, 0, 0, 10),
                                        child: Text(
                                          (element.data()
                                              as Map)['instructions'],
                                          style: GoogleFonts.poppins(
                                              color: textColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 20),
                                          child: TextButton(
                                              style: TextButton.styleFrom(
                                                  backgroundColor: buttonColor,
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  elevation: 2,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  shadowColor: backGroundColor),
                                              onPressed: () {
                                                EasyLoading.show();
                                                designedCourses
                                                    .where('fatherID',
                                                        isEqualTo: element.id)
                                                    .get()
                                                    .then(
                                                  (value) {
                                                    if (value.docs.isNotEmpty) {
                                                      EasyLoading.dismiss();
                                                      int randomNumber =
                                                          Random().nextInt(value
                                                              .docs.length);
                                                      String courseType = (value
                                                                          .docs[
                                                                              randomNumber]
                                                                          .data()
                                                                      as Map)[
                                                                  'courseType'] ==
                                                              'profileBased'
                                                          ? 'Personalized Content Recommendation'
                                                          : 'Rule Based Adaptive Learning';
                                                      String courseTypeExplain = (value
                                                                          .docs[
                                                                              randomNumber]
                                                                          .data()
                                                                      as Map)[
                                                                  'courseType'] ==
                                                              'profileBased'
                                                          ? 'It will collect your personalized data through survey and data entry fields, and then use that information to improve upon your course content'
                                                          : 'It will gauge your performance & interests during the course, and will tailor course content accordingly.';
                                                      getDialog(context, () {
                                                        EasyLoading.show();
                                                        joinedCourses
                                                            .where(
                                                                'studentName',
                                                                isEqualTo:
                                                                    globalUserName)
                                                            .where('designID',
                                                                isEqualTo: value
                                                                    .docs[
                                                                        randomNumber]
                                                                    .id)
                                                            .where('defineID',
                                                                isEqualTo:
                                                                    element.id)
                                                            .get()
                                                            .then(
                                                                (checkDuplicate) {
                                                          if (checkDuplicate
                                                              .docs.isEmpty) {
                                                            joinedCourses.add({
                                                              'studentName':
                                                                  globalUserName,
                                                              'designID': value
                                                                  .docs[
                                                                      randomNumber]
                                                                  .id,
                                                              'defineID':
                                                                  element.id,
                                                              'courseType': (value
                                                                          .docs[
                                                                              randomNumber]
                                                                          .data()
                                                                      as Map)['courseType']
                                                                  .toString(),
                                                              'formFilled':
                                                                  false,
                                                              'courseStartDate':
                                                                  (element.data()
                                                                          as Map)[
                                                                      'startDate'],
                                                              'courseEndDate':
                                                                  (element.data()
                                                                          as Map)[
                                                                      'finalExamDate'],
                                                              'courseName': (element
                                                                          .data()
                                                                      as Map)[
                                                                  'courseName'],
                                                              'teacherName': (value
                                                                      .docs[
                                                                          randomNumber]
                                                                      .data()
                                                                  as Map)['userID']
                                                            }).then(
                                                                (addedValue) {
                                                              EasyLoading
                                                                  .dismiss();
                                                              if ((value.docs[randomNumber]
                                                                              .data()
                                                                          as Map)['courseType']
                                                                      .toString() ==
                                                                  'profileBased') {
                                                                fToast.showToast(
                                                                    child: getToast(
                                                                        JelloIn(
                                                                            child:
                                                                                const Icon(FontAwesomeIcons.info)),
                                                                        'Course joined. Work Hard !'));
                                                                Get.close(2);
                                                                // Get.
                                                                Get.to(() =>
                                                                    StudentProfile(
                                                                      parentDocument:
                                                                          addedValue
                                                                              .id,
                                                                    ));
                                                              } else {
                                                                fToast.showToast(
                                                                    child: getToast(
                                                                        JelloIn(
                                                                            child:
                                                                                const Icon(FontAwesomeIcons.info)),
                                                                        'Course joined. Work Hard !'));
                                                                Get.close(3);
                                                              }
                                                            }).onError((error,
                                                                stackTrace) {
                                                              EasyLoading
                                                                  .dismiss();
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      'Error: $error',
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .BOTTOM,
                                                                  timeInSecForIosWeb:
                                                                      1,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .grey,
                                                                  textColor:
                                                                      Colors
                                                                          .black,
                                                                  fontSize:
                                                                      16.0);
                                                            });
                                                          } else {
                                                            fToast.showToast(
                                                                child: getToast(
                                                                    JelloIn(
                                                                        child: const Icon(
                                                                            FontAwesomeIcons.cancel)),
                                                                    'Join again? Eh.'));
                                                            EasyLoading
                                                                .dismiss();
                                                            Get.close(3);
                                                          }
                                                        });
                                                      },
                                                          'Cancel',
                                                          'I Agree',
                                                          'Disclousure: Do you agree?',
                                                          'The course is "$courseType" based which means that: \n$courseTypeExplain.');
                                                    } else {
                                                      fToast.showToast(
                                                          child: getToast(
                                                              JelloIn(
                                                                  child: const Icon(
                                                                      FontAwesomeIcons
                                                                          .cancel)),
                                                              'No course material available.'));
                                                      Get.close(2);
                                                    }
                                                  },
                                                ).onError((error, stackTrace) {
                                                  Fluttertoast.showToast(
                                                      msg: 'Error: $error',
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor:
                                                          Colors.grey,
                                                      textColor: Colors.black,
                                                      fontSize: 16.0);
                                                  EasyLoading.dismiss();
                                                });
                                              },
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.done_rounded,
                                                    color: textColor,
                                                    size: 15,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(20, 0, 10, 0),
                                                    child: AutoSizeText(
                                                      'Join Course',
                                                      minFontSize: 15,
                                                      style:
                                                          GoogleFonts.poppins(
                                                              color: textColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  )
                                                ],
                                              )),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ));
                      })),
                  clipBehavior: Clip.antiAlias,
                  ignoreSafeArea: true,
                  isScrollControlled: true,
                  enableDrag: false);
            },
            title: Text(
              (element.data() as Map)['courseName'],
              style: GoogleFonts.poppins(
                  color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    'Created on ${DateFormat('dd MMM yyyy').format(DateTime.fromMillisecondsSinceEpoch(((element.data() as Map)['createdOn'] as Timestamp).millisecondsSinceEpoch))}'),
              ],
            )));
      }
      EasyLoading.dismiss();
      definedCoursesNames = ListView.builder(
          itemCount: definedCoursesListTile.length,
          itemBuilder: ((context, index) {
            return definedCoursesListTile[index];
          }));
      update();
    }).onError((error, stackTrace) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(
          msg: 'Error: $error',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.black,
          fontSize: 16.0);
    });
  }

  void getJoinedCourses() async {
    var data = await joinedCourses
        .where('studentName', isEqualTo: globalUserName)
        .get();
    if (data.docs.isNotEmpty) {
      var joinedCoursesListTileTemp = [];
      for (var element in data.docs) {
        joinedCoursesListTileTemp.add(ListTile(
            onTap: () {
              if (((element.data() as Map)['formFilled'] as bool) == true) {
                Get.to(CourseOverView(
                  designID: (element.data() as Map)['designID'],
                  parentID: element.id,
                  defineID: (element.data() as Map)['defineID'],
                ));
              } else {
                Get.to(StudentProfile(
                  parentDocument: element.id,
                ));
              }
            },
            title: Text(
              (element.data() as Map)['courseName'],
              style: GoogleFonts.poppins(
                  color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Designed By: ${(element.data() as Map)['teacherName']}',
                  style:
                      TextStyle(color: textColor, fontWeight: FontWeight.bold),
                ),
                Text(
                    'Starting On ${DateFormat('dd MMM yyyy').format(DateTime.fromMillisecondsSinceEpoch(((element.data() as Map)['courseStartDate'] as Timestamp).millisecondsSinceEpoch))}'),
                Text(
                    'Terminating On ${DateFormat('dd MMM yyyy').format(DateTime.fromMillisecondsSinceEpoch(((element.data() as Map)['courseEndDate'] as Timestamp).millisecondsSinceEpoch))}'),
              ],
            )));
      }
      EasyLoading.dismiss();
      joinedCoursesNames = ListView.builder(
          itemCount: joinedCoursesListTileTemp.length,
          itemBuilder: ((context, index) {
            return joinedCoursesListTileTemp[index];
          }));
      update();
    }
  }

  Future<void> getCourseDetails(
      String documentIDDesign, String documentIDDefine) async {
    EasyLoading.show();
    courseOverView_DesignCourse =
        await entries.where('designURL',isEqualTo: documentIDDesign).get();
    courseOverView_DefineCourse =
        await definedCourses.doc(documentIDDefine).get();
    EasyLoading.dismiss();
    courseOverView_DesignCourse_initialized = true;
    update();
  }
}
