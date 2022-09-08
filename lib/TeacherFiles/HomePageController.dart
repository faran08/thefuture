// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:thefuture/TeacherFiles/EditCourseDesign.dart';

import '../globals.dart';

class TeacherHomePageController extends GetxController {
  late Widget teacherName = SpinKitThreeBounce(
    color: buttonColor,
  );
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  CollectionReference definedCourses =
      FirebaseFirestore.instance.collection('definedCourses');
  CollectionReference designedCourses =
      FirebaseFirestore.instance.collection('designedCourses');
  CollectionReference subjects =
      FirebaseFirestore.instance.collection('Subjects');
  ListView definedCoursesNames = ListView();
  ListView joinedCoursesNames = ListView();
  late Map teacherSelectedCourse = {};
  List<String> tagsList = [];
  String designNewCourse_selectedCourse = '';
  Map selectedCourseData = {};
  bool courseEmpty = true;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> definedCourseEntriesDate =
      [];

  void updateTeacherName(String documentID) async {
    users.doc(documentID).get().then((value) {
      teacherName = AutoSizeText(
        'Welcome, ${(value.data() as Map)['userName']} !',
        maxLines: 1,
        style: GoogleFonts.poppins(
            fontSize: 20, color: textColor, fontWeight: FontWeight.bold),
      );
      update();
    });
  }

  void loadCourseTags(String subjectName) async {
    tagsList.clear();
    List<String> tempList = [];
    var resultSubjects = await subjects
        .where('subjectName', isEqualTo: subjectName)
        .limit(1)
        .get();

    if (resultSubjects.docs.isNotEmpty) {
      for (var element
          in (resultSubjects.docs.first.data() as Map)['subTags']) {
        tempList.add(element);
      }
      for (var element in tempList) {
        tagsList.add(element);
      }
      update();
    }
  }

  void getDefinedCourses(PageController pageController) async {
    var definedCoursesListTile = [];

    definedCourses
        .where('startDate',
            isGreaterThanOrEqualTo: DateTime(DateTime.now().year,
                DateTime.now().month, DateTime.now().day, 0))
        .get()
        .then((value) {
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
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white),
                                            padding: EdgeInsets.all(5),
                                            child: Icon(
                                              Icons.book_outlined,
                                              color: textColor,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
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
                                        padding:
                                            EdgeInsets.fromLTRB(40, 10, 0, 10),
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
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white),
                                            padding: EdgeInsets.all(5),
                                            child: Icon(
                                              Icons.person,
                                              color: textColor,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
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
                                        padding:
                                            EdgeInsets.fromLTRB(40, 0, 0, 10),
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
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white),
                                            padding: EdgeInsets.all(5),
                                            child: Icon(
                                              Icons.start_rounded,
                                              color: textColor,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
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
                                        padding:
                                            EdgeInsets.fromLTRB(40, 0, 0, 10),
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
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white),
                                            padding: EdgeInsets.all(5),
                                            child: Icon(
                                              Icons.article_rounded,
                                              color: textColor,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
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
                                        padding:
                                            EdgeInsets.fromLTRB(40, 0, 0, 10),
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
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white),
                                            padding: EdgeInsets.all(5),
                                            child: Icon(
                                              Icons.hourglass_bottom_rounded,
                                              color: textColor,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
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
                                        padding:
                                            EdgeInsets.fromLTRB(40, 0, 0, 10),
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
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white),
                                            padding: EdgeInsets.all(5),
                                            child: Icon(
                                              Icons.article_rounded,
                                              color: textColor,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
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
                                        padding:
                                            EdgeInsets.fromLTRB(40, 0, 0, 10),
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
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white),
                                            padding: EdgeInsets.all(5),
                                            child: Icon(
                                              Icons.done_all_rounded,
                                              color: textColor,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
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
                                        padding:
                                            EdgeInsets.fromLTRB(40, 0, 0, 10),
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
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white),
                                            padding: EdgeInsets.all(5),
                                            child: Icon(
                                              Icons.info,
                                              color: textColor,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
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
                                        padding:
                                            EdgeInsets.fromLTRB(40, 0, 0, 10),
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
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 20),
                                          child: TextButton(
                                              style: TextButton.styleFrom(
                                                  backgroundColor: buttonColor,
                                                  padding: EdgeInsets.all(10),
                                                  elevation: 2,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  shadowColor: backGroundColor),
                                              onPressed: () {
                                                selectedCourseData['courseID'] =
                                                    element.id;
                                                selectedCourseData.addAll(
                                                    (element.data() as Map));
                                                update();
                                                Fluttertoast.showToast(
                                                    msg:
                                                        'Course Selected, Press Save.',
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                        Colors.grey,
                                                    textColor: Colors.black,
                                                    fontSize: 16.0);
                                                Get.back();
                                                pageController.nextPage(
                                                    duration: Duration(
                                                        milliseconds: 500),
                                                    curve: Curves.easeInExpo);
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
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            20, 0, 10, 0),
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
                Text('Created by ' + (element.data() as Map)['createdBy']),
                Text('Created on ' +
                    DateFormat('dd MMM yyyy').format(
                        DateTime.fromMillisecondsSinceEpoch(
                            ((element.data() as Map)['createdOn'] as Timestamp)
                                .millisecondsSinceEpoch))),
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
    });
  }

  void getJoinedCourses() async {
    var data = await designedCourses
        .where('userID', isEqualTo: globalUserName)
        .where('finalExamDate',
            isGreaterThan: Timestamp.fromDate(DateTime.now()))
        .get();
    if (data.docs.isNotEmpty) {
      var joinedCoursesListTileTemp = [];
      for (var element in data.docs) {
        joinedCoursesListTileTemp.add(ListTile(
            onTap: () {
              Get.to(EditDesignCourse(
                documentData: element,
              ));
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
                Text('Starting On ' +
                    DateFormat('dd MMM yyyy').format(
                        DateTime.fromMillisecondsSinceEpoch(
                            ((element.data() as Map)['startDate'] as Timestamp)
                                .millisecondsSinceEpoch))),
                Text('Terminating On ' +
                    DateFormat('dd MMM yyyy').format(
                        DateTime.fromMillisecondsSinceEpoch(((element.data()
                                as Map)['finalExamDate'] as Timestamp)
                            .millisecondsSinceEpoch))),
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

  void getJoiendCoursesEntriesDate(String documentID) {
    designedCourses.doc().collection('Entries').get().then((value) {
      if (value.docs.isNotEmpty) {
        definedCourseEntriesDate = value.docs;
        update();
      }
    });
  }
}
